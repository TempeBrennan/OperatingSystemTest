
void paintRect(int x, int y, int width, int height, char color) {
	int i, j;
	char *p = (char*)0xa0000;
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			*(p + (y + i) * 320 + x + j) = color;
		}
	}
}

void paintChar(int x, int y, char* data, char color) {
	char *p = (char*)0xa0000;
	char *cur;
	int i = 0;
	for (; i < 16; i++) {
		char c = *(data + i);
		cur = p + (y + i) * 320 + x;
		if ((c & 0x80) != 0) {
			*(cur + 0) = color;
		}
		if ((c & 0x40) != 0) {
			*(cur + 1) = color;
		}
		if ((c & 0x20) != 0) {
			*(cur + 2) = color;
		}
		if ((c & 0x10) != 0) {
			*(cur + 3) = color;
		}
		if ((c & 0x08) != 0) {
			*(cur + 4) = color;
		}
		if ((c & 0x04) != 0) {
			*(cur + 5) = color;
		}
		if ((c & 0x02) != 0) {
			*(cur + 6) = color;
		}
		if ((c & 0x01) != 0) {
			*(cur + 7) = color;
		}
	}
}

void paintText(int x, int y, char* data, char color) {
	extern char hankaku[4096];
	int i = 0;
	while (*(data + i) != 0) {
		paintChar(x, y, hankaku + *(data + i) * 16, color);
		x += 8;
		i++;
	}
}
