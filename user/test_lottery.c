#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
  int x1 = settickets(5);
  struct pstat p;
  int x2 = getpinfo(&p);
  uint64 *pp = NULL;
  printf("XV6_TEST_OUTPUT %d, %d", x1, x2);
  for(int i = 0; i < NPROC; i++){
    printf("pid:%d, tickets:%d\n", p.pid[i], p.tickets[i]);
  }
  printf("dereference of NULL pointer:%p\n", *pp);
  exit(0);
}
