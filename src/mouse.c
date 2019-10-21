#include "pic.h"

void waitKBCReady(void) {
	for (;;) {
		if ((getDataFromPort(0x0064) & 0x02) == 0) {
			break;
		}
	}
	return;
}

void initMouse(void) {

	/*设置键盘电路*/
	waitKBCReady();
	setDataToPort(0x0064, 0x60);
	waitKBCReady();
	setDataToPort(0x0060, 0x47);

	/*激活鼠标*/
	waitKBCReady();
	setDataToPort(0x0064, 0xD4);
	waitKBCReady();
	setDataToPort(0x0060, 0xF4);
}



