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

extern struct MessageQueue messageQueue;
extern struct MessageQueue mouseQueue;

void runMessageQueue() {
	for (;;) {
		unsigned char dataArr[40], data;
		cli();
		if (messageQueue.len == 0 && mouseQueue.len == 0) {
			hlt();
			sti();
		}
		else {
			if (messageQueue.len != 0) {
				data = messageQueue.data[messageQueue.start];
				messageQueue.len--;
				messageQueue.start = (messageQueue.start + 1) % MessageQueueLength;
			}
			else if (mouseQueue.len != 0) {
				data = mouseQueue.data[mouseQueue.start];
				mouseQueue.len--;
				mouseQueue.start = (mouseQueue.start + 1) % MessageQueueLength;
			}
			sti();
			paintRect(0, 0, 320, 16, 0);
			sprintf(dataArr, "%02X", data);
			paintText(0, 0, dataArr, 3);
		}
	}
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
