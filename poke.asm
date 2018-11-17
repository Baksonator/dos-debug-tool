;poke funkcija

segment .code

poke_start:
		add si, 4
		mov cx, 4
		mov bh, 0
petlja_start_poke:								;ucitavanje broja, guranje na stek
		mov bl, [si]
		cmp bl, 97
		jge malo_slovo_3
		cmp bl, 65
		jge veliko_slovo_3
		sub bl, 48
		push bx
		inc si
		loop petlja_start_poke
		jmp nastavi_br_poke

malo_slovo_3:
		sub bl, 87
		push bx
		inc si
		loop petlja_start_poke
		jmp nastavi_br_poke
		
veliko_slovo_3:
		sub bl, 55
		push bx
		inc si
		loop petlja_start_poke
		jmp nastavi_br_poke
		
nastavi_br_poke:
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
		
		push bx									;na steku je segment
		
		inc si
		mov cx, 4
		mov bh, 0
		
petlja_start_poke_2:							;ucitavanje broja, guranje na stek
		mov bl, [si]
		cmp bl, 97
		jge malo_slovo_4
		cmp bl, 65
		jge veliko_slovo_4
		sub bl, 48
		push bx
		inc si
		loop petlja_start_poke_2
		jmp nastavi_br_poke_2

malo_slovo_4:
		sub bl, 87
		push bx
		inc si
		loop petlja_start_poke_2
		jmp nastavi_br_poke_2
		
veliko_slovo_4:
		sub bl, 55
		push bx
		inc si
		loop petlja_start_poke_2
		jmp nastavi_br_poke_2

nastavi_br_poke_2:
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
		
		push bx									;na steku je ofset
		
		inc si
		mov cx, 2
		mov bh, 0
		
petlja_start_poke_3:							;ucitavanje broja, guranje na stek
		mov bl, [si]
		cmp bl, 97
		jge malo_slovo_5
		cmp bl, 65
		jge veliko_slovo_5
		sub bl, 48
		push bx
		inc si
		loop petlja_start_poke_3
		jmp nastavi_br_poke_3

malo_slovo_5:
		sub bl, 87
		push bx
		inc si
		loop petlja_start_poke_3
		jmp nastavi_br_poke_3
		
veliko_slovo_5:
		sub bl, 55
		push bx
		inc si
		loop petlja_start_poke_3
		jmp nastavi_br_poke_3
		
nastavi_br_poke_3:
		pop bx
	
		pop ax
		shl ax, 4
		add bx, ax
		
		push bx									;na steku je bajt za upisivanje
		
poke_funk:
		mov cx, 0ffh							;provera da li postji TSR
petlja_poke:
		mov ah, cl
		push cx
		mov al, 0
		int 2fh
		pop cx
		cmp al, 0
		je dalje_poke
		mov si, string_id
		mov bl, 0
		call uporedi
		cmp bl, 0
		je postoji_poke
		
dalje_poke:
		loop petlja_poke
		jmp ne_postoji_poke
		
ne_postoji_poke:								;na steku su tri stvari, skinuti ih "u prazno"
		pop ax
		pop ax
		pop ax
		mov si, poruka_ne_postoji
		call _print
		ret
		
postoji_poke:
		pop ax
		pop bx
		pop es
		mov byte [es:bx], al					;upis na lokaciju u memoriji
		ret