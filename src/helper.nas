[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[File "helper.nas"]

		GLOBAL _hlt,_setGDTR,_setIDTR,_setDataToPort,_getDataFromPort
		GLOBAL _cli,_sti,_int21Handler,_int27Handler,_int2cHandler
		GLOBAL _getEFlags,_setEFlags,_getCR0,_setCR0,_getEndAvailableMemoryAddr
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

_getDataFromPort:	;int getDataFromPort(int port);
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

_getEFlags:		;int getEFlags(void);
		PUSHFD
		POP EAX
		RET

_setEFlags:		;void setEFlags(int eflags);
		MOV EAX,[ESP+4]
		PUSH EAX
		POPFD
		RET

_getCR0:		;int getCR0(void);
		MOV EAX,CR0
		RET

_setCR0:		;void setCR0(int data);
		MOV EAX,[ESP+4]
		MOV CR0,EAX
		RET

_getEndAvailableMemoryAddr:		;unsigned int getEndAvailableMemoryAddr(unsigned int startAddr, unsigned int endAddr);
		PUSH EDI
		PUSH ESI
		PUSH EBX
		MOV ESI, 0xAA55AA55
		MOV EDI, 0x55AA55AA
		MOV EAX,[ESP+12+4]
check:
		MOV EBX,EAX
		ADD EBX,0xFFC
		MOV EDX, [EBX]
		MOV [EBX], ESI
		XOR DWORD [EBX], 0xFFFFFFFF
		CMP [EBX], EDI
		JNE end
		XOR DWORD [EBX], 0xFFFFFFFF
		CMP [EBX], ESI
		JNE end
		MOV [EBX], EDX
		ADD EAX, 0x1000
		CMP EAX, [ESP+12+8]
		JBE check
		POP EBX
		POP ESI
		POP EDI
		RET
end:
		MOV [EBX], EDX
		POP EBX
		POP ESI
		POP EDI
		RET

