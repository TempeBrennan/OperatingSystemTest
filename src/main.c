#include "paint.h"
#include "gdt.h"
#include "main.h"

void HariMain(void) {
	initSegment();
	paintRect(10, 20, 200, 80, 12);
	paintRect(230, 50, 10, 30, 6);
	paintRect(150, 100, 90, 30, 3);

	paintText(20, 140, "Hello, What's your name?", 12);
	paintText(150, 160, "How are you?", 6);
	paintText(200, 180, "Thank you!", 3);

	paintCursor(100, 70);

	for (;;) {
		hlt();
	}
}
