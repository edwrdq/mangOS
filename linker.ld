OUTPUT_FORMAT(elf64-x86-64)
ENTRY(kstart32)
SECTIONS {
  . = 0x00100000;                 /* load at 1 MiB */
  .multiboot ALIGN(8) : { KEEP(*(.multiboot)) }
  .text  ALIGN(0x1000) : { *(.text .text.*) }
  .rodata ALIGN(0x1000) : { *(.rodata .rodata.*) }
  .data  ALIGN(0x1000) : { *(.data .data.*) }
  .bss   ALIGN(0x1000) : {
    __bss_start = .; *(.bss .bss.* COMMON); __bss_end = .;
  }
}
