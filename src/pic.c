#include "pic.h"

void initPIC(void) {

	setDataToPort(0x0021, 0xFF);
	setDataToPort(0x00A1, 0xFF);

	/* �������˳�򣬻������PIC��ICW1~ICW4 */
	setDataToPort(0x0020, 0x11);
	setDataToPort(0x0021, 0x20);
	/* ��PIC��IRQ3�����Ŵ�PIC*/
	setDataToPort(0x0021, 0x08);
	setDataToPort(0x0021, 0x01);

	/* �������˳�򣬻������PIC��ICW1~ICW4 */
	setDataToPort(0x00A0, 0x11);
	setDataToPort(0x00A1, 0x28);
	/* ��PIC��IRQ2��������һ��PIC��Ŀǰδʹ�� */
	setDataToPort(0x00A1, 0x02);
	setDataToPort(0x00A1, 0x01);

	setDataToPort(0x0021, 0xFB);
	setDataToPort(0x00A1, 0xFF);
	return;
}
