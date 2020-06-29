#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
  //////////////////////////////////////// invalid address test //////////////////////////////////////////////////////
  //uint64 *p1 = (uint64 *)0x0fff; //NULL pointer, in theory all address less than 0x1000 is invalid(0x0000 - 0x0FFF)
  //printf("content of p1 pointer:%p\n", p1);
  //printf("dereference of NULL pointer:%p\n", *p1);
  //////////////////////////////////////// invalid address test //////////////////////////////////////////////////////

  ////////////////////////////// invalid pointer argument for syscall test ///////////////////////////////////////////
  //int x1 = getpinfo(0);
  //printf("XV6_TEST_OUTPUT syscall result:%d\n", x1);
  ////////////////////////////// invalid pointer argument for syscall test ///////////////////////////////////////////

  ///////////////////////////////////// read write protection test ///////////////////////////////////////////////////
  //uint64 *p2 = (uint64 *)0x1000; //point to self text section, then write to self text sectino to mess it up
  //for(int i = 0; i < 0x0010; i++){
  //  printf("value of i:%p\n", i);
  //  printf("content of p2 pointer:%p\n", p2);
  //  printf("dereference p2 pointer:%p\n", *p2);
  //  *p2 = NULL; //rewrite the text section
  //  printf("content of p2 pointer:%p\n", p2);
  //  printf("dereference p2 pointer:%p\n", *p2);
  //  p2++;
  //  printf("update p2:%p\n", p2);
  //}
  ///////////////////////////////////// read write protection test ///////////////////////////////////////////////////
  
  ///////////////////////////////////////// protect syscall test /////////////////////////////////////////////////////
  int x2 = mprotect((void*)0x1000, 1);
  printf("XV6_TEST_OUTPUT syscall result:%d\n", x2);
  uint64 *p2 = (uint64 *)0x1000;
  //int x3 = munprotect((void*)0x1000, 1);
  //printf("XV6_TEST_OUTPUT syscall result:%d\n", x3);
  *p2 = 0;
  //int x4 = mprotect((void*)0x1234, 10);
  //printf("XV6_TEST_OUTPUT pass invalid pointer as argument of syscall:%d\n", x3);
  ///////////////////////////////////////// protect syscall test /////////////////////////////////////////////////////

  exit(0);
}