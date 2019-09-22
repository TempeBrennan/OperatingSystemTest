
boot: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

entry: ./src/entry.nas
	./tools/nask.exe ./src/entry.nas ./output/entry.sys

# ������һ���Ǳ���һ��c�ļ��ı�׼����
gas: ./src/main.c
	./tools/cc1.exe -Itools/haribote/ -Os -Wall -quiet -o ./output/main.gas ./src/main.c

nas: ./output/main.gas
	./tools/gas2nask.exe -a ./output/main.gas ./output/main.nas

img: boot entry
	./tools/edimg.exe \
	imgin:./tools/fdimg0at.tek \
	wbinimg src:./output/boot.bin len:512 from:0 to:0 \
	copy from:.\output\entry.sys to:@: \
	imgout:./output/helloos.img

# ʹ��make���Ҫд�����������ķ�ʽ��Ҫ�ĳ�ֱ����make��������
create:
	./tools/make.exe img

# ע����ֻ��copy������Ҫ�÷�б��
run: 
	./tools/make.exe create
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu