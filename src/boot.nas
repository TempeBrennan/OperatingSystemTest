org 0x7C00

;第一次忘记加jmp导致制作img抛错
JMP entry

;软盘格式专用代码
DB  0x90
DB  "BOOTINFO"
DW  512
DB  1
DW  1
DB  2
DW  224
DW  2880
DB  0xF0
DW  9
DW  18
DW  2
DD  0
DD  2880
DB  0,0,0x29
DD  0xFF,0xFF,0xFF,0xFF
DB  ""
DB  "FAT12   "
RESB    18

entry:
MOV SI,information
MOV AH,0x0E
MOV	BH,0x00
MOV BL,0xFF
log:
MOV	AL,[SI]
CMP	AL,0
JE loop
INT 0x10
ADD	SI,1
JMP log

loop:
HLT
JMP loop


information:
DB  0x0A,0x0A
DB  "Welcome to my computer!"
DB  0x0A,0x0A

;启动区结束代码
RESB 0x7DFE-$
DB 0x55,0xAA