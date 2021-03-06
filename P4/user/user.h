struct stat;
struct rtcdate;
struct pstat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int clone(void(*)(void *, void *), void *, void *, void *); //p4
int join(void **stack); //p4

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...);
void printf(const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
void printfinit(void); //p4

//kernel thread library also in ulib.c p4
int thread_create(void (*)(void *, void *), void *, void *);
int thread_join();
void lock_init(lock_t *, char*);
void lock_acquire(lock_t *);
void lock_release(lock_t *);
//void cv_wait(cond_t *, lock_t *); not required
//void cv_signal(cond_t *); not required

// Mutual exclusion lock.
//struct userlock {
//  uint locked;       // Is the lock held?
  // For debugging:
//  char *name;        // Name of lock.
//};

//extern lock_t printf_lock; //p4
