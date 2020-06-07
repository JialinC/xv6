#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h" //J edited
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;
volatile int readcounter = 0; //J
struct spinlock l_r_c; //J
struct spinlock sched_lock; //J
// start() jumps here in supervisor mode on all CPUs.
void
main()
{
  if(cpuid() == 0){
    initlock(&l_r_c,"readcounter"); //J
    initlock(&sched_lock,"scheduler"); //J
    consoleinit();
    printfinit();
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");

    kinit();         // physical page allocator
    //printf("kinit works\n");
    //printf("\n");

    kvminit();       // create kernel page table
    //printf("kvminit works\n");
    //printf("\n");

    kvminithart();   // turn on paging
    //printf("kvminithart works\n");
    //printf("\n");

    procinit();      // process table
    //printf("procinit works\n");
    //printf("\n");

    trapinit();      // trap vectors
    //printf("trapinit works\n");
    //printf("\n");

    trapinithart();  // install kernel trap vector
    //printf("trapinithart works\n");
    //printf("\n");

    plicinit();      // set up interrupt controller
    //printf("plicinit works\n");
    //printf("\n");

    plicinithart();  // ask PLIC for device interrupts
    //printf("plicinithart works\n");
    //printf("\n");

    binit();         // buffer cache
    //printf("binit works\n");
    //printf("\n");

    iinit();         // inode cache
    //printf("iinit works\n");
    //printf("\n");

    fileinit();      // file table
    //printf("fileinit works\n");
    //printf("\n");

    virtio_disk_init(); // emulated hard disk
    //printf("disk_init works\n");
    //printf("\n");
    //printf("check point a\n");
    userinit();      // first user process
    //printf("check point b\n");
    //printf("userinit works\n");
    //printf("\n");

    __sync_synchronize();
    //printf("synchronize works\n");
    //printf("\n");
    started = 1;
  } else {
    while(started == 0)
      ;
    __sync_synchronize();
    printf("hart %d starting\n", cpuid());
    kvminithart();    // turn on paging
    trapinithart();   // install kernel trap vector
    plicinithart();   // ask PLIC for device interrupts
  }
  //printf("cpu:%d,scheduler\n",cpuid());
  //for(;;){
    //acquire(&sched_lock);
    //printf("a\n");
    //int noff;
    //noff= scheduler();
    //noff--;
    //printf("b, noff:%d\n", noff);
    //release(&sched_lock);
   //}
   scheduler();        
}
