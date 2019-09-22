void paintRect(int x, int y, int width, int height, char color) {
	int i, j;
	char *p = (char*)0xa0000;
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			*(p + (y + i) * 320 + x + j) = color;
		}
	}
}
