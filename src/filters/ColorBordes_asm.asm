extern ColorBordes_c
global ColorBordes_asm

%define pixel_size 4


section .rodata

_09:  dd 0.9, 0.9, 0.9,1.0
uno:  times 16 db 1.0
;mascara : dq 0x0000000100000000
ocho:   times 4 dd 8.0
unofin: times 1 dd 1.0
;mask: dw 1,2,1,0,1,2,1,0
;mask_filter_a: db 1,1,1,0,1,1,1,0
mask_filter_a: db 0xff,0xff,0xff,0x00,0xff,0xff,0xff,0x00




section .text


ColorBordes_asm:

;RDI -> *src
;RSI -> *dst
;EDX -> width
;ECX -> height
;R8D  -> src_row_size
;R9D  -> dst_row_size



;armo stackFrame
push rbp
mov rbp, rsp
sub rsp, 24
push r11
push r12  ;contador Height
push r13  ;contador width
push r14  ; ii
push r15  ; jj







add rsp, 24
pop r15
pop r14
pop r13
pop r12
pop r11
pop rbp
ret
