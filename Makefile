
boot: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

entry: ./src/entry.nas
	./tools/nask.exe ./src/entry.nas ./output/entry.bin

# ****************下面这一套是编译一个c文件的标准过程******************************************************
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
# *****************编译完成，所有C语言以及辅助C语言的汇编都被打包进了一个hrb文件中****************************

# 额外混入字体对象
hankaku.bin : ./library/hankaku.txt
	./tools/makefont.exe ./library/hankaku.txt ./output/hankaku.bin

hankaku.obj : hankaku.bin
	./tools/bin2obj.exe ./output/hankaku.bin ./output/hankaku.obj _hankaku


# *************************在这里给entry后面附加打包后的代码***********************************************
merge: entry hrb
	copy /B .\output\entry.bin+.\output\main.hrb .\output\haribote.sys
# *************************merge结束，除了启动区的代码，剩余代码都合并到了sys文件中**************************

img: boot merge
	./tools/edimg.exe \
	imgin:./tools/fdimg0at.tek \
	wbinimg src:./output/boot.bin len:512 from:0 to:0 \
	copy from:.\output\haribote.sys to:@: \
	imgout:./output/helloos.img

# 使用make命令不要写成上面依赖的方式，要改成直接找make，传参数
create:
	./tools/make.exe img

# 注意下只有copy命令需要用反斜线
run: 
	./tools/make.exe create
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu