.code16

.section .text
.globl _start
_start:
	movw $0x0, %ax
	movw %ax, %ds
	movw %ax, %es

	movw $0x9000, %ax
	movw %ax, %ss

	movw $HelloWorld, %ax
	movw $HelloWorldLen, %bx
	movw $-1, %cx
	call Print

	movw $HelloWorld, %ax
	movw $HelloWorldLen, %bx
	movw $0xF4, %cx
	call Print

	cli
	hlt

# %ax - pointer to first string character.
# %bx - character count.
# %cx - attribute (-1 to use default).
.equ DefaultCharacterAttribute, 0x07
Print:
	pushw %ax
	pushw %bx
	pushw %cx

	movb $0x3, %ah # Read cursor position.
	xorw %bx, %bx  # Page number.
	int $0x10

	popw %bx
	testw %bx, %bx
	js PrintSetDefaultAttribute

	andw $0xFF, %bx
	jmp PrintAction

PrintSetDefaultAttribute:
	movw $DefaultCharacterAttribute, %bx

PrintAction:
	popw %cx          # Length of the string.
	popw %bp          # Pointer to start of the string.
	movb $0x1,  %al   # Leave cursor at the last printed character and take attributes from %bl.
	movb $0x13, %ah   # Write string.
	int $0x10
	retw

HelloWorld:
	.ascii "Hello, world!"
.equ HelloWorldLen, . - HelloWorld

.org 510
.word 0xAA55
