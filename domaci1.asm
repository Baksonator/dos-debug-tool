;glavni program

org 100h
segment .code

main:
		cld
		mov cx, 80h						;ucitavanje argumenta komandne linije
		mov di, 81h
		mov al, ' '
		repe scasb	
		
		dec di							
		mov si, di						;si pokazuje na pocetak argumenta
		mov al, 0dh
		repne scasb
		
		inc si							;pokazuje na prvo slovo
		mov al, [si]					;proverava se prvo slovo
		inc si
		cmp al, 's'
		je slovo_s
		cmp al, 'p'
		je slovo_p
		jmp kraj
		
slovo_s:
		inc si
		mov al, [si]
		cmp al, 'o'						;stop funkcija
		je stop_funk
		cmp al, 'a'
		je start_funk					;start funkcija
		jmp kraj
		

slovo_p:
		mov al, [si]
		cmp al, 'e'
		je peek_start					;peek funkcija
		cmp al, 'o'
		je poke_start					;poke funkcija
		jmp kraj
	
	
uporedi:
		push ax							;poredi string_id, vraca u bl 0 ako su isti, 1 ako nisu
petlja_uporedi:
		mov byte al, [es:di]
		mov byte ah, [cs:si]
		cmp al, ah
		je dalje_poredi
		mov bl, 1
		jmp kraj_poredi
		
dalje_poredi:
		cmp al, 0
		je kraj_poredi
		inc di
		inc si
		jmp petlja_uporedi
	
kraj_poredi:
		pop ax
		ret

%include "start.asm"	
%include "stop.asm"	
%include "peek.asm"
%include "poke.asm"
%include "tsr.asm"
%include "ekran.asm"
	
segment .data

start_rec: db '-start', 0
stop_rec: db '-stop', 0
peek_rec: db '-peek', 0
poke_rec: db '-poke', 0
poruka_postoji: db 'TSR je vec instaliran', 0