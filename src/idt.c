#include "idt.h"

struct InterruptInfo createInterruptInfo(short selector, int offset, short access) {
	struct InterruptInfo info;
	info.selector = selector;
	info.offset_low = offset & 0xFFFF;
	info.offset_high = (offset >> 16) & 0xFFFF;
	info.access_right = access & 0xFF;
	info.count = (access >> 8) & 0xFF;
	return info;
}

void initIDT(void) {
	int i = 0;
	struct InterruptInfo* start = (struct InterruptInfo*)0x00268000;
	struct InterruptInfo* cur = start;
	for (; i < 256; i++) {
		*(cur) = createInterruptInfo(0, 0, 0);
		cur++;
	}

	/* ��256���飬һ��8bit����2048��2047��0x07FF */
	setIDTR(0x07FF, 0x00268000);
}
