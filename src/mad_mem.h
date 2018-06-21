#ifndef MAD_MEM_H
#define MAD_MEM_H

#ifdef _USEGC

#define GC_DEBUG
#define DEBUG_MEM

#include <gc.h>

#define mymalloc(fn, sz)            myptrchk("M" , fn, sz, GC_MALLOC_IGNORE_OFF_PAGE(sz))
#define mymalloc_atomic(fn, sz)     myptrchk("MA", fn, sz, GC_MALLOC_ATOMIC_IGNORE_OFF_PAGE(sz))
#define myrealloc(fn, p, sz)        myptrchk("R" , fn, sz, GC_REALLOC((p),(sz)))
#define myfree(fn, p)               ((void)(GC_FREE(myptrchk("F", fn, 0, p)), (p)=0))

#define mycalloc(fn, n, sz)         memset(mymalloc(fn, (n)*(sz)), 0, (n)*(sz))
#define mycalloc_atomic(fn, n, sz)  memset(mymalloc_atomic(fn, (n)*(sz)), 0, (n)*(sz))
#define myrecalloc(fn, p, osz, sz)  ((void*)((char*)memset((char*)myptrchk("RC",fn,sz,GC_REALLOC((p),(sz)))+(osz),0,(sz)-(osz))-(osz)))

#define mycollect()                 GC_gcollect()

#else

#define mymalloc(fn, sz)            myptrchk("M" , fn, sz, malloc(sz))
#define mymalloc_atomic(fn, sz)     myptrchk("MA", fn, sz, malloc(sz))
#define myrealloc(fn, p, sz)        myptrchk("R" , fn, sz, realloc((p),(sz)))
#define myfree(fn, p)               ((void)(free(myptrchk("F", fn, 0, p)), (p)=0))

#define mycalloc(fn, n, sz)         myptrchk("C" , fn, sz, calloc((n),(sz)))
#define mycalloc_atomic(fn, n, sz)  myptrchk("CA", fn, sz, calloc((n),(sz)))
#define myrecalloc(fn, p, osz, sz)  ((void*)((char*)memset((char*)myptrchk("RC",fn,sz,realloc((p),(sz)))+(osz),0,(sz)-(osz))-(osz)))

#define mycollect()

#endif

#ifdef DEBUG_MEM
#define myptrchk(typ, fn, sz, ptr)  myptrchk(typ, fn, sz, ptr)
#else
#define myptrchk(typ, fn, sz, ptr)  ((void)fn, ptr)
#endif

// SIGSEGV handler
void mad_mem_handler(int sig);

// Pointer check for null
void* (myptrchk)(const char *type, const char *caller, long sz, void *ptr);

#endif // MAD_MEM_H
