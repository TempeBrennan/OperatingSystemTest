#include "paint.h"
#include "gdt.h"
#include "main.h"
#include "idt.h"
#include "pic.h"
#include "mouse.h"
#include <stdio.h>

void HariMain(void) {
	init();

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
					paintRect(0, 0, 320, 16, 0);
					sprintf(printStr, "%02X %02X %02X",
						mouseMessage.data[0], mouseMessage.data[1], mouseMessage.data[2]);
					paintText(0, 0, printStr, 3);
				}
			}
		}
	}
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
