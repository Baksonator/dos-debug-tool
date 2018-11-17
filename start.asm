;start funkcija

segment .code

start_funk:
		mov ah, 34h
		int 21h
		mov [flag_segment], es					;cuvanje adrese InDos flag
		mov [flag_offset], bx
		mov byte [funcID], 0
		mov cx, 0ffh
petlja_start:									;komanda start, proverava postoji li TSR
		mov ah, cl
		push cx
		mov al, 0
		int 2fh
		pop cx
		cmp al, 0
		je dalje_start
		mov si, string_id
		mov bl, 0
		call uporedi
		cmp bl, 0
		je postoji_start						;TSR postoji 
dalje_start:
		mov [funcID], cl
		loop petlja_start
		jmp ne_postoji_start					;TSR ne postoji, mora da se instalira 
		
ne_postoji_start:								;instaliramo TSR
		cmp byte [funcID], 0
		jne _instalacija_TSR
		mov si, poruka_ne_moze
		call _print
		ret
	
postoji_start:
		mov si, poruka_postoji
		call _print
		ret

_instalacija_TSR:
		call _novi_2fh
		call _novi_60h
		call _novi_1ch
		mov si, poruka_instalirano
		call _print
		mov ah, 1								;pocetni ispis
		int 60h
		mov ah, 31h								;TSR prekid
		mov dx, 00ffh
		int 21h
		
_novi_2fh:										;instalacija 2fh
		cli
		xor ax, ax
		mov es, ax
		mov bx, [es:2fh*4]
		mov [old_int_off], bx 
		mov bx, [es:2fh*4+2]
		mov [old_int_seg], bx
		
		mov bx, moj_2fh
		mov [es:2fh*4], bx
		mov ax, cs
		mov [es:2fh*4+2], ax
		sti         
		ret
	
_stari_2fh:										;deinstalacija 2fh
		pusha
		cli
		xor ax, ax
		mov gs, ax
		mov ax, [es:old_int_seg]
		mov [gs:2fh*4+2], ax
		mov dx, [es:old_int_off]
		mov [gs:2fh*4], dx
		sti
		popa
		ret
	
moj_2fh:
		cmp ah, [cs:funcID]						;da li je poziv za nas funcID
		je to_je_to
		jmp zavrsi_2fh
		
to_je_to:
		cmp al, 0								;da li je provera postojanja
		jne zavrsi_2fh
		mov al, 0ffh							;znak da smo tu
		push cs									;cuvanje segmenta
		pop es
		mov di, string_id
		iret
		
	
zavrsi_2fh:
		push word [cs:old_int_seg]				;predajemo kontrolu dalje
		push word [cs:old_int_off]
		
		retf
	
_novi_60h:										;instalacija 60h
		cli
		xor ax, ax
		mov es, ax
		mov bx, [es:60h*4]
		mov [old_int_off_60], bx 
		mov bx, [es:60h*4+2]
		mov [old_int_seg_60], bx
		
		mov bx, moj_60h
		mov [es:60h*4], bx
		mov ax, cs
		mov [es:60h*4+2], ax
		sti         
		ret
		
_stari_60h:										;deinstalacija 60h
		pusha
		cli
		xor ax, ax
		mov gs, ax
		mov ax, [es:old_int_seg_60]
		mov [gs:60h*4+2], ax
		mov dx, [es:old_int_off_60]
		mov [gs:60h*4], dx
		sti
		popa
		ret
	
moj_60h:
		pusha		
		cli
		push cs
		push ds
		pop gs
		pop ds
		push es
		push bx
		push ax
		mov es, [flag_segment]					;da li je dos zauzet
		mov bx, [flag_offset]
		mov byte al, [es:bx]
		cmp al, 0
		jne ne_moze_sad							;ako jeste, nista se ne desava
		dec bx
		mov byte al, [es:bx]
		cmp al, 0
		jne ne_moze_sad
		sti
		pop ax
		pop bx
		pop es
		cmp ah, 0								;ako nije, radi normlano
		je ispis_registri
		cmp ah, 1
		je ispis_stek
zavrsi_60h:						
		push gs									;vrati ds na staru vrednost
		pop ds
		popa
		iret

ne_moze_sad:									;dos je aktivan
		sti
		pop ax
		pop bx
		pop es
		push si									;provera
		mov si, pomoc							;da li
		call _print								;je
		pop si									;tu
		mov byte [funkcija_60h], ah				;zapamti koji je bio argument funkcije
		mov byte [flag_dos], 1					;stavi "podsetnik" da se treba vratiti
		jmp zavrsi_60h
		
_novi_1ch:										;instalacija 1ch
		cli
		xor ax, ax
		mov es, ax
		mov bx, [es:1Ch*4]
		mov [old_int_off_1c], bx 
		mov bx, [es:1Ch*4+2]
		mov [old_int_seg_1c], bx
		
		mov dx, moj_1ch
		mov [es:1Ch*4], dx
		mov ax, cs
		mov [es:1Ch*4+2], ax	
		sti         
		ret
		
_stari_1ch:										;deinstalacija 1ch
		cli
		xor ax, ax
		mov gs, ax
		mov ax, [es:old_int_seg_1c]
		mov [gs:1Ch*4+2], ax
		mov dx, [es:old_int_off_1c]
		mov [gs:1Ch*4], dx
		sti
		ret

moj_1ch:
		pusha									;proverava dal moze sad
		push cs
		push ds
		pop gs
		pop ds
		mov byte al, [flag_dos]					;da li je setovan "podsetnik"
		cmp al, 0
		je zavrsi_1ch							;ako nije, kraj
		cli
		push es
		push bx
		push ax
		mov es, [flag_segment]			
		mov bx, [flag_offset]
		mov al, [es:bx]							;da li je dos zauzet
		cmp al, 0
		jne zavrsi_1ch							;ako jeste, vrati se kasnije
		dec bx
		mov al, [es:bx]							;critErr flag
		cmp al, 0
		jne zavrsi_1ch							;ako je 1, vrati se kasnije
		sti
		pop ax 
		pop bx
		pop es
		mov byte [flag_dos], 0					;ako si stigao ovde, radi se 60h, clearuje se "podsetnik"
		mov byte ah, [funkcija_60h]
		cmp ah, 0								
		je ispis_registri
		cmp ah, 1
		je ispis_stek
		
zavrsi_1ch:					
		sti
		push gs									;vrati ds na staru vrednost
		pop ds
		popa
		iret
		
segment .data

instaliran_fleg: db 0
poruka_ne_moze: db 'Ima previse TSR, ne moze', 0
old_int_seg: dw 0
old_int_off: dw 0
old_int_seg_60: dw 0
old_int_off_60: dw 0
poruka_instalirano: db 'TSR uspesno instaliran', 0
pomoc: db 'Tu sam, reentrancy se desio', 0
flag_dos: db 0
flag_segment: dw 0
flag_offset: dw 0
old_int_seg_1c: dw 0
old_int_off_1c: dw 0
funkcija_60h: db 0