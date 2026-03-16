.code16


# Params:
# 	(DS:AX) - pointer to the first byte of the string.
# 	BX - string length (in bytes).
TEXT video_PrintString
	movw %ax, %si
	movw %bx, %cx
	cld

1:
	testw %cx, %cx
	jz 2f

	lodsb
	xorw %bx, %bx
	call video_WriteTeletype

	decw %cx
	jmp 1b

2:
	retw


# Params:
# 	AX - word to print (in hexadecimal).
TEXT video_PrintWord
	.macro LPROCESS_NIBBLE
		movb %bl, %al
		andb $0xF, %al

		cmpb $0xA, %al
		jl 1f

		addb $('A' - 0xA), %al
		jmp 2f

	1:
		addb $'0', %al
	2:
		stosb
		shrw %cl, %bx
	.endm

	movw %ax, %bx

	# TODO(anton2920): PrintString requires address based on DS. STOSB stores in address based on ES.
	movw $video_WriteWordBuffer+3, %di
	movb $0x4, %cl
	std

	LPROCESS_NIBBLE
	LPROCESS_NIBBLE
	LPROCESS_NIBBLE
	LPROCESS_NIBBLE

	movw $video_WriteWordBuffer, %ax
	movw $0x4, %bx
	call video_PrintString

	retw

.lcomm video_WriteWordBuffer, 4
