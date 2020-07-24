#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "elf.h"
#include "riscv.h"
#include "defs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "proc.h"
#include "fcntl.h"
/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

extern struct proc proc[];

void print(pagetable_t);

/*
 * create a direct-map page table for the kernel and
 * turn on paging. called early, in supervisor mode.
 * the page allocator is already initialized.
 */
void
kvminit()
{
  kernel_pagetable = (pagetable_t) kalloc();
  memset(kernel_pagetable, 0, PGSIZE);

  // uart registers
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface 0
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface 1
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);

  // CLINT
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);

  // PLIC
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);

  // map kernel text executable and read-only.
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return 0;
  if((*pte & PTE_V) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(uint64 va, uint64 pa, uint64 sz, int perm)
{
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
  uint64 off = va % PGSIZE;
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
  if(pte == 0)
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    panic("kvmpa");
  pa = PTE2PA(*pte);
  return pa+off;
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// Remove mappings from a page table. The mappings in
// the given range must exist. Optionally free the
// physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 size, int do_free)
{
  uint64 a, last;
  pte_t *pte;
  uint64 pa;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for(;;){
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0){
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    if(do_free){
      pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
}

// create an empty user page table.
pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
  if(pagetable == 0)
    panic("uvmcreate: out of memory");
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
  memmove(mem, src, sz);
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  a = oldsz;
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if(newsz >= oldsz)
    return oldsz;

  uint64 newup = PGROUNDUP(newsz);
  if(newup < PGROUNDUP(oldsz))
    uvmunmap(pagetable, newup, oldsz - newup, 1);

  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    }
  }
  kfree((void*)pagetable);
}

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, 0, sz, 1);
  freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
  return -1;
}

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
  if(pte == 0)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
        got_null = 1;
        break;
      } else {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    return 0;
  } else {
    return -1;
  }
}






//struct {
//  struct spinlock lock;
//  struct vma vma[NBVMA];
//  struct vma head;
//} vmalist;

//void
//vmainit(void)
//{
//  struct vma *b;
//  initlock(&vmalist.lock, "vmalist");
  // Create linked list of buffers
//  vmalist.head.prev = &vmalist.head;
//  vmalist.head.next = &vmalist.head;
//  for(b = vmalist.vma; b < vmalist.vma+NBVMA; b++){
//    b->next = vmalist.head.next;
//    b->prev = &vmalist.head;
//    vmalist.head.next->prev = b;
//    vmalist.head.next = b;
//  }
//}
//void *mmap(void *addr, uint length, int prot, int flags, int fd, int offset);
uint64
sys_mmap(void)
{
  uint64 addr;
  int length;
  int prot;
  int flag;
  struct file *f;
  int offset;

  
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flag) < 0 \
                           || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0 )
    return -1;

  if(flag == MAP_SHARED && (prot ==(PROT_READ|PROT_WRITE)) && !f->writable)
    return 0xffffffffffffffff;
  //int fdcheck;
  //argint(4, &fdcheck); 
  //printf("addr: %p\n",addr);
  //printf("length: %d\n",length);
  //printf("prot: %d\n",prot);
  //printf("flag: %d\n",flag);
  //printf("fdcheck: %d\n",fdcheck);
  //printf("offset: %d\n",offset);


  struct proc *p = myproc();
  struct vma *vma;
  for(vma = p->vma; vma < &p->vma[NBVMA]; vma++){
    if(!vma->inuse)
      break;
  }
  if(!vma)
    return 0xffffffffffffffff;

  uint64 va = KSTACK(NPROC+1);
  //printf("va1: %p\n",va);
  va = va - PGSIZE - (vma - p->vma + 1)*MAXFILE*1024;
  //printf("(vma - p->vma)*MAXFILE*1024: %p\n",(vma - p->vma + 1)*MAXFILE*1024);
  //printf("va2: %p\n",va);
  vma->inuse = 1;
  vma->address = va;
  vma->length = length;
  vma->prot = prot;
  vma->flags = flag;
  vma->f = f;
  vma->offset = offset;
  //printf("vma->inuse: %p\n",vma->inuse);
  //printf("vma->address: %p\n", vma->address);
  //printf("vma->length: %p\n",vma->length);
  //printf("vma->prot: %p\n",vma->prot);
  //printf("vma->flags: %p\n",vma->flags);
  //printf("vma->f: %p\n",vma->f);
  filedup(f);

  return va;
}

uint64
munmap(uint64 addr,int length){
  struct proc *p = myproc();
  struct vma *vma;
  int found = 0;
      
  int i = 1;
  for(vma = p->vma; vma < &p->vma[NBVMA]; vma++){
    //printf("looped: %d\n",i);
    //printf("vma->address: %p\n",vma->address);
    //printf("(vma->address + vma->length): %p\n",(vma->address + vma->length));
    if(addr >= vma->address && (addr + length) <= (vma->address + vma->length)){
      found = 1;
      //printf("vma->address: %p\n",vma->address);
      //printf("vma->length: %p\n",vma->length);
      break;
    }
    i++;
  }

  if(!found){
    return 0xffffffffffffffff;
  }
  else{//found one
    //printf("addr: %p\n",addr+1);
    //printf("PGROUNDDOWN(addr): %p\n",PGROUNDDOWN(addr+1));
    //printf("PGROUNDUP(addr): %p\n",PGROUNDUP(addr+1));
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    if(addr == vma->address && length == vma->length){//only dedup when the whole area is released
      //printf("filededup\n");
      filededup(vma->f);
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(vma->flags == MAP_SHARED){
      int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE; //3072
      int r = 0;
      int i = 0;
      
      while(i < length){
        if(walkaddr(p->pagetable,addr+i)){
          int j = 0;
          while(j < PGSIZE){
            int n1 = PGSIZE - j;
            if(n1 > max)
              n1 = max;
            begin_op(vma->f->ip->dev);
            ilock(vma->f->ip);
            if((r = writei(vma->f->ip, 1, addr + i + j, i + j + vma->offset, n1))>0)
              j+=r;
            iunlock(vma->f->ip);
            end_op(vma->f->ip->dev);
            if(r < 0)
              break;
            if(r != n1)
              panic("short filewrite");    
          }
          if(j!=PGSIZE)
            panic("short filewrite");
        }
        i+=PGSIZE;
      }
    }

    if(addr == vma->address){
      //printf("addr == vma->address\n");
      vma->address = vma->address+length;
      vma->length = vma->length - length;
      vma->offset = length;
    }
    else{
      vma->length = vma->length - length;
    }

    //printf("length: %p\n",length);
    int k=0;
    while(k<length){
      if(walkaddr(p->pagetable,addr+k)){
        //printf("freed\n");
        uvmunmap(p->pagetable, addr+k, PGSIZE, 1);
      }
      k+=PGSIZE;
    }
    //if(vma->flag == MAP_SHARED){
      //if(!walkaddr(p->pagetable, addr))
    if(vma->length==0){
      vma->inuse = 0;
      vma->address = 0;
      vma->length = 0;
      vma->prot = -1;
      vma->flags = -1;
      vma->f = 0;
      vma->offset = 0;
    }
  }  
  return 0;

}

//int munmap(void *addr, uint length);
uint64
sys_munmap(void)
{
  uint64 addr;
  int length;
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    return -1;

  //printf("addr: %p\n",addr);
  //printf("length: %d\n",length);
  return munmap(addr,length);
}

//struct vma {
//  int inuse;
//  uint64 address;
//  int proc;
//  uint length;
//  int prot;
//  int flags;
//  struct file *f;
//};









