
;设置画面模式是 320px*200px
MOV AH,0x00
MOV AL,0x13
INT 0x10

;1. 关闭所有中断
MOV AL,0xFF
OUT 0x21,AL
NOP
OUT 0xA1,AL
CLI

;2. 扩大CPU使用的内存空间
CALL wait
MOV AL,0xD1
OUT 0x64,AL
CALL wait
MOV AL,0xDF
OUT 0x60,AL
CALL wait



;3. 进入保护模式，并初始化寄存器
[instrset "i486p"]
LGDT [GDTR0]
MOV EAX,CR0
AND EAX,0x7eFFFFFF
OR EAX,0x00000001
MOV CR0,EAX
JMP init

init:
MOV AX,1*8
MOV DS,AX
MOV ES,AX
MOV FS,AX
MOV GS,AX
MOV SS,AX

;4. 程序拷贝


copy:
MOV EAX,[ESI]
ADD ESI,4
MOV [EDI],EAX
ADD EDI,4
SUB ECX,1
JNZ copy
RET

wait:
IN AL,0x64
AND AL,0x02
IN AL,0x60
JNZ wait
RET

ALIGNB 16
GDT0:
RESB 16
DW 0XFFFF,0X0000,0X9200,0X00CF
   0XFFFF,0X0000,0X9A28,0X0047
DW 0

GTR0:
DW 8*3-1
DD GDT0
ALIGNB 16

bootpack: