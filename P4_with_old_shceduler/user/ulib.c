#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#ifndef PGSIZE
#define PGSIZE 4096
#endif


char*
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

void*
memset(void *dst, int c, uint n)
{
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    cdst[i] = c;
  }
  return dst;
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
}

char*
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
  return vdst;
}

void lock_init(lock_t *l, char *name) {
 l->name = name;
 l->locked = 0;
 //l->guard = 0;
}

void lock_acquire(lock_t *l) {
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
    ;
  __sync_synchronize();
}

void lock_release(lock_t *l) {
  __sync_synchronize();
  __sync_lock_release(&l->locked);
//  l->locked = 0;
}

//void cv_wait(cond_t *cond, lock_t *lock) {
//  cond->num++;
  //while(xchg(&lock->guard, 1));
//  lock_release(lock);
//  condsleep(cond->num);
  //xchg(&lock->guard, 0);
//  while(xchg(&lock->locked, 1));
//}

//void cv_signal(cond_t * cond) {
//  if(cond->num != cond->curr) {
//    cond->curr++;
//    condwakeup(cond->curr);
//  }
//}
//int thread_create(void (*start_routine)(void *, void *), void *arg1, void *arg2){
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
  //printf("check point a\n");
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
  //printf("check point b\n");
  if((uint64)stack % PGSIZE) { //not aligned
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
    //printf("check point c\n");
  }
  //stack = stack + PGSIZE;
  //printf("check point d\n");
  //printf("stack %p\n",stack);
  //printf("start_routine: %p\n",start_routine );
  //stack += (PGSIZE - (uint64)stack % PGSIZE);
  int pid = clone(start_routine, arg1, arg2, stack);
  return pid;
}

int thread_join() {
  void *ustack = 0;
  int status = join(&ustack);
  free(ustack);
  return status;
}







