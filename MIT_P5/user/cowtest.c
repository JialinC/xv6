//
// tests for copy-on-write fork() assignment.
//

//#include "kernel/types.h"
//#include "kernel/memlayout.h"
//#include "user/user.h"

#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
  
  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  int pid = fork();
  //printf("pid %d",pid);
  if(pid < 0){
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
    exit(0);

  wait(0);

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }
  //sleep(1);
  printf("ok\n");
}

// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
  
  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  if(pid1 < 0){
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
    pid2 = fork();
    if(pid2 < 0){
      printf("fork failed");
      exit(-1);
    }
    if(pid2 == 0){
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
        *(int*)q = getpid();
      }
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
        if(*(int*)q != getpid()){
          printf("wrong content\n");
          exit(-1);
        }
      }
      exit(-1);
    }
    for(char *q = p; q < p + (sz/2); q += 4096){
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  wait(0);

  sleep(1);

  for(char *q = p; q < p + sz; q += 4096){
    if(*(int*)q != getpid()){
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
}

char junk1[4096];
int fds[2];
char junk2[4096];
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
  printf("file: ");
  
  buf[0] = 99;

  for(int i = 0; i < 4; i++){
    if(pipe(fds) != 0){
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
      sleep(1);
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
        printf("error: read failed\n");
        exit(1);
      }
      sleep(1);
      int j = *(int*)buf;
      if(j != i){
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
    if(xstatus != 0) {
      exit(1);
    }
  }

  if(buf[0] != 99){
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
}

void
sbrkbugs(char *s)
{
  //printf("point 0\n");
  int pid = fork();
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  if(pid == 0){
    int sz = (uint64) sbrk(0);
    //printf("point a1\n");
    //printf("sz: %d %p\n",sz,sz);
    // free all user memory; there used to be a bug that
    // would not adjust p->sz correctly in this case,
    // causing exit() to panic.
    sbrk(-sz);
    //printf("sbrk(-sz)\n");
    // user page fault here.
    exit(0);
  }

  //printf("point 1a\n");
  wait(0);
  //printf("point 1b\n");

  pid = fork();
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  if(pid == 0){
    int sz = (uint64) sbrk(0);
    // set the break to somewhere in the very first
    // page; there used to be a bug that would incorrectly
    // free the first page.
    sbrk(-(sz - 3500));
    exit(0);
  }
  wait(0);
  //printf("point 2\n");

  pid = fork();
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  if(pid == 0){
    // set the break in the middle of a page.
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));

    // reduce the break a bit, but not enough to
    // cause a page to be freed. this used to cause
    // a panic.
    sbrk(-10);

    exit(0);
  }
  wait(0);
  //printf("point 3\n");
  exit(0);
}

void
pgbug(char *s)
{
  char *argv[1];
  argv[0] = 0;
  exec((char*)0xeaeb0b5b00002f5e, argv);

  pipe((int*)0xeaeb0b5b00002f5e);

  exit(0);
}

// can we read the kernel's memory?
void
kernmem(char *s)
{
  char *a;
  int pid;
  //printf("KERNBASE+2000000: %p\n",KERNBASE+2000000);
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    pid = fork();
    if(pid < 0){
      printf("%s: fork failed\n", s);
      exit(1);
    }
    if(pid == 0){
      printf("%s: oops could read %x = %x\n", a, *a);
      exit(1);
    }
    int xstatus;
    wait(&xstatus);
    if(xstatus != -1)  // did kernel kill child?
      exit(1);
  }
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
/*
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
    {pgbug, "pgbug" },
    {sbrkbugs,"sbrkbugs"},
    {kernmem,"kernmem"},
    { 0, 0},
  };
    
  printf("cowtest starting\n");

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
*/


int
main(int argc, char *argv[])
{
  simpletest();
  // check that the first simpletest() freed the physical memory.
  simpletest();
  //printf("first start\n");
  threetest();
  //printf("first done\n");
  //sleep(10);
  //printf("second start\n");
  threetest();
  //printf("second done\n");
  //sleep(100);
  threetest();

  filetest();

  printf("ALL COW TESTS PASSED\n");

  exit(0);
}
