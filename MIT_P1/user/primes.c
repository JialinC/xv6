#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int fd1[2];
int fd2[2];
int
main(int argc, char *argv[]){
  int num;
  int my_prime = 2;
  int forked = 0;
  pipe(fd1);
  if(fork() == 0){ //first child prime=2
    close(fd1[1]);
    printf("prime %d\n", my_prime);
    while(1){
      if(read(fd1[0],&num,sizeof(num)) < 0){ //keep reading from the pipe inherited till the writting end is closed
        close(fd1[0]); //clean up close reading end then exit
        exit();
      }
      if(num%my_prime != 0){ //cannot handle this number by this child
        if(!forked){ //have not forked yet
           //new pipe for writting
          pipe(fd2);
          if(fork() == 0){
            forked = 0;
            close(fd1[0]);
            fd1[0] = fd2[0];
            fd1[1] = fd2[1];
            close(fd1[1]);
            read(fd1[0],&my_prime,sizeof(my_prime));
            printf("prime %d\n", my_prime);
          }
          else{
            forked = 1;
            close(fd2[0]);
            write(fd2[1],&num,sizeof(num));
          }
        }
        else{
          write(fd2[1],&num,sizeof(num));
        }
      }
    }
  }
  else{ //main
    close(fd1[0]);
    for(int i = 2; i < 36; i++)
      write(fd1[1],&i,sizeof(i));
    close(fd1[1]);
    exit();
  }
}