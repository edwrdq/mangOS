# mangOS bootstrap
- x86_64, GRUB2 Multiboot2, ELF64.
- Build: `make` (replace the kmain.o rule with your dih-- compiler)
- ISO: `make iso`
- Run: `make run` (QEMU)

Checklist:
- Ensure `grub-mkrescue` and `ld.lld` are installed.
- Replace `kernel/kmain.o` recipe to call your compiler (`dmmc --no-link -o kernel/kmain.o kernel/kmain.dmm`).
