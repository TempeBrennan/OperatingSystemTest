#include "paint.h"

void HariMain(void) {
	paintRect(10, 20, 200, 80, 12);
	paintRect(230, 50, 10, 30, 6);
	paintRect(150, 100, 90, 30, 3);

	for (;;) {
		hlt();
	}
}
