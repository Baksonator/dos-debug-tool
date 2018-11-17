;stop funkcija
segment .code

stop_funk:
		pusha
		mov cx, 0ffh
petlja_stop:										;provera se da li je TSR tu
		mov ah, cl
		push cx
		mov al, 0
		int 2fh
		pop cx
		cmp al, 0
		je dalje_stop
		mov si, string_id
		mov bl, 0
		call uporedi
		cmp bl, 0
		je postoji_stop
dalje_stop:
		loop petlja_stop
		jmp ne_postoji_stop
		
ne_postoji_stop:
		mov si, poruka_ne_postoji
		call _print
		popa
		ret
		
postoji_stop:
		call _proveri_uklanjanje
		cmp bl, 0
		jne ukloni
		mov si, poruka_ne_moze_uklanjanje
		call _print
		popa
		ret
		
_proveri_uklanjanje:								;vratice 1 u bl ako se moze ukloniti
		push es
		xor ax, ax
		mov es, ax
		mov ax, moj_2fh								;proveram da li je moj int prvi u nizu, ako nije, ne moze se ukloniti
		cmp ax, [es:2fh*4]
		jne _ne_moze_uklanjanje
		pop es
		mov ax, es
		push es
		xor bx, bx
		mov es, bx
		cmp ax, [es:2fh*4+2]
		jne _ne_moze_uklanjanje
		
		mov ax, moj_60h
		cmp ax, [es:60h*4]
		jne _ne_moze_uklanjanje
		pop es
		mov ax, es
		push es
		xor bx, bx
		mov es, bx
		cmp ax, [es:60h*4+2]
		jne _ne_moze_uklanjanje
		
		mov ax, moj_1ch
		cmp ax, [es:1ch*4]
		jne _ne_moze_uklanjanje
		pop es
		mov ax, es
		push es
		xor bx, bx
		mov es, bx
		cmp ax, [es:1ch*4+2]
		jne _ne_moze_uklanjanje
		
_moze_uklanjanje:
		mov bl, 1
		pop es
		ret

_ne_moze_uklanjanje:
		mov bl, 0
		pop es
		ret	
		
ukloni:
		call _stari_60h
		call _stari_2fh
		call _stari_1ch
		push es
		mov es, [es:2ch]									;uklanjanje iz memorije
		mov ah, 49h
		int 21h
	
		pop es
		mov ah, 49h
		int 21h
		mov si, uspesno_uklanjanje
		call _print
		popa
		ret

segment .data

poruka_ne_postoji: db 'TSR ne postoji', 0
poruka_ne_moze_uklanjanje: db 'TSR se ne moze trenutno ukloniti', 0
uspesno_uklanjanje: db 'TSR uklonjen', 0