#include "memory.h"

// 返回是否是486以上的机器
int getIsComputerAbove486() {
	unsigned int eFlags = getEFlags();
	int result = 0;
	// 00000000 00000100 00000000 00000000
	int flag = 0x00040000;
	eFlags |= flag;
	setEFlags(eFlags);

	eFlags = getEFlags();
	if ((eFlags & flag) != 0) {
		result = 1;
	}

	eFlags &= ~flag;
	setEFlags(eFlags);
	return result;
}

void enableCache() {
	unsigned int cr0Data = getCR0();
	// 01100000 00000000 00000000 00000000
	cr0Data &= ~0x60000000;
	setCR0(cr0Data);
}

void disableCache() {
	unsigned int cr0Data = getCR0();
	// 01100000 00000000 00000000 00000000
	cr0Data |= 0x60000000;
	setCR0(cr0Data);
}

unsigned int getEndAvailableMemoryAddr(unsigned int startAddr, unsigned int endAddr) {
	unsigned int i = startAddr, *p;
	unsigned int originalData;
	unsigned int testData = 0xAA55AA55;
	unsigned int revertTestData = 0x55AA55AA;
	for (; i <= endAddr; i += 0x1000) {
		p = (unsigned int *)(i + 0xFFC);
		originalData = *p;
		//1. First Set
		*p = testData;

		//2. Second Set Value and Test
		*p ^= 0xFFFFFFFF;
		if (*p != revertTestData) {
			*p = originalData;
			break;
		}

		//3. Third Set Value and Test
		*p ^= 0xFFFFFFFF;
		if (*p != testData) {
			*p = originalData;
			break;
		}
		*p = originalData;
	}
	return i;
}