
;���û���ģʽ�� 320px*200px
MOV AH,0x00
MOV AL,0x13
INT 0x10

;1. �ر������ж�
MOV AL,0xFF
OUT 0x21,AL
NOP
OUT 0xA1,AL
CLI

;2. ����CPUʹ�õ��ڴ�ռ�
CALL wait
MOV AL,0xD1
OUT 0x64,AL
CALL wait
MOV AL,0xDF
OUT 0x60,AL
CALL wait

wait:
IN AL,0x64
AND AL,0x02
IN AL,0x60
JNZ wait
RET