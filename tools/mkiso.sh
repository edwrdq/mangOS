set -euo pipefail
rm -rf iso
mkdir -p iso/boot/grub
cp kernel.elf iso/boot/kernel.elf
cat > iso/boot/grub/grub.cfg <<'CFG'
set timeout=0
set default=0
menuentry "mangOS" {
  multiboot2 /boot/kernel.elf
}
CFG
grub-mkrescue -o build/mangos.iso iso
echo "ISO at build/mangos.iso"
