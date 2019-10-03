
struct SegmentInfo {
	short size_low;
	short addr_low;
	char addr_mid;
	char access;
	char size_high;
	char addr_high;
};

struct SegmentInfo createSegment(int addr, int size, short access);
void setGDTR(int size, int addr);
void initGDT();
