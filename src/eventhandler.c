#include "eventhandler.h"
#include "paint.h"
#include "main.h"
#include "pic.h"
#include <stdio.h>

struct MessageQueue keyboardQueue;
struct MessageQueue mouseQueue;

void mouseHandler(void) {
	unsigned char data;

	/* 1. 通知IRQ12 IRQ2中断已经处理完毕*/
	setDataToPort(0x00A0, 0x60 + 4);
	setDataToPort(0x0020, 0x60 + 2);
	/* 2. 0x0060对应的设备是键盘*/
	data = getDataFromPort(0x0060);

	if (mouseQueue.len < MessageQueueLength) {
		mouseQueue.data[mouseQueue.end] = data;
		mouseQueue.len++;
		mouseQueue.end = (mouseQueue.end + 1) % MessageQueueLength;
	}
}

void keyboardHandler(void) {
	unsigned char data;

	/* 1. 通知IRQ1中断已经处理完毕*/
	setDataToPort(0x0020, 0x60 + 1);
	/* 2. 0x0060对应的设备是键盘*/
	data = getDataFromPort(0x0060);

	if (keyboardQueue.len < MessageQueueLength) {
		keyboardQueue.data[keyboardQueue.end] = data;
		keyboardQueue.len++;
		keyboardQueue.end = (keyboardQueue.end + 1) % MessageQueueLength;
	}
}

void int27handler(void) {
	//paintText(0, 150, "Other interrupt", 3);
}

