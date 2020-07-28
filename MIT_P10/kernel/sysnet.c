//
// network system calls.
//

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "net.h"

struct sock {
  struct sock *next; // the next socket in the list
  uint32 raddr;      // the remote IPv4 address
  uint16 lport;      // the local UDP port number
  uint16 rport;      // the remote UDP port number
  struct spinlock lock; // protects the rxq
  struct mbufq rxq;  // a queue of packets waiting to be received
};

static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
  initlock(&lock, "socktbl");
}

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
  struct sock *si, *pos;

  si = 0;
  *f = 0;
  //printf("sockalloc A\n");
  if ((*f = filealloc()) == 0)
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    goto bad;
  //printf("sockalloc B\n");
  // initialize objects
  si->raddr = raddr;
  si->lport = lport;
  si->rport = rport;
  initlock(&si->lock, "sock");
  mbufq_init(&si->rxq);
  (*f)->type = FD_SOCK;
  (*f)->readable = 1;
  (*f)->writable = 1;
  (*f)->sock = si;

  //printf("sockalloc C\n");
  // add to list of sockets

  acquire(&lock);
  //printf("sockalloc C1\n");
  pos = sockets;
  while (pos) {
    if (pos->raddr == raddr &&
        pos->lport == lport &&
	pos->rport == rport) {
      //printf("sockalloc C2\n");
      release(&lock);
      goto bad;
    }
    //printf("sockalloc C3\n");
    pos = pos->next;
  }
  si->next = sockets;
  sockets = si;
  release(&lock);
  //printf("sockalloc D\n");
  return 0;

bad:
  if (si){
    //printf("bad si free\n");
    kfree((char*)si);
    //printf("bad si free done\n");
  }
  if (*f){
    //printf("bad *f free\n");
    fileclose(*f);
    //printf("bad *f free done\n");
  }
  return -1;
}

void
sockclose(struct sock *si)
{
  //printf("sockclose start\n");
  struct sock *pre, *cur;
  int found = 0;
  //printf("sockclose acquire lock addr %p\n",&lock);
  acquire(&lock);
  //printf("sockclose acquired lock addr %p\n",&lock);
  //printf("sockclose acquire si->lock addr %p\n",&si->lock);
  acquire(&si->lock);
  //printf("sockclose acquired si->lock addr %p\n",&si->lock);
  pre = cur = sockets;
  //cur->raddr == si->raddr && cur->lport == si->lport && cur->rport == si->rport
  //printf("si addr: %p\n",si);
  while (cur) {
    //printf("cur addr: %p\n",cur);
    if (cur == si) {
      if(cur == sockets)
        sockets = sockets->next;
      else
        pre->next = cur->next;
      found = 1;
      break;
    }
    pre = cur;
    cur = cur->next;
  }

  if(!found){
    //printf("not found\n");
    //printf("sockclose release lock addr %p\n",&lock);
    release(&lock);
    //printf("sockclose released lock addr %p\n",&lock);
    return;
  }

  pre->next = cur->next;
  //printf("sockclose release lock addr %p\n",&lock);
  release(&lock);
  //printf("sockclose released lock addr %p\n",&lock);
  
  while(!mbufq_empty(&si->rxq)){
    mbuffree(mbufq_pophead(&si->rxq));
  }
  //printf("sockclose release si->lock addr %p\n",&si->lock);
  release(&si->lock);
  //printf("sockclose released si->lock addr %p\n",&si->lock);
  kfree((char*)si);
  //printf("sockclose done\n");
  return;
}


int
sockwrite(struct sock *si, uint64 addr, int n)
{
  //printf("sockwrite start\n");
  struct proc *pr = myproc();
  struct mbuf *b;

  b = mbufalloc(sizeof(struct eth)+sizeof(struct ip)+sizeof(struct udp));
  //printf("sockwrite acquire si->lock addr %p\n",&si->lock);
  acquire(&si->lock);
  //printf("sockwrite acquired si->lock addr %p\n",&si->lock);
  if(copyin(pr->pagetable, b->head, addr, n) == -1){
    //printf("cpin error\n");
    //printf("sockwrite release si->lock addr %p\n",&si->lock);
    release(&si->lock);
    //printf("sockwrite released si->lock addr %p\n",&si->lock);
    return -1;
  } 
  mbufput(b,n);
  net_tx_udp(b, si->raddr, si->lport, si->rport);
  //printf("sockwrite release si->lock addr %p\n",&si->lock);
  release(&si->lock);
  //printf("sockwrite released si->lock addr %p\n",&si->lock);
  //printf("sockwrite done\n");
  return n;
}

int
sockread(struct sock *si, uint64 addr, int n)
{
  //printf("sockread start\n");
  struct proc *pr = myproc();
  struct mbuf *b;
  int r;
  //printf("sockread acquire si->lock addr %p\n",&si->lock);
  acquire(&si->lock);
  //printf("sockread acquired si->lock addr %p\n",&si->lock);
  while(mbufq_empty(&si->rxq))
    sleep(&si->rxq, &si->lock);
  
  b = mbufq_pophead(&si->rxq);
  if(copyout(pr->pagetable, addr, b->head, b->len) == -1){
    //printf("cpout error\n");
    //printf("sockread release si->lock addr %p\n",&si->lock);
    release(&si->lock);
    //printf("sockread released si->lock addr %p\n",&si->lock);
    return -1;
  } 
  r = b->len;
  mbuffree(b);
  //printf("sockread release si->lock addr %p\n",&si->lock);
  release(&si->lock);
  //printf("sockread released si->lock addr %p\n",&si->lock);
  //printf("sockread done\n");
  return r; 
}

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
  //
  // Your code here.
  //
  // Find the socket that handles this mbuf and deliver it, waking
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  //printf("sockrecvudp start\n");
  struct sock *pos;
  //printf("sockrecvudp acquire lock addr %p\n",&lock);
  acquire(&lock);
  //printf("sockrecvudp acquired lock addr %p\n",&lock);
  pos = sockets;
  int found = 0;
  while (pos) {
    //printf("sockrecvudp acquire pos->lock addr %p\n",&pos->lock);
    acquire(&pos->lock);
    //printf("sockrecvudp acquired pos->lock addr %p\n",&pos->lock);
    if (pos->raddr == raddr &&
        pos->lport == lport &&
        pos->rport == rport){
      found = 1;
      break;
    }
    //printf("sockrecvudp release pos->lock addr %p\n",&pos->lock);
    release(&pos->lock);
    //printf("sockrecvudp released pos->lock addr %p\n",&pos->lock);
    pos = pos->next;
  }

  if(!found){
    //printf("sockrecvudp not found\n");
    //printf("sockrecvudp release lock addr %p\n",&lock);
    mbuffree(m);
    release(&lock);
    //printf("sockrecvudp released lock addr %p\n",&lock);
    return;
  }

  mbufq_pushtail(&pos->rxq,m);
  wakeup(&pos->rxq);
  //printf("sockrecvudp release pos->lock addr %p\n",&pos->lock); 
  release(&pos->lock);
  //printf("sockrecvudp released pos->lock addr %p\n",&pos->lock);
  //printf("sockrecvudp release lock addr %p\n",&lock);
  release(&lock);
  //printf("sockrecvudp released lock addr %p\n",&lock);
  //printf("sockrecvudp done\n");
  return;
}
