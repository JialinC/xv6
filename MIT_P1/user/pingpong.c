#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int fd1[2], fd2[2];
  pipe(fd1);
  pipe(fd2);

  if (fork() == 0) {
    close(fd1[1]);
    close(fd2[0]);
    char buffer = 'Z';
    read(fd1[0], &buffer, 1);
    printf("%d: received ping\n", getpid());
    write(fd2[1], &buffer, 1);
    close(fd1[0]);
    close(fd2[1]);
  } else {
    close(fd1[0]);
    close(fd2[1]);
    char buffer = 'Z';
    write(fd1[1], &buffer, 1);
    read(fd2[0], &buffer, 1);
    printf("%d: received pong\n", getpid());
    close(fd1[1]);
    close(fd2[0]);
    wait();
  }
  exit();
}