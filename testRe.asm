;pomocni program za pokusaj testiranja reentrancy

org 100h
segment .code

main:
	 call _novi_1C
	 mov si, poruka
	 call _print
	 mov ah, 31h								;TSR prekid
	 mov dx, 00ffh
	 int 21h
		
_novi_1C:
	cli
	xor ax, ax
	mov es, ax
	mov bx, [es:1Ch*4]
	mov [old_int_off], bx 
	mov bx, [es:1Ch*4+2]
	mov [old_int_seg], bx
	
	mov dx, timer_int
	mov [es:1Ch*4], dx
	mov ax, cs
	mov [es:1Ch*4+2], ax
	;push ds		
	;pop gs		
	sti         
	ret
	
timer_int:
	pusha
	push cs
	pop ds
; Obrada tajmerskog prekida 
	mov ah, 2ch
	int 21h	
	popa
	push word [cs:old_int_seg]
	push word [cs:old_int_off]
	;push si
	;mov si, poruka
	;call _print
	;pop si
	;iret
	retf
	
%include "ekran.asm"	

segment .data

old_int_seg: dw 0
old_int_off: dw 0
poruka: db 'Tu sam', 0