#define S(s) (string){.data = (s), .len = sizeof(s) - 1}


__asm__ (".code16");



typedef struct {
	char* data;
	int   len;
} string;


void
bios_SetMode(int mode)
{
	__asm__ __volatile__ ("int $0x10\n\t"
		:
		: "a" (mode));
}


void
bios_WriteTeletype(char c, int page)
{
	__asm__ __volatile__ ("int $0x10\n\t"
		: 
		: "a" ((0xE << 8) | c), "b" (page << 8));
}


void
PrintString(string s)
{
	int i;

	for (i = 0; i < s.len; i++) {
		bios_WriteTeletype(s.data[i], 0);
	}
}


void
_start()
{
	bios_SetMode(3);
	PrintString(S("Hello, world!"));

	__asm__ __volatile__ ("xorw %ax, %ax\n\tint $0x16\n\tint $0x19\n\tcli\n\thlt\n\t");
	__asm__ __volatile__ (".org 510; .word 0xAA55");
}
