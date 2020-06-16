// Simple grep.  Only supports ^ . * $ operators.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char buf[1024];
int match(char*, char*);

void grep(char *pattern, int fd){
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
  char *pattern;
  if(argc <= 1){
    fprintf(2, "wgrep: searchterm [file ...]\n");
    exit(1);
  }

  pattern = argv[1];
  if(pattern==""){
	exit(0);
  }
  if(argc <= 2){
    grep(pattern, 0);
    exit(0);
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

// Regexp matcher from Kernighan & Pike,
// The Practice of Programming, Chapter 9.

int matchhere(char*, char*);
int matchstar(int, char*, char*);
int match(char *re, char *text){
  if(re[0] == '^') //find match at the beginning
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text){
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0') //match at the end
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text){ //regular expression
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}

