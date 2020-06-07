#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
  int x1 = settickets(5);
  struct pstat p;
  int x2 = getpinfo(&p);
  printf("XV6_TEST_OUTPUT x1 x2:%d, %d\n", x1, x2);
  for(int i = 0; i < NPROC; i++){
    printf("pid:%d, tickets:%d\n", p.pid[i], p.tickets[i]);
  }
  exit(0);
}
