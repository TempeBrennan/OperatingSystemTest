#include "gdt.h"

// access xxxx0000 xxxxxxxx
struct SegmentInfo createSegment(int addr, int size, short access) {
	struct SegmentInfo info;

	info.addr_low = addr & 0xFFFF;
	info.addr_mid = (addr >> 16) & 0xFF;
	info.addr_high = (addr >> 24) & 0xFF;

	info.size_low = size & 0xFFFF;
	info.size_high = ((size >> 16) & 0x0F) | ((access >> 8) & 0xF0);

	info.access = access & 0xFF;
	return info;
}

void initGDT() {
	int i = 0;
	struct SegmentInfo *start = (struct SegmentInfo *)0x00270000;
	struct SegmentInfo *cur = start;

	for (; i < 8192; i++) {
		*cur = createSegment(0, 0, 0);
		cur++;
	}
	*(start + 1) = createSegment(0x00000000, 0xFFFFFFFF, 0x4092);
	*(start + 2) = createSegment(0x00280000, 0x7FFFF, 0x409A);
	/* 共8192*8=65536个bit位，65535的16进制就是0xFFFF */
	setGDTR(0xFFFF, 0x00270000);
}
