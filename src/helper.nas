[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[File "helper.nas"]

		GLOBAL _hlt,_setGDTR,_setIDTR,_setDataToPort,_getDataFromPort
		GLOBAL _cli,_sti,_int21Handler,_int27Handler,_int2cHandler
		EXTERN _mouseHandler,_keyboardHandler,_int27handler
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

_setDataToPort:	;void setDataToPort(int port, int data);
		MOV EDX,[ESP+4]
		MOV AL,[ESP+8]
		OUT DX,AL
		RET

_getDataFromPort:	;void getDataFromPort(int port);
		MOV EDX,[ESP+4]
		MOV EAX,0
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
		CALL	_keyboardHandler
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
		CALL	_int27handler
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
		CALL	_mouseHandler
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD