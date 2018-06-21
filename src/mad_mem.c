#include <stdio.h>
#include <stdlib.h>

#include "mad_err.h"
#include "mad_mem.h"

// public interface

void
mad_mem_handler(int sig)
{
  (void)sig;

  puts("+++ memory access outside program range, fatal +++");
  exit(EXIT_FAILURE);
}

void*
(myptrchk)(const char *type, const char *caller, long sz, void *ptr)
{
#ifdef DEBUG_MEM
  printf("MEMDBG[%s]: '%s' 0x%p [%ld]\n", caller, type, ptr, sz);
#endif

  if (!ptr && sz)
    fatal_error("memory overflow, called from routine:", caller);

  return ptr;
}
