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

// bucket number for bufmap
#define NBUFMAP_BUCKET 31
// hash function for bufmap
#define BUFMAP_HASH(dev, blockno) ((((dev) << 27) | (blockno)) % NBUFMAP_BUCKET)

struct
{
    struct spinlock lock;
    struct buf buf[NBUF];
    struct buf bucket[NBUFMAP_BUCKET];
    struct spinlock bucket_lock[NBUFMAP_BUCKET];
} bcache;

void binit(void)
{
    initlock(&bcache.lock, "bcache");
    for (int i = 0; i < NBUFMAP_BUCKET; ++i)
    {
        initlock(&bcache.bucket_lock[i], "bcache.bucket");
        bcache.bucket[i].next = 0;
    }
    for (int i = 0; i < NBUF; ++i)
    {
        struct buf *b = &bcache.buf[i];
        initsleeplock(&b->lock, "buffer");
        b->lastuse = 0;
        b->refcnt = 0;
        b->next = bcache.bucket[0].next;
        bcache.bucket[0].next = b;
    }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf *
bget(uint dev, uint blockno)
{
    struct buf *b;
    uint key = BUFMAP_HASH(dev, blockno);
    acquire(&bcache.bucket_lock[key]);

    // Is the block already cached?
    for (b = bcache.bucket[key].next; b; b = b->next)
    {
        if (b->dev == dev && b->blockno == blockno)
        {
            b->refcnt++;
            release(&bcache.bucket_lock[key]);
            acquiresleep(&b->lock);
            return b;
        }
    }
    release(&bcache.bucket_lock[key]);
    // Not cached.
    // Recycle the least recently used (LRU) unused buffer.
    acquire(&bcache.lock);
    // check is the block is already cached again
    for (b = bcache.bucket[key].next; b; b = b->next)
    {
        if (b->dev == dev && b->blockno == blockno)
        {
            acquire(&bcache.bucket_lock[key]);
            b->refcnt++;
            release(&bcache.bucket_lock[key]);
            release(&bcache.lock);
            acquiresleep(&b->lock);
            return b;
        }
    }
    // still not cached, find a free buffer
    uint bucket_index = -1;
    struct buf *free_b = 0;
    for (int i = 0; i < NBUFMAP_BUCKET; ++i)
    {
        acquire(&bcache.bucket_lock[i]);
        int found = 0;
        for (b = &bcache.bucket[i]; b->next; b = b->next)
        {
            if ((b->next->refcnt == 0) && (!free_b || (b->lastuse > free_b->lastuse)))
            {
                free_b = b;
                found = 1;
            }
        }
        if (!found)
        {
            release(&bcache.bucket_lock[i]);
        }
        else
        {
            if (bucket_index != -1)
            {
                release(&bcache.bucket_lock[bucket_index]); // release the old bucket
            }
            bucket_index = i;
        }
    }
    if (!free_b)
    {
        panic("bget: no buffers");
    }
    b = free_b->next;
    // remove the buffer from its bucket and add it to the current bucket
    if (bucket_index != key)
    {
        free_b->next = b->next;
        release(&bcache.bucket_lock[bucket_index]);
        acquire(&bcache.bucket_lock[key]);
        b->next = bcache.bucket[key].next;
        bcache.bucket[key].next = b;
    }
    // update the buffer
    b->dev = dev;
    b->blockno = blockno;
    b->valid = 0;
    b->refcnt = 1;
    release(&bcache.bucket_lock[key]);
    release(&bcache.lock);
    acquiresleep(&b->lock);
    return b;
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    struct buf *b;

    b = bget(dev, blockno);
    if (!b->valid)
    {
        virtio_disk_rw(b, 0);
        b->valid = 1;
    }
    return b;
}

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    if (!holdingsleep(&b->lock))
        panic("bwrite");
    virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    if (!holdingsleep(&b->lock))
        panic("brelse");

    releasesleep(&b->lock);
    uint key = BUFMAP_HASH(b->dev, b->blockno);
    acquire(&bcache.bucket_lock[key]);
    b->refcnt--;
    if (b->refcnt == 0)
    {
        b->lastuse = ticks;
    }
    release(&bcache.bucket_lock[key]);
}

void bpin(struct buf *b)
{
    uint key = BUFMAP_HASH(b->dev, b->blockno);
    acquire(&bcache.bucket_lock[key]);
    b->refcnt++;
    release(&bcache.bucket_lock[key]);
}

void bunpin(struct buf *b)
{
    uint key = BUFMAP_HASH(b->dev, b->blockno);
    acquire(&bcache.bucket_lock[key]);
    b->refcnt--;
    release(&bcache.bucket_lock[key]);
}
