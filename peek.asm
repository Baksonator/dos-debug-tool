;peek funkcija

segment .code

peek_start:
		add si, 4
		mov cx, 4
		mov bh, 0
petlja_peek:
		mov bl, [si]
		cmp bl, 97
		jge malo_slovo
		cmp bl, 65
		jge veliko_slovo
		sub bl, 48
		push bx
		inc si
		loop petlja_peek
		jmp nastavi_br_peek
malo_slovo:
		sub bl, 87
		push bx
		inc si
		loop petlja_peek
		jmp nastavi_br_peek
		
veliko_slovo:
		sub bl, 55
		push bx
		inc si
		loop petlja_peek
		jmp nastavi_br_peek
		
nastavi_br_peek:
		pop bx
		
		
		pop ax
		shl ax, 4
		add bx, ax
		
		pop ax
		shl ax, 8
		add bx, ax
		
		pop ax
		shl ax, 12
		add bx, ax
		
		push bx											;na steku je segment
		
		inc si
		mov cx, 4
		mov bh, 0
		
petlja_peek_2:
		mov bl, [si]
		cmp bl, 97
		jge malo_slovo_2
		cmp bl, 65
		jge veliko_slovo_2
		sub bl, 48
		push bx
		inc si
		loop petlja_peek_2
		jmp nastavi_br_peek_2
		
malo_slovo_2:
		sub bl, 87
		push bx
		inc si
		loop petlja_peek_2
		jmp nastavi_br_peek_2
		
veliko_slovo_2:
		sub bl, 55
		push bx
		inc si
		loop petlja_peek_2
		jmp nastavi_br_peek_2

nastavi_br_peek_2:
		pop bx
	
		pop ax
		shl ax, 4
		add bx, ax
		
		pop ax
		shl ax, 8
		add bx, ax
		
		pop ax
		shl ax, 12
		add bx, ax
		
		push bx											;na steku je ofset
peek_funk:
		mov cx, 0ffh
peltlja_funk:											;provera da li je TSR instaliran
		mov ah, cl
		push cx
		mov al, 0
		int 2fh
		pop cx
		cmp al, 0
		je dalje_peek
		mov si, string_id
		mov bl, 0
		call uporedi
		cmp bl, 0
		je postoji_peek
		
dalje_peek:
		loop peltlja_funk
		jmp ne_postoji_peek

ne_postoji_peek:
		pop ax
		pop ax
		mov si, poruka_ne_postoji
		call _print
		ret
		
postoji_peek:
		push es
		push ds
		pop gs
		pop ds
		jmp ispis_pozicije