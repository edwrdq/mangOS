CC=clang
AS=as
LD=ld.lld
CFLAGS=-ffreestanding -fno-exceptions -fno-rtti -m64 -mno-red-zone -O2 -Wall -Wextra
LDFLAGS=-nostdlib -z max-page-size=0x1000 -T linker.ld

all: kernel.elf

boot/boot.o: boot/boot.S
	$(AS) -o $@ $<
boot/longmode.o: boot/longmode.S
	$(AS) -o $@ $<

kernel/runtime.o: kernel/runtime.c
	$(CC) $(CFLAGS) -c -o $@ $<
kernel/serial.o: kernel/serial.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Your compiler emits .o; replace this line with your dmmc command.
kernel/kmain.o: kernel/kmain.dmm
	@echo "TODO: replace with dmmc --no-link"
	@cp /dev/null $@

kernel.elf: boot/boot.o boot/longmode.o kernel/runtime.o kernel/serial.o kernel/kmain.o linker.ld
	$(LD) $(LDFLAGS) -o $@ boot/boot.o boot/longmode.o kernel/runtime.o kernel/serial.o kernel/kmain.o

iso: kernel.elf
	tools/mkiso.sh

run: iso
	tools/run-qemu.sh

clean:
	rm -f boot/*.o kernel/*.o kernel.elf
	rm -rf iso build

.PHONY: all iso run clean
