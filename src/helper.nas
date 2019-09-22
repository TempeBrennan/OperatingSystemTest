[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[File "helper.nas"]

		GLOBAL _hlt
[SECTION .text]

_hlt:	;void hlt(void);
		HLT
		RET