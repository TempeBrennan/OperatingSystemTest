
boot: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

entry: ./src/entry.nas
	./tools/nask.exe ./src/entry.nas ./output/entry.sys

# ������һ���Ǳ���һ��c�ļ��ı�׼����
gas: ./src/main.c
	./tools/cc1.exe -Itools/haribote/ -Os -Wall -quiet -o ./output/main.gas ./src/main.c

nas: ./output/main.gas
	./tools/gas2nask.exe -a ./output/main.gas ./output/main.nas

obj: ./output/main.nas
	./tools/nask.exe ./output/main.nas ./output/main.obj ./output/main.list

bim: ./output/main.obj
	./tools/obj2bim.exe @./tools/haribote/haribote.rul \
	out:./output/main.bim stack:3136k map:./output/main.map \
	./output/main.obj 

hrb: ./output/main.bim
	./tools/bim2hrb.exe ./output/main.bim ./output/main.hrb 0
# ������ɣ�����C�����Լ�����C���ԵĻ�඼���������һ��hrb�ļ���

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