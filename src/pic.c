#include "pic.h"

void initPIC(void) {

	setDataToPort(0x0021, 0xFF);
	setDataToPort(0x00A1, 0xFF);

	/* 按照这个顺序，会设给主PIC的ICW1~ICW4 */
	setDataToPort(0x0020, 0x11);
	setDataToPort(0x0021, 0x20);
	/* 主PIC的IRQ3连接着从PIC*/
	setDataToPort(0x0021, 0x08);
	setDataToPort(0x0021, 0x01);

	/* 按照这个顺序，会设给从PIC的ICW1~ICW4 */
	setDataToPort(0x00A0, 0x11);
	setDataToPort(0x00A1, 0x28);
	/* 从PIC的IRQ2连接着下一个PIC，目前未使用 */
	setDataToPort(0x00A1, 0x02);
	setDataToPort(0x00A1, 0x01);

	setDataToPort(0x0021, 0xFB);
	setDataToPort(0x00A1, 0xFF);
	return;
}

void resumePIC(void) {
	/* IRQ7~IRQ0 -> 1111 1001 IRQ1对应键盘, IRQ2对应从PIC*/
	setDataToPort(0x0021, 0xF9);
	/* IRQ15~IRQ8 -> 1110 1111 IRQ12对应鼠标*/
	setDataToPort(0x00A1, 0xFF);
}