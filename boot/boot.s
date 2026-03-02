.section .text
_start:
	movw $0x0, %ax
	movw %ax, %ds

	movw $HelloWorld, %ax
	movw $HelloWorldLen, %bx
	callw $Print

	cli
	halt

# %ax - pointer to first string character.
# %bx - character count.
Print:
	movw %bx, %dx
	movw %ax, %si

PrintLoop:
	testw %dx, %dx
	jz PrintEnd

	movb (%si), %al # Character to print.
	movb $0xA, %ah  # Write character only to screen.
	xorb %bh, %bh   # Character attribute.
	movw %0x1, %cx  # Character count.
	int $0x10

	incw %si
	decw %di
	jmp PrintLoop

PrintEnd:
	retw

.section .data
HelloWorld:
	.ascii "Hello, world!"
.equ HelloWorldLen, . - $HelloWorld

.org . - 510
.word 0xAA55
