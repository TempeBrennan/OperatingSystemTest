
boot: ./src/boot.nas
	./tools/nask.exe ./src/boot.nas ./output/boot.bin

entry: ./src/entry.nas
	./tools/nask.exe ./src/entry.nas ./output/entry.sys

# 下面这一套是编译一个c文件的标准过程
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

# 使用make命令不要写成上面依赖的方式，要改成直接找make，传参数
create:
	./tools/make.exe img

# 注意下只有copy命令需要用反斜线
run: 
	./tools/make.exe create
	copy .\output\helloos.img .\tools\qemu\fdimage0.bin
	./tools/make.exe -C ./tools/qemu