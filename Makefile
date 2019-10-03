
boot: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

entry: ./src/entry.nas
	./tools/nask.exe ./src/entry.nas ./output/entry.bin

# ****************������һ���Ǳ���һ��c�ļ��ı�׼����******************************************************
%.gas: ./src/%.c
	./tools/cc1.exe -Itools/haribote/ -Os -Wall -quiet -o ./output/$*.gas ./src/$*.c

%.nas: %.gas
	./tools/gas2nask.exe -a ./output/$*.gas ./output/$*.nas

%.obj: %.nas
	./tools/nask.exe ./output/$*.nas ./output/$*.obj ./output/$*.list

helper.obj: ./src/helper.nas
	./tools/nask.exe ./src/helper.nas ./output/helper.obj

bim: main.obj helper.obj paint.obj hankaku.obj pointer.obj gdt.obj idt.obj pic.obj eventhandler.obj
	./tools/obj2bim.exe @./tools/haribote/haribote.rul \
	out:./output/main.bim stack:3136k map:./output/main.map \
	./output/main.obj ./output/helper.obj ./output/paint.obj ./output/hankaku.obj ./output/pointer.obj ./output/gdt.obj  ./output/idt.obj ./output/pic.obj ./output/eventhandler.obj

hrb: bim
	./tools/bim2hrb.exe ./output/main.bim ./output/main.hrb 0
# *****************������ɣ�����C�����Լ�����C���ԵĻ�඼���������һ��hrb�ļ���****************************

# ��������������
hankaku.bin : ./library/hankaku.txt
	./tools/makefont.exe ./library/hankaku.txt ./output/hankaku.bin

hankaku.obj : hankaku.bin
	./tools/bin2obj.exe ./output/hankaku.bin ./output/hankaku.obj _hankaku


# *************************�������entry���渽�Ӵ����Ĵ���***********************************************
merge: entry hrb
	copy /B .\output\entry.bin+.\output\main.hrb .\output\haribote.sys
# *************************merge�����������������Ĵ��룬ʣ����붼�ϲ�����sys�ļ���**************************

img: boot merge
	./tools/edimg.exe \
	imgin:./tools/fdimg0at.tek \
	wbinimg src:./output/boot.bin len:512 from:0 to:0 \
	copy from:.\output\haribote.sys to:@: \
	imgout:./output/helloos.img

# ʹ��make���Ҫд�����������ķ�ʽ��Ҫ�ĳ�ֱ����make��������
create:
	./tools/make.exe img

# ע����ֻ��copy������Ҫ�÷�б��
run: 
	./tools/make.exe create
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu