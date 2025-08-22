set -euo pipefail
qemu-system-x86_64 -cdrom build/mangos.iso -serial mon:stdio -no-reboot -no-shutdown
