#include "paint.h"
#include "gdt.h"
#include "main.h"
#include "idt.h"
#include "pic.h"
#include "mouse.h"
#include "memory.h"
#include <stdio.h>

void HariMain(void) {
	unsigned char printStr[40];
	init();

	int isAbove486 = getIsComputerAbove486();
	if (isAbove486 == 1) {
		disableCache();
	}

	int result = getEndAvailableMemoryAddr(0x00400000, 0xbfffffff) / (1024 * 1024);
	sprintf(printStr, "memory is %d MB", result);
	paintText(0, 0, printStr, 6);

	if (isAbove486 == 1) {
		enableCache();
	}
	/*paintRect(10, 20, 200, 80, 12);
	paintRect(230, 50, 10, 30, 6);
	paintRect(150, 100, 90, 30, 3);

	paintText(20, 140, "Hello, What's your name?", 12);
	paintText(150, 160, "How are you?", 6);
	paintText(200, 180, "Thank you!", 3);

	paintCursor(100, 70);*/
	resume();
	initMouse();
	runMessageQueue();
}

extern struct MessageQueue keyboardQueue;
extern struct MessageQueue mouseQueue;

void runMessageQueue() {
	struct MouseMessage mouseMessage;
	// 初始化鼠标的坐标
	int x = 40, y = 40;
	paintCursor(x, y);
	for (;;) {
		unsigned char printStr[40], data;
		cli();
		if (keyboardQueue.len == 0 && mouseQueue.len == 0) {
			hlt();
			sti();
		}
		else {
			if (keyboardQueue.len != 0) {
				data = keyboardQueue.data[keyboardQueue.start];
				keyboardQueue.len--;
				keyboardQueue.start = (keyboardQueue.start + 1) % MessageQueueLength;
				sti();
				paintRect(0, 0, 320, 16, 0);
				sprintf(printStr, "%02X", data);
				paintText(0, 0, printStr, 3);
			}
			else if (mouseQueue.len != 0) {
				data = mouseQueue.data[mouseQueue.start];
				mouseQueue.len--;
				mouseQueue.start = (mouseQueue.start + 1) % MessageQueueLength;
				sti();
				if (collectMouseMessage(&mouseMessage, data) == 1) {
					updateMouseMessage(&mouseMessage);
					/*paintRect(0, 0, 320, 16, 0);
					sprintf(printStr, "mouse state: %3d x: %3d y: %3d",
						mouseMessage.state, mouseMessage.x, mouseMessage.y);
					paintText(0, 0, printStr, 3);*/
					paintRect(x, y, 16, 16, 0);
					x += mouseMessage.x;
					y += mouseMessage.y;
					if (x < 0) {
						x = 0;
					}
					if (y < 0) {
						y = 0;
					}
					if (x > 320 - 16) {
						x = 320 - 16;
					}
					if (y > 200 - 16) {
						y = 200 - 16;
					}
					paintCursor(x, y);
				}
			}
		}
	}
}

void updateMouseMessage(struct MouseMessage* mouseMessage) {
	// 获取按下哪个键需要第一个字节与 00000111 与运算
	char state = (mouseMessage->data[0] & 0x07);
	if ((state & 0x01) != 0) {
		mouseMessage->state = 'L';
	}
	else if ((state & 0x02) != 0) {
		mouseMessage->state = 'R';
	}
	else if ((state & 0x04) != 0) {
		mouseMessage->state = 'C';
	}
	else
	{
		mouseMessage->state = 'N';
	}

	mouseMessage->x = mouseMessage->data[1];
	// 不能对unsigned类型变负数
	mouseMessage->y = mouseMessage->data[2];
	if (((mouseMessage->data[0]) & 0x10) != 0) {
		mouseMessage->x |= 0xFFFFFF00;
	}
	if (((mouseMessage->data[0]) & 0x20) != 0) {
		mouseMessage->y |= 0xFFFFFF00;
	}
	mouseMessage->y = -mouseMessage->y;
}

//C语言没有bool类型
int collectMouseMessage(struct MouseMessage* mouseMessage, unsigned char data) {
	if (mouseMessage->phase == 0) {
		mouseMessage->phase = 1;
		return 0;
	}
	else if (mouseMessage->phase == 1) {
		mouseMessage->data[0] = data;
		mouseMessage->phase = 2;
		return 0;
	}
	else if (mouseMessage->phase == 2) {
		mouseMessage->data[1] = data;
		mouseMessage->phase = 3;
		return 0;
	}
	else if (mouseMessage->phase == 3) {
		mouseMessage->data[2] = data;
		mouseMessage->phase = 1;
		return 1;
	}
	return 0;
}

void init(void) {
	initGDT();
	initIDT();
	initPIC();
	sti();
}

void resume(void) {
	resumePIC();
}
