
struct InterruptInfo
{
	short offset_low;
	short selector;
	char count;
	char access_right;
	short offset_high;
};

struct InterruptInfo createInterruptInfo(short selector, int offset, short access);
void initIDT(void);
void setIDTR(int size, int addr);
void int21Handler(void);
void int27Handler(void);
void int2cHandler(void);
