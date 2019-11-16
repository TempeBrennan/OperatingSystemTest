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

