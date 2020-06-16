//wzip when you encounter n characters of the same type in a row, the compression tool (wzip) will turn that into the number n and a single instance of the character.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char buf[1024]; //max character number in a .txt line

void wzip(int fd){
  int n, m;
  char *p, *q;

  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){//read more input into buffer max is 1023, as the previous input may not all be processed,
                                                    //so calculate the size sizeof(buf)-m-1 
    m += n; //m points to the next byte in buffer that is unwritten to  abcd\nefghm()
    buf[m] = '\0'; //abcd\nefghm(\0)
    p = buf; //p(a)bcd\nefgh
    while((q = strchr(p, '\n')) != 0){ //compare every char in buf find a match of \n, then set q point to this \n
      *q = 0; //set \n to null. now buf looks like this abcdp(\0)efgh
      if(match(pattern, p)){ //try to find match 
        *q = '\n'; //set \0 back to \n abcdq(\n)efgh
        write(1, p, q+1 - p); //write this line to stdout, the number of byte write is q+1-p
      }
      p = q+1; //p point to the next byte in buf after \n p(e)fgh
    }
    if(m > 0){ //have content in buf
      m -= p - buf; //calculate new m after next move
      memmove(buf, p, m); //make space for new input. abcd\nefgh -> efghx
    }
  }
}



int main(int argc, char *argv[]){
  int fd, i;
  if(argc <= 1){
    fprintf(2, "wzip: file1 [file2...]\n");
    exit(1);
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf("wgrep: cannot open %s\n", argv[i]);
      exit(1);
    }
    grep(pattern, fd);
    close(fd);
  }
  exit(0);
}

