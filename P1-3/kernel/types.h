typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;

typedef uint64 pde_t;

typedef struct __lock_t { //p4
  uint locked;
//  uint guard;
} lock_t;

//typedef struct __cond_t{
//  uint num;
//  uint curr;
//  lock_t lock;
//} cond_t;