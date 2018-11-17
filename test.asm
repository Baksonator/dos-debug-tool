;pomocni program za testiranje TSR-a

org 100h
segment .code

_main:
	;mov cx, 1000
	 mov ax, 15
	  mov bx, 16
	  mov cx, 17
	  mov dx, 18
	  mov si, 19
	  mov di, 20
	  push ax
	  push bx
	  push cx
	  push dx
	  push si
	  push di
	  mov cx, 1000

_print:
      ;push ax
	  mov ah, 1
	  int 60h
	  loop _print
kraj:
      ;pop  ax
	  pop ax
	  pop ax
	  pop ax
	  pop ax
	  pop ax
	  pop ax
      ret          

; Brisanje sadrzaja ekrana
; --------------------------------------------

segment .data

porukica: db 'Baksone radi ti', 0