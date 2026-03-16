.code16
.arch i8086

.include "defs.s"


.macro MOVE_CURSOR_RIGHT
	xorw %ax, %ax
	call video_GetCursorPosition
	incw %ax
	xorw %bx, %bx
	call video_SetCursorPosition
.endm


# Should be at 0000:7C00.
TEXT _start
	movw $0x0, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss

	movw $0x9000, %sp
	movw %sp, %bp

	movb $0x3, %al
	call video_SetMode

	movw $HelloWorld, %ax
	movw $len_HelloWorld, %bx
	call video_PrintString

	MOVE_CURSOR_RIGHT

	movw $0xFEDA, %ax
	call video_PrintWord

	MOVE_CURSOR_RIGHT

	pushw %sp
	popw %ax
	call video_PrintWord

	xorw %ax, %ax
	int $0x16

	int $0x19

	cli
	hlt


.include "bios/video/functions.s"
.include "bios/video/utils.s"


ASCII HelloWorld,   "Hello, world!"


.org 510
.word 0xAA55
