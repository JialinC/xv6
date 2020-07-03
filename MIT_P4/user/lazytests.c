#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

#define REGION_SZ (1024 * 1024 * 1024) //2^30

void
sparse_memory(char *s)
{
  char *i, *prev_end, *new_end;
  
  prev_end = sbrk(REGION_SZ);
  //printf("prev_end %p\n",prev_end);
  if (prev_end == (char*)0xffffffffffffffffL) {
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;
  //printf("check point 1\n");
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    *(char **)i = i;
  //printf("check point 2\n");
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    if (*(char **)i != i) {
      printf("failed to read value from memory\n");
      exit(1);
    }
  }
  //printf("check point 3\n");
  exit(0);
}

void
sparse_memory_unmap(char *s)
{
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  if (prev_end == (char*)0xffffffffffffffffL) {
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;
  //printf("check point 1\n");
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    *(char **)i = i;
  //printf("check point 2\n");
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    pid = fork();
    //printf("check point afterfork\n");
    if (pid < 0) {
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
      sbrk(-1L * REGION_SZ);
      //printf("-1L * REGION_SZ: %d\n",-1L * REGION_SZ);
      *(char **)i = i;
      //printf("error negative\n");
      exit(0);
    } else {
      int status;
      wait(&status);
      if (status == 0) {
        printf("memory not unmapped\n");
        exit(1);
      }
    }
  }
  //printf("check point 3\n");
  exit(0);
}

void
oom(char *s)
{
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    m1 = 0;
    m2 = malloc(4096*4096);
    //printf("m2: %p",m2);
    //int times = 0;
    while((m2 = malloc(4096*4096)) != 0){
      //printf("check point 2\n");
      //printf("m2: %p\n",m2);
      //times++;
      //printf("times: %p",times);
      *(char**)m2 = m1;
      m1 = m2;
    }
    //printf("check point 3\n");
    exit(0);
  } else {
    //printf("pid: %d\n",pid);
    int xstatus;
    wait(&xstatus);
    exit(xstatus == 0);
  }
}

void
sbrkarg(char *s)
{
  char *a;
  int fd, n;

  a = sbrk(PGSIZE);
  fd = open("sbrk", O_CREATE|O_WRONLY);
  unlink("sbrk");
  if(fd < 0)  {
    printf("%s: open sbrk failed\n", s);
    exit(1);
  }
  if ((n = write(fd, a, PGSIZE)) < 0) {
    printf("a: %p",a);
    printf("%s: write sbrk failed\n", s);
    exit(1);
  }
  close(fd);

  // test writes to allocated memory
  a = sbrk(PGSIZE);
  if(pipe((int *) a) != 0){
    printf("%s: pipe() failed\n", s);
    exit(1);
  } 
}

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
  int pid;
  int xstatus;
  
  pid = fork();
  if(pid == 0) {
    char *sp = (char *) r_sp();
    printf(" r_sp() %p\n",  r_sp());
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
  if(xstatus == -1)  // kernel killed child?
    exit(0);
  else
    exit(xstatus);
}




// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
  int pid;
  int xstatus;
  
  printf("running test %s\n", s);
  if((pid = fork()) < 0) {
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    if(xstatus != 0) 
      printf("test %s: FAILED\n", s);
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
  }
}

int
main(int argc, char *argv[])
{
  char *n = 0;
  if(argc > 1) {
    n = argv[1];
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    { sparse_memory, "lazy alloc"},
    { sparse_memory_unmap, "lazy unmap"},
    { oom, "out of memory"},
    //{sbrkarg, "sbrkarg"},
    //{stacktest, "stacktest"},
    { 0, 0},
  };
    
  printf("lazytests starting\n");

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    }
  }
  if(!fail)
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
  exit(1);   // not reached.
}
