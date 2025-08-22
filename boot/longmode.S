    .text
    .globl enter_longmode
enter_longmode:
    lgdt gdt_desc

    mov $pml4, %eax
    mov %eax, %cr3

    mov %cr4, %eax
    or  $0x20, %eax          /* PAE */
    mov %eax, %cr4

    mov $0xC0000080, %ecx    /* EFER */
    rdmsr
    or  $0x100, %eax         /* LME */
    wrmsr

    mov %cr0, %eax
    or  $0x80000001, %eax    /* PG|PE */
    mov %eax, %cr0

    ljmp $0x08, $long64_entry

    .code64
    .extern kstart64
long64_entry:
    lea kstack_top(%rip), %rsp
    call kstart64
halt64: hlt; jmp halt64

    .code32
    .align 4096
pml4:   .quad pdpt | 0x003
        .zero 4096-8
    .align 4096
pdpt:   .quad pd   | 0x003
        .zero 4096-8
    .align 4096
pd:
    .set i,0
.rept 512
    .quad (i*0x200000) | 0x083  /* Present|RW|PS */
    .set i, i+1
.endr

/* GDT: null, 64-bit code, 64-bit data */
    .p2align 3
gdt:
    .quad 0
    .quad 0x00AF9A000000FFFF
    .quad 0x00AF92000000FFFF
gdt_desc:
    .word (3*8)-1
    .long gdt

    .bss
    .align 16
kstack:     .skip 8192
kstack_top:
