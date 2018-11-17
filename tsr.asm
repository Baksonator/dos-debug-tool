;tsr program

;org 100h
segment .code

BOJA equ 2fh
DVE_TACKE equ 3ah
SLOVO_H equ 68h

poz:		
		push ax
		mov al, 0						;otvaranje fajla
		mov ah, 3dh
		mov dx, ulazni
		int 21h
		
		mov bx, ax						;citanje iz fajla
		mov cx, 10
		mov ah, 3fh
		mov dx, podaci
		int 21h
		
		mov ah, 3eh						;zatvaranje fajla
		int 21h
		
		mov si, dx						;prva cifra, prvi broj
		mov ax, [si]
		inc si
		sub ax, 30h
		mov dl, 10
		mul dl
		
		mov bx, [si]					;druga cifra, prvi broj
		sub bx, 30h
		add ax, bx
		add si, 3
		
		mov [kolona], ax				;broj kolone
		
		mov bx, [si]					;prva cifra, drugi broj
		inc si
		mov ax, bx
		sub ax, 30h
		mov dl, 10
		mul dl
		
		mov bx, [si]					;druga cifra, drugi broj
		sub bx, 30h
		add ax, bx
		
		mov [red], ax					;broj reda
		
		mov cx, 0b800h
		mov es, cx
		
		mov bx, 160						;odredjivanje pozicije
		mov ax, [red]
		mul bx
		mov bx, ax
		mov ax, [kolona]
		mov dl, 2
		mul dl
		add bx, ax						;startna pozicija
		mov [startna_pozicija], bx
		pop ax
		ret
		
ispis_vreme:
		call poz
		mov ah, 2ch						;vreme
		int 21h
		
		mov ah, 0						;dobijamo cifre za sekunde
		mov al, dh
		mov bl, 10
		div bl
		
		push ax
		
		mov ah, 0						;dobijamo cifre za minute
		mov al, cl
		div bl
		
		push ax
		
		mov ah, 0						;dobijamo cifre za sate
		mov al, ch
		div bl
		
		add ah, 30h						;pretvaramo u odg karaktere
		add al, 30h
		
		mov bx, [startna_pozicija]
		mov byte [es:bx], al			;ispisa sati i dvotacke
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], ah
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], DVE_TACKE
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		
		pop ax							
		add ah, 30h						
		add al, 30h
		
		mov byte [es:bx], al			;ispis minuta i dvotacke
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], ah
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], DVE_TACKE
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		
		pop ax							
		add ah, 30h						
		add al, 30h
		
		mov byte [es:bx], al			;ispis sekundi
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], ah
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		
		mov byte [es:bx], 20h			;prazno mesto, lepse je
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		ret
	
ispis_registri:	
		pusha
		push di							;sve registre na stek, za ispis
		push si							;treba srediti, gurati ih odma na pocetku
		push dx
		push cx
		push bx
		push ax
		call ispis_vreme
		mov bx, [startna_pozicija] 		;ispis kljucne reci
		add bx, 160						;novi red
		mov si, rec_registri
		call _printovanje
		
		mov bx, [startna_pozicija]		;krecemo ispis registara
		add bx, 320						;ax
		mov si, rec_ax
		call _printovanje
		pop cx
		call _print_registar			;ax
		
		mov bx, [startna_pozicija]
		add bx, 480
		mov si, rec_bx
		call _printovanje
		pop cx
		call _print_registar			;bx
		
		mov bx, [startna_pozicija]
		add bx, 640
		mov si, rec_cx
		call _printovanje
		pop cx
		call _print_registar			;cx
		
		mov bx, [startna_pozicija]
		add bx, 800
		mov si, rec_dx
		call _printovanje
		pop cx
		call _print_registar			;dx
		
		mov bx, [startna_pozicija]
		add bx, 960
		mov si, rec_si
		call _printovanje
		pop cx
		call _print_registar			;si
		
		mov bx, [startna_pozicija]
		add bx, 1120
		mov si, rec_di
		call _printovanje
		pop cx
		call _print_registar			;di
		
		popa
		jmp zavrsi_60h
	
