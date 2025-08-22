/* Multiboot2 header and 32-bit entry */
    .section .multiboot, "a"
    .align 8
mb2_header:
    .long  0xE85250D6       /* magic */
    .long  0                 /* arch 0 */
    .long  mb2_end - mb2_header
    .long  -(0xE85250D6 + 0 + (mb2_end - mb2_header))
    /* end tag */
    .short 0
    .short 0
    .long  8
mb2_end:

    .text
    .globl kstart32
kstart32:
    /* GRUB gives EBX = mb_info; stash if you care */
    mov %ebx, mb_info_ptr
    lea stack_top(%eax), %esp
    call enter_longmode
hang32: hlt; jmp hang32

    .bss
    .align 16
stack_space: .skip 4096
stack_top:

    .data
    .globl mb_info_ptr
mb_info_ptr: .long 0
