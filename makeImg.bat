.\tools\nask.exe ./src/boot.nas ./output/boot.bin

.\tools\edimg.exe imgin:./tools/fdimg0at.tek wbinimg src:./output/boot.bin len:512 from:0 to:0 imgout:./output/helloos.img

copy .\output\helloos.img .\tools\qemu\fdimage0.bin
.\tools\make.exe -C ./tools/qemu