.macro TEXT name
	.globl \name
	.type \name, @function
	\name:
.endm

.macro ASCII name value
	\name:
		.ascii "\value"
	.equ len_\name, . - \name
.endm
