#include "eventhandler.h"
#include "paint.h"
#include "pic.h"
#include <stdio.h>

void mouseHandler(void) {
	//paintText(0, 0, "User move mouse", 3);
}

int start = 0;
void keyboardHandler(void) {
	unsigned char dataArr[4], data;

	/* 1. ֪ͨIRQ1�ж��Ѿ��������*/
	setDataToPort(0x0020, 0x60 + 1);
	/* 2. 0x0060��Ӧ���豸�Ǽ���*/
	data = getDataFromPort(0x0060);

	sprintf(dataArr, "%02X", data);
	paintText(0, start, dataArr, 3);
	start += 16;
}

void int27handler(void) {
	//paintText(0, 150, "Other interrupt", 3);
}

