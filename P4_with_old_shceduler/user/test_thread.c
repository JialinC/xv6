#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#undef NULL
#define NULL ((void*)0)
#define PGSIZE (4096)
#define N 1

#define assert(x) if (x) {} else { \
   printf("%s: %d ", __FILE__, __LINE__); \
   printf("assert failed (%s)\n", # x); \
   printf("TEST FAILED\n"); \
   kill(ppid); \
   exit(0); \
}

int ppid;
int pid1,pid2;// pid2;
//volatile int bufsize;
int result = 100;
//lock_t lock;
//cond_t nonfull, nonempty;



void produce1(void *arg1,void *arg2);
void produce2(void *arg1,void *arg2);
//void consume(void *arg);


int
main(int argc, char *argv[])
{
  //int i;
  //ppid = getpid();
  printf("ppid%p\n", ppid);
  //lock_init(&lock);
  //bufsize = 0;
  //printf("produce:%p\n", produce);
  //assert((pid1 = thread_create(produce, NULL, NULL)) > 0);
  pid1 = thread_create(produce1, NULL, NULL);
  pid2 = thread_create(produce2, NULL, NULL);
  //printf("create success\n");
  //assert((pid2 = thread_create(consume, NULL)) > 0);
  //sleep(1);
  pid1 = thread_join();
  pid2 = thread_join();
  printf("join success %p\n",pid1);
  printf("join success %p\n",pid2);
  //for(i = 0; i < 500; i++) {
  //  result <<= 1;
  //sleep(1);
  //}
  //sleep(1);
  //printf(1, "%p\n", result);
  //if(result & 0x3ff)
  //  printf(1, "TEST PASSED\n");
  exit(0);
}

void
produce1(void *arg1,void *arg2) {
  //while(1) {
    //lock_acquire(&lock);
    //while(bufsize == N)
    //  cv_wait(&nonfull, &lock);
    //printf("produce\n");
    //result <<= 1;
    //result |= 1;
    printf("print out something1 %p\n", result);
    //bufsize++;
    //cv_signal(&nonempty);
    //lock_release(&lock);
  //}
  exit(0);
}
void
produce2(void *arg1,void *arg2) {
  //while(1) {
    //lock_acquire(&lock);
    //while(bufsize == N)
    //  cv_wait(&nonfull, &lock);
    //printf("produce\n");
    //result <<= 1;
    //result |= 1;
    printf("print out something2 %p\n", result);
    //bufsize++;
    //cv_signal(&nonempty);
    //lock_release(&lock);
  //}
  exit(0);
}
//void
//consume(void *arg) {
//  while(1) {
//    lock_acquire(&lock);
//    while(bufsize == 0)
//      cv_wait(&nonempty, &lock);

//    result <<= 1;
//    result |= 1;

//    bufsize--;
//    cv_signal(&nonfull);
//    lock_release(&lock);
//  }
//}