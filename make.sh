#!/bin/sh

OS=os.bin

case $1 in
	'' | build)
		as -o boot/boot.o boot/boot.s
		ld -o $OS -Ttext=0x7c00 --oformat=binary boot/boot.o
		;;
	run)
		qemu-system-i386 -vnc 0.0.0.0:0 -drive if=floppy,format=raw,file=$OS
		;;
	*)
		echo Unknown command $1 >&2
esac
