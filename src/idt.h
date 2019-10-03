
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