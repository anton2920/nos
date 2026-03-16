.code16


# AH=0. The Set Video Mode Function sets the video mode registers for operation in any supported mode. It selects the active video mode if more than one is installed, clears the screen, positions the cursor at (0,0) and resets the color palette to default color values. 
# Params:
# 	AX - Mode to set.
TEXT video_SetMode
	xorb %ah, %ah
	int $0x10
	retw


# AH=2. The Set Cursor Position function sets the cursor position (in terms of row-by-column coordinates) for the display page indicated in BL. It saves the position as a two-byte row-by-column table entry in the cursor coordinates byte at 40:50h. Row and column coordinates are indicated in registers DH and DL respectively. The Set Cursor Position function applies to both text and graphics video modes. In text modes, if the display page selected in BH is the active dis- play page, the screen cursor will move to the coordinates indicated in registers DH and DL. In graphics modes, the cursor is invisible but is used to define a position on the screen.
# Params:
# 	AX - (row << 8 | col): AH - row, AL - col.
# 	BX - page.
TEXT video_SetCursorPosition
	movw %ax, %dx
	movb %bl, %bh
	movb $0x2, %ah
	int $0x10
	retw


# AH=3. The Read Current Cursor Position function reads the cursor position for the given video page from the cursor coordinates byte at 40:50h. It reads the cursor type from 40:60h and returns the current cursor position in text coordinates. This function is useful for determining the exact cursor type before it is changed.
# Params:
# 	AX - display page.
TEXT video_GetCursorPosition
	movb %al, %bh
	movb $0x3, %ah
	int $0x10
	movw %dx, %ax
	retw


# AH=9. The Write Character/Attribute function writes the character to the screen starting at the current cursor location for as many times as indicated in the CX register. The cursor is not moved even if more than one character is written, unless the same character is repeated.
# Params:
# 	AX - (attribute << 8 | character): AL - character to write, AH - attribute.
# 	BX - display page.
#	CX - repeat count.
TEXT video_WriteCharacterWithAttribute
	movb %bl, %bh
	movb %ah, %bl
	movb $0x9, %ah
	int $0x10
	retw


# AH=10. The Write Character Only to Screen function operates identically to the Write Character/Attribute function, except that for text modes the attribute bytes corresponding to the characters remain unchanged. This function is often used to write a character to the screen in text modes.
# Params:
# 	AX - character to write.
# 	BX - display page.
# 	CX - repeat count.
TEXT video_WriteCharacter
	movb %bl, %bh
	movb $0xA, %ah
	int $0x10
	retw


# AH=14. This function makes the display appear as a serial terminal. The character in AL is written to video memory to be placed in the active page at the current cursor position and the cursor is moved to the next character location (scrolling is necessary). Screen width is a function of the video mode currently in effect.
# Params:
# 	AX - chacter to write.
# 	BX - active page.
TEXT video_WriteTeletype
	movb %bl, %bh
	xorb %bl, %bl
	movb $0xE, %ah
	int $0x10
	retw
