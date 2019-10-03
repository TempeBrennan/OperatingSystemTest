[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[File "helper.nas"]

		GLOBAL _hlt,_setGDTR,_setIDTR
[SECTION .text]

_hlt:	;void hlt(void);
		HLT
		RET

_setGDTR:	;void setGDTR(int size, int addr);
		MOV AX,[ESP+4]
		MOV [ESP+6],AX
		LGDT [ESP+6]
		RET

_setIDTR:	;void setIDTR(int size, int addr);
		MOV AX,[ESP+4]
		MOV [ESP+6],AX
		LIDT [ESP+6]
		RET		