
entry: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

img: entry
	./tools/edimg.exe imgin:./tools/fdimg0at.tek wbinimg src:./output/boot.bin len:512 from:0 to:0 imgout:./output/helloos.img

#使用make命令不要写成上面依赖的方式，要改成直接找make，传参数
create:
	./tools/make.exe img

run: 
	./tools/make.exe create
	# 注意下只有copy命令需要用\
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu
	