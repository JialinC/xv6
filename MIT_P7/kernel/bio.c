// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13

struct {
  struct spinlock lock;
  struct buf buf[NBUF];
  struct buf hash[NBUCKET];
  struct spinlock locklist[NBUCKET];
  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;

int hashkey(uint blockno)
{
  return (int)blockno%NBUCKET;
}

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  for(int i=0;i<NBUCKET;i++){
    initlock(&bcache.locklist[i], "bcache.bucket");
    bcache.hash[i].prev = &bcache.hash[i];
    bcache.hash[i].next = &bcache.hash[i];
  }

  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.hash[0].next;
    b->prev = &bcache.hash[0];
    initsleeplock(&b->lock, "buffer");
    bcache.hash[0].next->prev = b;
    bcache.hash[0].next = b;
    b->lastuse = 0;
    b->blockno = 0;
  }
  // Create linked list of buffers
  //bcache.head.prev = &bcache.head;
  //bcache.head.next = &bcache.head;
  //for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  //  b->next = bcache.head.next;
  //  b->prev = &bcache.head;
  //  initsleeplock(&b->lock, "buffer");
  //  bcache.head.next->prev = b;
  //  bcache.head.next = b;
  //}
  //printf("ok\n");
}

// Look through buffer cache for block on dbe dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  //printf("enter bget\n");
  struct buf *b;
  //acquire(&bcache.lock);

  int key = hashkey(blockno);
  acquire(&bcache.locklist[key]);
  for(b = bcache.hash[key].next; b != &bcache.hash[key]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.locklist[key]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  //printf("A1\n");
  release(&bcache.locklist[key]);
  //printf("A2\n");
  //push_off();
  acquire(&bcache.lock); //hold this to change blockn
  struct buf *next;
  uint last=0xFFFFFFFF;
  
  retry:
  b = 0;
  for(next = bcache.buf; next < bcache.buf+NBUF; next++){
    if(next->refcnt == 0)
      if(next->lastuse < last){
        last = next->lastuse;
        b = next;
      }
  }

  if(b){
    acquire(&bcache.locklist[hashkey(b->blockno)]);
    int ac = hashkey(b->blockno);
    //printf("%d\n",hashkey(b->blockno));
    if(b->lastuse == last && b->refcnt == 0){
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      b->lastuse = ticks;
      b->next->prev = b->prev;
      b->prev->next = b->next;
      //printf("B1\n");
      release(&bcache.locklist[ac]);
      //printf("B2\n");
    }
    else{
      release(&bcache.locklist[hashkey(b->blockno)]);
      goto retry;
    }
    release(&bcache.lock);
  }
  else{
    release(&bcache.lock);
    panic("bget: no buffers");
  }
  //printf("B\n");
  acquire(&bcache.locklist[key]);
  b->next = bcache.hash[key].next;
  b->prev = &bcache.hash[key];
  bcache.hash[key].next->prev = b;
  bcache.hash[key].next = b;
  release(&bcache.locklist[key]);
  //printf("C\n");
  acquiresleep(&b->lock);
  return b;
  // Is the block already cached?
  //for(b = bcache.head.next; b != &bcache.head; b = b->next){
  //  if(b->dev == dev && b->blockno == blockno){
  //    b->refcnt++;
  //    release(&bcache.lock);
  //    acquiresleep(&b->lock);
  //    return b;
  //  }
  //}

  // Not cached; recycle an unused buffer.
  //for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  //  if(b->refcnt == 0) {
  //    b->dev = dev;
  //    b->blockno = blockno;
  //    b->valid = 0;
  //    b->refcnt = 1;
  //    release(&bcache.lock);
  //    acquiresleep(&b->lock);
  //    return b;
  //  }
  //}
  //panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
}

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  //acquire(&bcache.lock);
  acquire(&bcache.locklist[hashkey(b->blockno)]);
  b->refcnt--;
  b->lastuse = ticks;
  release(&bcache.locklist[hashkey(b->blockno)]);
  //if (b->refcnt == 0) {
    // no one is waiting for it.
    //b->next->prev = b->prev;
    //b->prev->next = b->next;
    //b->next = bcache.head.next;
    //b->prev = &bcache.head;
    //bcache.head.next->prev = b;
    //bcache.head.next = b;
  //}
  
  //release(&bcache.lock);
}

void
bpin(struct buf *b) {
  acquire(&bcache.lock);
  b->refcnt++;
  release(&bcache.lock);
}

void
bunpin(struct buf *b) {
  acquire(&bcache.lock);
  b->refcnt--;
  release(&bcache.lock);
}


