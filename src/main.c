#include "paint.h"
#include "gdt.h"
#include "main.h"
#include "idt.h"
#include "pic.h"
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
	runMessageQueue();
}

extern struct MessageQueue messageQueue;
int start = 0;
void runMessageQueue() {
	for (;;) {
		unsigned char dataArr[40];
		cli();
		if (messageQueue.len == 0) {
			hlt();
			sti();
		}
		else {
			unsigned char data = messageQueue.data[messageQueue.start];
			messageQueue.len--;
			messageQueue.start = (messageQueue.start + 1) % MessageQueueLength;
			sti();

			sprintf(dataArr, "%02X", data);
			paintText(0, start, dataArr, 3);
			start += 16;
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
