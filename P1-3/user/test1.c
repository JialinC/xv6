#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int argc, char *argv[]){
	int answer;
	answer = getreadcount();
	printf("answer: %d\n", answer);
	exit(0);
}
