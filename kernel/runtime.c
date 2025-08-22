#include <stddef.h>
extern char __bss_start, __bss_end;
extern void kmain(void);

static void zero_bss(void){
  for(char* p=&__bss_start; p<&__bss_end; ++p) *p=0;
}

/* C++-ish glue */
void* __dso_handle;
void __cxa_pure_virtual(void){ for(;;) __asm__ volatile("hlt"); }

/* Minimal libc-ish */
void *memset(void *s, int c, size_t n){ unsigned char* p=s; while(n--) *p++=(unsigned char)c; return s; }
void *memcpy(void *d, const void *s, size_t n){ unsigned char* D=d; const unsigned char* S=s; while(n--) *D++=*S++; return d; }
void *memmove(void *d, const void *s, size_t n){
  unsigned char* D=d; const unsigned char* S=s;
  if(D<S) while(n--) *D++=*S++; else { D+=n; S+=n; while(n--) *--D=*--S; } return d;
}
int memcmp(const void *a, const void *b, size_t n){
  const unsigned char *A=a,*B=b; while(n--){ if(*A!=*B) return *A-*B; ++A; ++B; } return 0;
}

extern void serial_init(void);
extern void serial_puts(const char*);

__attribute__((used))
void kstart64(void){
  zero_bss();
  serial_init();
  serial_puts("mangOS online\n");
  kmain();
  for(;;) __asm__ volatile("hlt");
}
