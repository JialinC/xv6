#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "pstat.h" //p2b

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void wakeup1(struct proc *chan);

extern char trampoline[]; // trampoline.S

void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      //printf("procinit p:%p\n", p);
      //printf("procinit proc:%p\n", proc);
      //printf("procinit p:%p\n", p - proc);
      // Allocate a page for the process's kernel stack.
      // Map it high in memory, followed by an invalid
      // guard page.
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
      p->kstack = va;
      //printf("p - proc%p\n",p - proc);
  }
  kvminithart();
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  //printf("pop_off start in myproc\n");
  pop_off();
  //printf("pop_off success in myproc\n");
  return p;
}

int
allocpid() {
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  //acquire(&sched_lock);
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  //release(&sched_lock);
  return 0;

found:
  p->pid = allocpid();
  p->ticket = 1; //p2b
  p->start_tick = 0; //p2b
  p->total_tick = 0; //p2b

  // Allocate a trapframe page.
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    release(&p->lock);
    //release(&sched_lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof p->context); //write all zeros
  p->context.ra = (uint64)forkret; //return address
  p->context.sp = p->kstack + PGSIZE;

  return p;
  //ret//urn with sched_lock and plock held
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->tf)
    kfree((void*)p->tf);
  p->tf = 0;
  
  int islast = 1; //p4 added
  struct proc *pfree; 
  for(pfree = proc; pfree < &proc[NPROC]; pfree++) { //check if this is the last process/thread reference this pagetable
    if(pfree->pagetable == p->pagetable && pfree != p){
      islast = 0;
    }
  }

  if(p->pagetable && islast){ //free the pgtb only when this is the last reference
    //printf("proc_freepagetable wrong here a\n");
    //printf("p->pid %p\n",p->pid);
    //printf("p->name: %s\n",p->name);
    proc_freepagetable(p->pagetable, p->sz - PGSIZE, p); //p3 p4 add the p
  }else{
    uvmunmap(p->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0);
  }
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
  p->ticket = 0; //p2b
  p->start_tick = 0; //p2b
  p->total_tick = 0; //p2b
}

// Create a page table for a given process,
// with no user pages, but with trampoline pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  mappages(pagetable, TRAMPOLINE, PGSIZE,
           (uint64)trampoline, PTE_R | PTE_X);

  // map the trapframe just below TRAMPOLINE, for trampoline.S.
  //printf("proc_pagetable:p - proc%p\n",p - proc);
  //printf("TRAPFRAME:%p\n", TRAPFRAME);
  //printf("TRAPFRAME - 2*(p - proc)xPGSIZE:%p\n", TRAPFRAME-2*(p - proc)*PGSIZE);
  //printf("KSTACK:%p\n", p->kstack);
  //mappages(pagetable, TRAPFRAME, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W); //original
  mappages(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W); //p4 modified

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz, struct proc *p) //p4 struct proc *p self added
{
  //printf("proc_freepagetable:p - proc%p\n",p - proc);
  //printf("TRAPFRAME:%p\n", TRAPFRAME);
  //printf("TRAPFRAME - 2*(p - proc)xPGSIZE:%p\n", TRAPFRAME-2*(p - proc)*PGSIZE);
  //printf("KSTACK:%p\n", p->kstack);
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
  uvmunmap(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0); //p4 modified
  if(sz > 0){
    //printf("uvmfree wrong here a\n");
    uvmfree(pagetable, sz);
  }
}

// a user program that calls exec("/init")
// od -t xC initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x05, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x05, 0x02,
  0x9d, 0x48, 0x73, 0x00, 0x00, 0x00, 0x89, 0x48,
  0x73, 0x00, 0x00, 0x00, 0xef, 0xf0, 0xbf, 0xff,
  0x2f, 0x69, 0x6e, 0x69, 0x74, 0x00, 0x00, 0x01,
  0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00
};

