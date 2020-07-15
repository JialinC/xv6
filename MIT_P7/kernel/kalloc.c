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

struct run {
  struct run *next;
};


struct kmem {
  struct spinlock lock;
  struct run *freelist;
};

struct kmem kmemlist[NCPU];


void
kinit()
{
  push_off();
  int hart = cpuid();
  pop_off();
  initlock(&kmemlist[hart].lock, "kmem");
  uint64 length = (PHYSTOP - (uint64)end)/NCPU;
  uint64 start = PGROUNDUP((uint64)end + hart*length);
  uint64 finish;
  if(hart == 2)
    finish = PHYSTOP;
  else
    finish = PGROUNDUP((uint64)end + (hart+1)*length);
  freerange((void*)start, (void*)finish);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
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

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  push_off();
  int hart = cpuid();
  pop_off();

  acquire(&kmemlist[hart].lock);
  r->next = kmemlist[hart].freelist;
  kmemlist[hart].freelist = r;
  release(&kmemlist[hart].lock);
}
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  push_off();
  int hart = cpuid();
  pop_off();

  acquire(&kmemlist[hart].lock);
  r = kmemlist[hart].freelist;
  if(r)
    kmemlist[hart].freelist = r->next;
  release(&kmemlist[hart].lock);

  if(!r){
    int next = (hart+1)%NCPU;

    while(next!=hart){
      acquire(&kmemlist[next].lock);
      r = kmemlist[next].freelist;
      if(r){
        kmemlist[next].freelist = r->next;
        release(&kmemlist[next].lock);
        break;
      }
      release(&kmemlist[next].lock);
      next = (next+1)%NCPU;
    }
  }

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}