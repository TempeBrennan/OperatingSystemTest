
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
[INSTRSET "i486p"]
LGDT [GDTR0]
MOV EAX,CR0
AND EAX,0x7FFFFFFF
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

MOV ESI,0x7C00
MOV EDI,0x00100000
MOV ECX,512/4
call copy

MOV ESI,0x8200
MOV EDI,0x00100200
MOV ECX,(512*10*18*2-512)/4
call copy

MOV ESI,bootpack
MOV EDI,0x00280000
MOV ECX,512*1024/4
call copy


;5. 跳转到bootpack并开始执行main方法
MOV EBX,bootpack
MOC ECX,[EBX+16]
ADD ECX,3
SHR ECX,2

JZ skip
MOV ESI,[EBX+20]
ADD ESI,EBX

MOV EDI,[EBX+12]
call copy

skip:
MOV ESP,[EBX+12]
JMP DWRD 2*8:0x0000001B

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
RESB 8
DW 0xFFFF,0x0000,0x9200,0x00CF
   0xFFFF,0x0000,0x9A28,0x0047
DW 0

GTR0:
DW 8*3-1
DD GDT0
ALIGNB 16

bootpack: