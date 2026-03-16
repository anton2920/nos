#!/bin/sh

PROJECT=nos.bin

VERBOSITY=0
VERBOSITYFLAGS=""
while test "$1" = "-v"; do
	VERBOSITY=$((VERBOSITY+1))
	VERBOSITYFLAGS="$VERBOSITYFLAGS -v"
	shift
done

now()
{
	date +%s%N
}

run()
{
	if test $VERBOSITY -gt 1; then echo "$@"; fi
	"$@" || exit 1
}

STARTTIME=`now`

TARGET=$1
shift

case $TARGET in
	'' | build)
		# run as -o boot/boot.o boot/boot.s
		# run ld -o $PROJECT -Ttext=0x7c00 --oformat=binary boot/boot.o
		run cc -o $PROJECT -m16 -nostdlib -Wl,-Ttext=0x7c00 -Wl,--oformat=binary boot/boot.c
		run cc -S -o $PROJECT.s -m16 boot/boot.c
		run dd if=$PROJECT of=disk.img bs=512 count=1 seek=0 conv=notrunc status=none
		;;
	run-qemu)
		run qemu-system-i386 -vnc 0.0.0.0:0 -drive if=floppy,format=raw,file=$OS
		;;
	*)
		printf "Target '%s' is not supported!\n" $TARGET >&2
		exit 1
		;;
esac

ENDTIME=`now`
ELAPSEDMS=`echo "scale=2; ($ENDTIME-$STARTTIME)/1000000" | bc`

echo Done $TARGET in "$ELAPSEDMS"ms