// Set up first user process. main called this 
void
userinit(void)
{
  struct proc *p;

  p = allocproc(); //get the return address
  initproc = p;
  
  // allocate one user page and copy init's instructions
  // and data into it.
  uvminit(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->tf->epc = 0;      // user program counter
  p->tf->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
  //release(&sched_lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    //printf("freeproc wrong here a\n");
    freeproc(np);
    release(&np->lock);
    //release(&sched_lock);
    return -1;
  }
  np->sz = p->sz;
  np->ticket = p->ticket; //p2b added
  np->parent = p;
  //np->start_tick = 0;
  //np->total_tick = 0;
  // copy saved user registers.
  *(np->tf) = *(p->tf);

  // Cause fork to return 0 in the child.
  np->tf->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  np->state = RUNNABLE;

  release(&np->lock);
  //release(&sched_lock);

  return pid;
}
/////////////////////////////////////// kernel thread /////////////////////////////////////////////////////
// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, return 0.
static struct proc*
allocthread(struct proc *parent)
{
  struct proc *p;
  //acquire(&sched_lock);
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  //release(&sched_lock);
  return 0;

found:
  p->pid = allocpid();
  p->ticket = 1; //p2b
  p->start_tick = 0; //p2b
  p->total_tick = 0; //p2b
  //printf("thread ID: %d\n",p->pid);
  // Allocate a trapframe page.
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    release(&p->lock);
    //release(&sched_lock);
    return 0;
  }
  //mappages(pagetable, va, size, pa, int)
  //mappages(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W);
  mappages(parent->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W);

  // An empty user page table.
  //p->pagetable = proc_pagetable(p);

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof p->context); //write all zeros
  p->context.ra = (uint64)forkret; //return address
  p->context.sp = p->kstack + PGSIZE;

  return p;
  //ret//urn with sched_lock and plock held
}

// Create a new thread, copying the parent.
// Sets up thread kernel stack to return as if from the passed in function.
int
clone(void(*fcn)(void *, void *), void *arg1, void *arg2, void *stack)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
  //printf("check point e\n");
  //printf("stack %p\n",stack);
  if(((uint64)stack % PGSIZE) != 0) { //check the stack address is page aligned
    return -1;
  }
  
  // Allocate process.
  if((np = allocthread(p)) == 0){ //this gonna hold the lock,do not allocate a pgtb
  }

  //printf("check point f\n");
  //printf("p %p\n",p);
  //printf("np %p\n",np);
  //printf("p pid %p\n",p->pid);
  //printf("np pid %p\n",np->pid);

  np->stack = (uint64)stack; //self added PCB field
  np->pagetable = p->pagetable; //use the same pagetable
  np->sz = p->sz;
  //printf("inside clone proc sz: %d np size: %d\n", proc->sz, np->sz);
  np->ticket = p->ticket; //p2b added
  np->parent = p;
  
  //np->start_tick = 0;
  //np->total_tick = 0;
  // copy saved user registers.
  *(np->tf) = *(p->tf);
  uint64 sp;
  sp = (uint64)stack + PGSIZE; //stack top
  //set up argument
  np->tf->a0 = (uint64)arg1;
  np->tf->a1 = (uint64)arg2;
  //set stack pointer to stack
  np->tf->sp = sp;
  //set instruction pointer to function
  //printf("kernel fcn: %p\n",fcn );
  np->tf->epc = (uint64)fcn;
  //printf("check point g\n");
  //pte_t *pte;
  //pte = walk(p->pagetable, (uint64)stack, 0);
  //printf("VA:%p\n",(uint64)stack);
  //printf("PTE:%p\n",pte);
  //printf("PTE deference:%p\n",*pte);

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);
  //printf("check point g\n");

  safestrcpy(np->name, p->name, sizeof(p->name));
  //printf("check point h\n");
  pid = np->pid;
  np->state = RUNNABLE;
  //if(holding(&np->lock))
  //  printf("clone hold the thread lock\n");
  release(&np->lock);
  //release(&sched_lock);
  //printf("check point i\n");
  return pid;
}

