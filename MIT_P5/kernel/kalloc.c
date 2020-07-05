// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.
struct spinlock REFlock;
char PGREF[32768];
struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&REFlock, "REF");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  //int i = 0;
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  printf("pa_start: %p\n",pa_start);
  //printf("pa_end: %p\n",pa_end);
  int total = 0;
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    PGREF[((uint64)p-(uint64)end)/PGSIZE] = 0;
    kfree(p);
    total++;
  }
  printf("total page: %d",total);

  //printf("pgnum: %d\n",i);
  //for(int j =0;j<32768;j++){
    //PGREF[j] = PGREF[j]+4;
  //  printf("PGREF: %d",PGREF[j]);
  //}
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&REFlock);
  if(PGREF[((uint64)pa-(uint64)end)/PGSIZE] != 0){
    PGREF[((uint64)pa-(uint64)end)/PGSIZE]--;
  }
  
  if(PGREF[((uint64)pa-(uint64)end)/PGSIZE] == 0){
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
  }
  release(&REFlock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);
  //printf("r %p\n",*r);
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  //printf("b\n");
  //printf("((uint64)r-(uint64)end)/PGSIZE: %d",((uint64)r-(uint64)end)/PGSIZE);
  acquire(&REFlock);
  //printf("r: %p, end: %p, limit: %d",(uint64)r,(uint64)end,((uint64)r-(uint64)end)/PGSIZE);
  if(r)
    PGREF[((uint64)r-(uint64)end)/PGSIZE]++;
  release(&REFlock);
  //printf("a\n");
  return (void*)r;
}


void
printalloc(int n)
{ 
  int total=0;
  //acquire(&REFlock);
  for(int i=0;i<32768;i++){
    if(PGREF[i]!=0){
      total++;
      if(n)
        printf("i: %d PGREF[i]: %d\n",i,PGREF[i]);
    }
  }
  //release(&REFlock);
  printf("Unfrred: %d\n",total);
}