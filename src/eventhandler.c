#include "eventhandler.h"
#include "paint.h"
#include "main.h"
#include "pic.h"
#include <stdio.h>

struct MessageQueue messageQueue;

void mouseHandler(void) {
	//paintText(0, 0, "User move mouse", 3);
}

void keyboardHandler(void) {
	unsigned char data;
	paintText(0, 0, "User move mouse", 3);

	/* 1. ֪ͨIRQ1�ж��Ѿ��������*/
	setDataToPort(0x0020, 0x60 + 1);
	/* 2. 0x0060��Ӧ���豸�Ǽ���*/
	data = getDataFromPort(0x0060);

	if (messageQueue.len < MessageQueueLength) {
		messageQueue.data[messageQueue.end] = data;
		messageQueue.len++;
		messageQueue.end = (messageQueue.end + 1) % MessageQueueLength;
	}
}

void int27handler(void) {
	//paintText(0, 150, "Other interrupt", 3);
}

