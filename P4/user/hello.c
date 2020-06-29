#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"


void
myfunc(int arg){
	printf("hello from func %d\n", arg);
}

int
main(int argc, char *argv[]){
	printf("hello from main\n");
	myfunc(0);
	exit(0);
}