ispis_stek:
		call ispis_vreme
		mov bx, [startna_pozicija]
		add bx, 160
		mov si, rec_stek				;ispis kljucne reci
		call _printovanje
		
		mov bx, [startna_pozicija]
		add bx, 320
		mov si, rec_1
		call _printovanje
		mov ecx, [esp+22]					;prvi na steku
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 480
		mov si, rec_2
		call _printovanje
		mov ecx, [esp+24]					;drugi na steku
		call _print_registar		
		
		mov bx, [startna_pozicija]
		add bx, 640
		mov si, rec_3
		call _printovanje
		mov ecx, [esp+26]					;treci na steku
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 800
		mov si, rec_4
		call _printovanje
		mov ecx, [esp+28]					;cetvrti na steku
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 960
		mov si, rec_5
		call _printovanje
		mov ecx, [esp+30]					;peti na steku
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 1120
		mov si, rec_6
		call _printovanje
		mov ecx, [esp+32]					;sesti na steku
		call _print_registar
		
		jmp zavrsi_60h
	
ispis_pozicije:
		pop dx
		pop ax
		push ax
		push dx
		call poz
		
		mov bx, [startna_pozicija]
		add bx, 1280
		mov si, rec_seg					;segment adrese
		call _printovanje
		mov cx, ax
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 1440
		mov si, rec_off					;ofset adrese
		call _printovanje
		pop dx
		push dx
		mov cx, dx
		call _print_registar
		
		mov bx, [startna_pozicija]
		add bx, 1600
		mov si, rec_val
		call _printovanje
		pop dx
		pop ax
		push bx
		mov bx, dx
		mov es, ax
		mov byte cl, [es:bx]			;bajt na zeljenoj memorijskoj lokaciji
		mov dx, 0b800h
		mov es, dx
		pop bx
		call _print_memorija
		
		push gs
		pop ds
		ret
	
kraj:
		ret
	
_print_memorija:
		mov ax, cx
		and ax, 00f0h
		shr ax, 4
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov ax, cx
		and ax, 000fh
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], SLOVO_H		;malo slovo h
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		ret
	
_print_registar:						;namestena je ispravna pozicija, ispisuje se ceo registar iz cx
		mov ax, cx
		and ax, 0f000h					;uzimam prvu hex cifru
		shr ax, 12						;pomeram na al
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov ax, cx
		and ax, 0f00h					;uzimam drugu hex cifru
		shr ax, 8						;pomeram u al
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov ax, cx
		and ax, 00f0h					;treca hex cifra
		shr ax, 4						;pomeram u al
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov ax, cx						
		and ax, 000fh					;poslednja cifra
		call dec_to_hex
		mov byte [es:bx], dl
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		mov byte [es:bx], SLOVO_H		;malo slovo h
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		ret
		
		
dec_to_hex:								;u al je broj koji se pretvara, u dx pretvoren, i to u karakter
		cmp al, 10
		jge vecejednako
		mov dx, ax
		add dx, 30h
		ret
		
vecejednako:
		mov dx, ax
		add dx, 55
		ret
		
		
_printovanje:							;funkcija za ispisivanje u video memoriju
		cld
		push ax
.loop:
		lodsb
		or al, al
		jz .loop_kraj
		mov byte [es:bx], al
		inc bx
		mov byte [es:bx], BOJA
		inc bx
		jmp .loop
		
.loop_kraj:
		pop ax
		ret
		
segment .data

ulazni: db 'C:\poz.txt', 0				;fajl za ucitavanje
podaci: resb 10							;podaci iz fajla
red: dw 0								;broj reda
kolona: dw 0							;broj kolone
startna_pozicija: dw 0					;pozicija za upis
rec_registri: db 'Registri:', 0			;pomocne reci za upis
rec_ax: db 'ax: ', 0
rec_bx: db 'bx: ', 0
rec_cx: db 'cx: ', 0
rec_dx: db 'dx: ', 0
rec_si: db 'si: ', 0
rec_di: db 'di: ', 0
rec_stek: db 'Stek:    ', 0
rec_1: db '1:  ', 0
rec_2: db '2:  ', 0
rec_3: db '3:  ', 0
rec_4: db '4:  ', 0
rec_5: db '5:  ', 0
rec_6: db '6:  ', 0
rec_seg: db 'seg:', 0
rec_off: db 'off:', 0
rec_val: db 'val:  ', 0
my_seg: dw 0
string_id: db 'Bakijev hendler', 0
funcID: db 0