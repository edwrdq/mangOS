#include <stdint.h>
static inline void outb(uint16_t p, uint8_t v){ __asm__ volatile("outb %0,%1"::"a"(v),"Nd"(p)); }
static inline uint8_t inb(uint16_t p){ uint8_t v; __asm__ volatile("inb %1,%0":"=a"(v):"Nd"(p)); return v; }

void serial_init(void){
  outb(0x3F8+1,0x00); outb(0x3F8+3,0x80);
  outb(0x3F8+0,0x03); outb(0x3F8+1,0x00);
  outb(0x3F8+3,0x03); outb(0x3F8+2,0xC7);
  outb(0x3F8+4,0x0B);
}
static int tx_ready(void){ return (inb(0x3F8+5) & 0x20)!=0; }
void serial_putc(char c){ while(!tx_ready()); outb(0x3F8, (uint8_t)c); }
void serial_puts(const char* s){ for(;*s;++s) serial_putc(*s); }