int
sys_clone(void)
{
  //void (*fcn)(void*,void*);
  //void* arg1;
  //void* arg2;
  //void* stack;
  uint64 fcn;
  uint64 arg1;
  uint64 arg2;
  uint64 stack;

  if(argaddr(0, &fcn) < 0)
    return -1;
  if(argaddr(1, &arg1) < 0)
    return -1;
  if(argaddr(2, &arg2) < 0)
    return -1;
  if(argaddr(3, &stack) < 0)
    return -1;
  
  return clone((void(*)(void*,void*))fcn, (void*)arg1, (void*)arg2, (void*)stack);
  //printf("check point j\n");
}

int
join(uint64 stack)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
  uint64 ustack;
  //acquire(&sched_lock);
  // hold p->lock for the whole time to avoid lost
  // wakeups from a child's exit().
  acquire(&p->lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      // this code uses np->parent without holding np->lock.
      // acquiring the lock first would cause a deadlock,
      // since np might be an ancestor, and we already hold p->lock.
      //if(np->parent == p){ orignal condition
      if(np->parent == p ){
        // np->parent can't change between the check and the acquire()
        // because only the parent changes it, and we're the parent.
        acquire(&np->lock);
        havekids = 1;
        if(np->state == ZOMBIE){
          // Found one.
          pid = np->pid;
          ustack = np->stack;
          if(copyout(np->pagetable, stack, (char *)&ustack, sizeof(ustack)) < 0){
            release(&np->lock);
            release(&p->lock);
            //release(&sched_lock);
            return -1;
          }
          freeproc(np); 
          release(&np->lock);
          release(&p->lock);
          //release(&sched_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || p->killed){
      release(&p->lock);
      //release(&sched_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &p->lock);  //DOC: wait-sleep
  }
}



int sys_join(void)
{
  //void **stack = NULL;
  uint64 stack;
  if(argaddr(0, &stack) < 0)  {
    return -1;
  }
    return join(stack);
  return 0;
}
/////////////////////////////////////// kernel thread /////////////////////////////////////////////////////



// Pass p's abandoned children to init.
// Caller must hold p->lock.
void
reparent(struct proc *p)
{
  struct proc *pp;
  ////acquire(&sched_lock);
  for(pp = proc; pp < &proc[NPROC]; pp++){
    // this code uses pp->parent without holding pp->lock.
    // acquiring the lock first could cause a deadlock
    // if pp or a child of pp were also in exit()
    // and about to try to lock p.
    if(pp->parent == p){
      //if(pp->pagetable == p->pagetable){ //when parent exit and pp is a thread create by this p, give pp a copy of the pagetable
      //  pp->pagetable = proc_pagetable(pp);
      //  uvmcopy(p->pagetable, np->pagetable, p->sz);
      //}
      // pp->parent can't change between the check and the acquire()
      // because only the parent changes it, and we're the parent.
      acquire(&pp->lock);
      pp->parent = initproc;
      // we should wake up init here, but that would require
      // initproc->lock, which would be a deadlock, since we hold
      // the lock on one of init's children (pp). this is why
      // exit() always wakes init (before acquiring any locks).
      release(&pp->lock);
    }
  }
  ////releas(&sched_lock);
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  //acquire(&sched_lock);
  // we might re-parent a child to init. we can't be precise about
  // waking up init, since we can't acquire its lock once we've
  // acquired any other proc lock. so wake up init whether that's
  // necessary or not. init may miss this wakeup, but that seems
  // harmless.
  acquire(&initproc->lock);
  wakeup1(initproc);
  release(&initproc->lock);

  // grab a copy of p->parent, to ensure that we unlock the same
  // parent we locked. in case our parent gives us away to init while
  // we're waiting for the parent lock. we may then race with an
  // exiting parent, but the result will be a harmless spurious wakeup
  // to a dead or wrong process; proc structs are never re-allocated
  // as anything else.
  
  acquire(&p->lock);
  struct proc *original_parent = p->parent;
  release(&p->lock);
  
  // we need the parent's lock in order to wake it up from wait(). or join
  // the parent-then-child rule says we have to lock it first.
  acquire(&original_parent->lock);
  acquire(&p->lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup1(original_parent);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&original_parent->lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
  //printf("I'm I called?\n");
  //acquire(&sched_lock);
  // hold p->lock for the whole time to avoid lost
  // wakeups from a child's exit().
  acquire(&p->lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      // this code uses np->parent without holding np->lock.
      // acquiring the lock first would cause a deadlock,
      // since np might be an ancestor, and we already hold p->lock.
      //if(np->parent == p){ orignal condition
      if(np->parent == p && np->pagetable != p->pagetable ){ //p4 thread modified condition, only wait for forked process not thread
        // np->parent can't change between the check and the acquire()
        // because only the parent changes it, and we're the parent.
        acquire(&np->lock);
        havekids = 1;
        if(np->state == ZOMBIE){
          // Found one.
          pid = np->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                  sizeof(np->xstate)) < 0) {
            release(&np->lock);
            release(&p->lock);
            //release(&sched_lock);
            return -1;
          }
          //printf("freeproc wrong here b\n");
          freeproc(np); 
          release(&np->lock);
          release(&p->lock);
          //release(&sched_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || p->killed){
      release(&p->lock);
      //release(&sched_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &p->lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.

////////////////////////////////////////////////////// p2b /////////////////////////////////////////////////////////
///////////////////////////////////////////////////// settickets ///////////////////////////////////////////////////
int
settickets(int num, struct proc* p)
{
    if(num<1) //check
    {
	   return -1;
    }
    //acquire(&sched_lock); //for access the process table
    acquire(&p->lock);
    p->ticket = num;
    release(&p->lock);
    //release(&sched_lock);
    return 0;	
}

uint64
sys_settickets(void)
{ 
   int ticket;
   struct proc *p = myproc(); 
   if(argint(0, &ticket) < 0)
     return -1;
   return settickets(ticket,p);
}
///////////////////////////////////////////////////// settickets //////////////////////////////////////////////////

///////////////////////////////////////////////////// getpinfo ////////////////////////////////////////////////////
// Copy stat information from inode.
// Caller must hold ip->lock.
//void
//pstat_fill(struct pstat *st, int i)
//{
//  st->dev = ip->dev;
//  st->ino = ip->inum;
//  st->type = ip->type;
//  st->nlink = ip->nlink;
//  st->size = ip->size;
//}


int
getpinfo(uint64 addr)
{
    struct proc *p;
    int i = 0;
    struct pstat info;
    //printf("getpinfo1\n");
    //acquire(&sched_lock); //for access the process table
    //printf("getpinfo2\n");
    for(p = proc; p < &proc[NPROC]; p++) {
       //printf("getpinfo3\n");
       acquire(&p->lock);
       //printf("getpinfo4\n");
       //UNUSED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE
       if(p->state == UNUSED || p->state == ZOMBIE) {
         //printf("getpinfo5\n");
         info.inuse[i] = 0;
         //printf("getpinfo6\n");
	       info.tickets[i] = -1;
	       info.pid[i] = -1;
	       info.ticks[i] = 0;
       }
       else{
         //printf("getpinfo7\n");
	       info.inuse[i] = 1;
         //printf("getpinfo8\n");
         info.tickets[i] = p->ticket;
         info.pid[i] = p->pid;
         info.ticks[i] = p->total_tick;
       }
       i++;
       release(&p->lock);
       //printf("getpinfo9\n");
    }
    //release(&sched_lock); //for access the process table

    p = myproc();
    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
      return -1;
    return 0;
}

uint64
sys_getpinfo(void)
{	
    uint64 p; // user pointer to struct pstat
    if(argaddr(0, &p) < 0)
	     return -1;
    if(p < PGSIZE){
      printf("Invalid address!\n");
      return -1;
    }
    return getpinfo(p);
}
///////////////////////////////////////////////////// getpinfo //////////////////////////////////////////////////
//set_rnd_seed(10);

////////////////////////////////////////////////////// p2b /////////////////////////////////////////////////////////

/*
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  for(;;){
    // Avoid deadlock by giving devices a chance to interrupt.
    intr_on();

    // Run the for loop with interrupts off to avoid
    // a race between an interrupt and WFI, which would
    // cause a lost wakeup.
    //printf("try lrc, cpu:%d\n",id);
    //acquire(&sched_lock); //for access the process table
    //printf("hold lrc, cpu:%d\n",id);
    struct proc* runnable[NPROC]; //runnable accounting table
    int ticket_sum = 0; 
    int i = 0;
    struct proc* WP = NULL; //the process that wins the lottery
    for(p = proc; p < &proc[NPROC]; p++){
      acquire(&p->lock);
      if(p->state == RUNNABLE){
        runnable[i] = p;
        ticket_sum += p->ticket;
        i++;
      }
      release(&p->lock);
    }

    uint32 win_num = rand_interval(0,ticket_sum); //the lottery winning number between [0, ticket_sum]
    uint32 counter = 0;
    for(int j = 0; j < i; j++){
      counter += runnable[j]->ticket;
      if(counter >= win_num){
        WP = runnable[j];
        break;
      }
    }
    //release(&sched_lock); //for access the process table
    if(WP != NULL){
      acquire(&WP->lock);
      WP->state = RUNNING;
      c->proc = WP;
      WP->start_tick = ticks; //p2b the starting tick of this scheduling round
      ////release(&sched_lock); //for access the process table
      swtch(&c->scheduler, &WP->context);
      c->proc = 0;
      release(&WP->lock);
    }
    ////release(&sched_lock); //for access the process table
  }
}
*/
//////////////////////////////////////////////////////////////// original scheduler /////////////////////////////////////////////////////////////////////

//int
void
scheduler(void)
{
  struct proc *p; 
  struct cpu *c = mycpu();
  c->proc = 0;
  /////////////////////////////// debug random number generator ////////////////////////////////////////
  //for(int x=0;x<10;x++){
  //  rand_interval(0,100);
  //  uint32 win_num = rand_interval(0,100);
  //  
  //}
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //settickets(100,proc);
  ///////////////////////////////////////// debug ticket ///////////////////////////////////////////////
  /*
  for(;;){
    // Avoid deadlock by giving devices a chance to interrupt.
    intr_on();
    //acquire(&sched_lock); //for access the process table
    struct proc* runnable[NPROC]; //runnable accounting table
    int ticket_sum = 0; 
    int i = 0;
    struct proc* WP = NULL; //the process that wins the lottery

    for(p = proc; p < &proc[NPROC]; p++){
      acquire(&p->lock);
      if(p->state == RUNNABLE){
        runnable[i] = p;
        ticket_sum += p->ticket;
        i++;
      //settickets(100,p);
        //printf("cpu:%d,p:%p\n",cpuid(),p);
        //printf("cpu:%d,runnable:%p\n",cpuid(),runnable[i]);
        //printf("cpu:%d,STATE:%d\n",cpuid(),p->state);
        //printf("cpu:%d,tickets %d\n",cpuid(),p->ticket);
        //printf("cpu:%d,ticket_sum %d\n",cpuid(),ticket_sum);
        //printf("cpu:%d,i %d\n",cpuid(),i);
      }
      release(&p->lock);
    }
    //printf("cpu:%d,ticker_sum:%d\n",cpuid(),ticket_sum);
    //printf("yes or no runnable\n");
    //printf("cpu:%d,ticket_sum:%d\n",cpuid(),ticket_sum);
    uint32 win_num = rand_interval(1,ticket_sum); //the lottery winning number between [0, ticket_sum]
    //printf("cpu:%d,ticket_sum:%d\n",cpuid(),ticket_sum);
    uint32 counter = 0;
    //printf("cpu:%d,win_num:%d\n",cpuid(),win_num);
    //printf("cpu:%d,counter:%d\n",cpuid(),counter);
    //printf("cpu:%d,i %d\n",cpuid(),i);
    for(int j = 0; j < i; j++){
      counter += runnable[j]->ticket;
      if(counter >= win_num){
        WP = runnable[j];
        break;
      }
    }
    //printf("cpu:%d,counter:%d\n",cpuid(),counter);
    //printf("cpu:%d,P:%p\n",cpuid(),WP);
    //printf("cpu:%d,W start tick:%d\n",cpuid(),p->start_tick);
    //printf("cpu:%d,W total tick:%d\n",cpuid(),p->total_tick);
    //printf("cpu:%d,W current tick:%d\n",cpuid(),ticks);
    if(WP != NULL){
        //printf("be here1\n");
        acquire(&WP->lock);
        WP->state = RUNNING;
        WP->start_tick = ticks; //p2b the starting tick of this scheduling round
        c->proc = WP;
        //printf("be here2\n");
        swtch(&c->scheduler, &WP->context);
        c->proc = 0;
        release(&WP->lock);
    }
    */
    //return mycpu()->noff;
    //printf("be here3\n");
    //release(&sched_lock);
  //}*/
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
   
    intr_on();
    //acquire(&sched_lock);
    //printf("loop?");
    for(p = proc; p < &proc[NPROC]; p++){
      acquire(&p->lock);
      //printf("cpu:%d,c->proc:%p\n",cpuid(),mycpu()->proc);
      if(p->state == RUNNABLE){
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        //p->start_tick = ticks; //p2b the starting tick of this scheduling round
        //printf("switch out cpu:%d,c->proc:%p,lock:%p, pid:%d, name:%s\n",cpuid(),mycpu()->proc,&p->lock,mycpu()->proc->pid,mycpu()->proc->name);
        swtch(&c->scheduler, &p->context);
        //printf("switch in cpu:%d,c->proc:%p,lock:%p, pid:%d, name:%s\n",cpuid(),mycpu()->proc,&p->lock,mycpu()->proc->pid,mycpu()->proc->name);
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
      }
      //printf("cpu:%d,lock:%p\n",cpuid(),&p->lock);
      release(&p->lock);
      //printf("cpu:%d,lock:%p\n",cpuid(),&p->lock);
    }
    //return;
    //release(&sched_lock);
    //}
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
  //if(!//holding(&sched_lock))
    //pani//c("sched sched_lock");
  if(!holding(&p->lock))
    panic("sched p->lock");
  //if(//holding(&sched_lock
  if(mycpu()->noff != 1) //originally is 1
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  //printf("sched in cpu:%d,c->proc:%p,lock:%p, pid:%d, name:%s\n",cpuid(),mycpu()->proc,&p->lock,mycpu()->proc->pid,mycpu()->proc->name);
  swtch(&p->context, &mycpu()->scheduler);
  //printf("sched out cpu:%d,c->proc:%p,lock:%p, pid:%d, name:%s\n",cpuid(),mycpu()->proc,&p->lock,mycpu()->proc->pid,mycpu()->proc->name);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  //acquire(&sched_lock); //for access the process table
  acquire(&p->lock);
  p->state = RUNNABLE;
  p->total_tick+=(ticks - p->start_tick); //p2b, calculate the total tick passed since first start up
  //printf("yield called, cpu:%d, pid:%d, total:%d\n",cpuid(),p->pid,p->total_tick);
  sched();
  release(&p->lock);
  //release(&sched_lock); //for access the process table
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
  //release(&sched_lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  //printf("zzzzz\n");
  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.
  if(lk != &p->lock){  //DOC: sleeplock0
    //acquire(&sched_lock);
    acquire(&p->lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &p->lock){
    release(&p->lock);
    //release(&sched_lock);
    acquire(lk);
  }
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;
  //acquire(&sched_lock); //for access the process table
  ////acquire(&sched_lock);
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;
    }
    release(&p->lock);
  }
  //release(&sched_lock); //for access the process table
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
  if(!holding(&p->lock))
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    p->state = RUNNABLE;
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
  struct proc *p;
  //acquire(&sched_lock); //for access the process table
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      //acquire(&sched_lock); //for access the process table
      return 0;
    }
    release(&p->lock);
  }
  //release(&sched_lock); //for access the process table
  return -1;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}