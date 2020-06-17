#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

uint32 rnd_seed = 10;

void set_rnd_seed(uint32 seed)
{
	rnd_seed = seed;
    //printf("rnd_seed:%p\n",rnd_seed);
}

uint32 rand_int(uint32 *state) //from wikipedia, lehmer random number generator
{
	const uint32 A = 48271;

	uint32 low  = (*state & 0x7fff) * A;			// max: 32,767 * 48,271 = 1,581,695,857 = 0x5e46c371
	uint32 high = (*state >> 15)    * A;			// max: 65,535 * 48,271 = 3,163,439,985 = 0xbc8e4371
	uint32 x = low + ((high & 0xffff) << 15) + (high >> 16);	// max: 0x5e46c371 + 0x7fff8000 + 0xbc8e = 0xde46ffff

	x = (x & 0x7fffffff) + (x >> 31);
	return *state = x;
}

uint32
rand_interval(uint32 min, uint32 max)
{
    	if(max < min){
            return 0;
        }
        uint32 r;
    	const uint32 range = 1 + max - min;
        //printf("range:%d\n",range);
     	const uint32 buckets = 0x80000000 / range;//(MAX_UINT32/2) / range;
        //printf("bucket:%d\n",buckets);
     	const uint32 limit = buckets * range;
        //printf("limit:%d\n",limit);
 
     	/* Create equal size buckets all in a row, then fire randomly towards
      	* the buckets until you land in one of them. All buckets are equally
      	* likely. If you land off the end of the line of buckets, try again. */
     	do
     	{   
        	 r = rand_int(&rnd_seed);
             //printf("rnd_seed:%p\n",r);
    	 }while (r >= limit);
 
     	return min + (r / buckets);
}

