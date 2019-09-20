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
;初始化
MOV AX,0
MOV SS,AX
MOV SP,0x7c00
MOV DS,AX

MOV SI,information
MOV AH,0x0E
MOV	BH,0x00
MOV BL,0xFF

firstprint:
MOV	AL,[SI]
CMP	AL,0
JE load
INT 0x10
ADD	SI,1
JMP firstprint

load:
MOV AX,0x0820
MOV ES,AX
MOV CH,0
MOV CL,2
MOV DH,0

loadsection:
MOV SI,0

read:
MOV AH,0x02
MOV AL,0x01
MOV DL,0x00
MOV BX,0
INT 0x13
JNC loadcylinder
ADD SI,1
CMP SI,5
JAE loaderror

;这里载入失败，需要做一次重置
MOV AH,0x00
MOV DL,0x00
INT 0x13
JMP read

;否则就开始输出加载错误的信息
loaderror:
MOV SI,loaderrorinformation
MOV AH,0x0E
MOV	BH,0x00
MOV BL,0xFF
print:
MOV	AL,[SI]
CMP	AL,0
JE loop
INT 0x10
ADD	SI,1
JMP print 

loadcylinder:
MOV AX,ES
ADD AX,0x0020
MOV ES,AX
ADD CL,1
CMP CL,18
JBE loadsection
MOV CL,1
ADD DH,1
CMP DH,2
JB loadsection
MOV DH,0
ADD CH,1
CMP CH,10
JB loadsection


JMP 0xC200

loop:
HLT
JMP loop


information:
DB  0x0A,0x0A
DB  "Welcome to my computer!"
DB  0x0A,0x0A,0x00

loaderrorinformation:
DB  0x0A,0x0A
DB  "load error!"
DB  0x0A,0x0A

;启动区结束代码
RESB 0x7DFE-$
DB 0x55,0xAA