[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[File "helper.nas"]

		GLOBAL _hlt,_setGDTR,_setIDTR,_setDataToPort,_getDataFromPort
		GLOBAL _cli,_sti,_int21Handler,_int27Handler,_int2cHandler
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

_setDataToPort:	;void setDataToPort(short port, char data);
		MOV DX,[ESP+4]
		MOV AL,[ESP+6]
		OUT DX,AL
		RET

_getDataFromPort:	;void getDataFromPort(short port);
		MOV DX,[ESP+4]
		MOV AL,0
		IN AL,DX
		RET

_cli:	;void cli(void);
		CLI
		RET

_sti:	;void sti(void);
		STI
		RET

_int21Handler:	;void int21Handler(void);
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_int27Handler:	;void int27Handler(void);
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_int2cHandler:	;void int2cHandler(void);
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD