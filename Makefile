
entry: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

img: entry
	./tools/edimg.exe imgin:./tools/fdimg0at.tek wbinimg src:./output/boot.bin len:512 from:0 to:0 imgout:./output/helloos.img

#ʹ��make���Ҫд�����������ķ�ʽ��Ҫ�ĳ�ֱ����make��������
create:
	./tools/make.exe img

run: 
	./tools/make.exe create
	# ע����ֻ��copy������Ҫ��\
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu
	