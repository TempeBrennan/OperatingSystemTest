#include "eventhandler.h"
#include "paint.h"

void mouseHandler(void) {
	paintText(0, 0, "User move mouse", 3);
}

void keyboardHandler(void) {
	paintText(0, 100, "User press key", 3);
}

void int27handler(void) {
	paintText(0, 150, "Other interrupt", 3);
}

