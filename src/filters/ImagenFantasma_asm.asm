extern ImagenFantasma_c
global ImagenFantasma_asm

%define pixel_size 4
%define d_pixel_size 8

.rodata:

;unob    : times 12 db 255.0
_09:  dd 0.9, 0.9, 0.9,1.0
uno:  times 16 db 1.0
;mascara : dq 0x0000000100000000
ocho:   times 4 dd 8.0
unofin: times 1 dd 1.0
;mask: dw 1,2,1,0,1,2,1,0
;mask_filter_a: db 1,1,1,0,1,1,1,0
mask_filter_a: db 0xff,0xff,0xff,0x00,0xff,0xff,0xff,0x00


.text:   

ImagenFantasma_asm:
;RDI -> *src
;RSI -> *dst
;EDX -> width
;ECX -> height
;R8D  -> src_row_size
;R9D  -> dst_row_size
;RBP + 16 -> offsetX    ;20 ver como acceder a la parte baja
;RBP + 24 -> offsety    ;28 ver



;armo stackFrame
push rbp
mov rbp, rsp
sub rsp, 40
push r11
push r12  ;contador Height
push r13  ;contador width
push r14  ; ii
push r15  ; jj

%define offsetX [rbp + 16]
%define offsetY [rbp + 24]

%define width [rsp + 8]
%define height [rsp + 16]

mov width, edx
mov height, ecx

xor r13,r13
.cicloHeight:
  xor r12, r12
  .cicloWidth:
    xor rdx, rdx
    xor ecx, ecx

    ;calculamos rr , gg , bb (para 4 pixeles)

    ;rsi + r12d * 4 + r13d * width * 4
    lea edx, [r13d * 4]
    mov eax, width
    mul edx                         ; eax <- width * r13d * 4
    lea eax, [eax + r12d * 4]
    xor r11, r11
    mov r11d, eax

    pmovzxbw xmm0, [rdi + r11]         ; xmm0 : [ aa_1 | rr_1 | gg_1 | bb_1 | aa_0 | rr_0 | gg_0 | bb_0 ]
    pmovzxbw xmm1, [rdi + r11 + 8]     ; xmm1 : [ aa_3 | rr_3 | gg_3 | bb_3 | aa_2 | rr_2 | gg_2 | bb_2 ]

    ; Calculamos ii y jj
    mov eax, r12d
    xor r11d, r11d
    mov r11d, 0x2
    cdq
    div r11d           ;devuelve en rax  
    add eax, offsetX
    mov r14d, eax   ;ii ancho offset
  

    mov eax, r13d
    cdq
    div r11d
    add eax, offsetY
    mov r15d, eax ;jj alto offset

    ; Guardamos en xmm3 y xmm4 los pixel para ghosting ponele rey (?

    lea edx,[ r15d * 4]            ; edx <-  jj * tamaño pixel
    mov rax, width
    mul edx                        ; eax <- (jj * 4) * width
    lea eax, [eax + r14d * 4]      ; eax <- eax + r14d * 4
    xor r11, r11
    mov r11d, eax


    pmovzxbw xmm2, [rdi + r11]                    ; xmm2 : (ghosting) [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
    pmovzxbw xmm3, [rdi + r11 + d_pixel_size]     ; xmm3 : (ghosting) [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]


    ;creamos B
    pxor xmm4, xmm4
    pblendw xmm2, xmm4, 0x88      ; xmm2 :  [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm12, xmm12
    pblendw xmm12, xmm2, 0x22     ; xmm12 : [   0  |   0  |    gg   |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm2, xmm12           ; xmm2 :  [   0  |   rg |   2gg  |   bg   |   0    |    rg    |   2gg   |   bg   ]

    pxor xmm4, xmm4
    pblendw xmm3, xmm4, 0x88      ; xmm2 :  [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm12, xmm12
    pblendw xmm12, xmm3, 0x22     ; xmm12 : [   0  |   0  |    gg   |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm3, xmm12             ; xmm3 :  [   0  |   rg |   2gg  |   bg   |   0    |    rg    |   2gg   |   bg   ]

; hasta aca todo oki :) ?

    phaddsw xmm2, xmm3   ; xmm2 : [(0+r)_3|(2g+b)_3|(0+r)_2 |(2g+b)_2|(0+r)_1 | (2g+b)_1 | (0+r)_0 | (b+2g)_0]
    xorps xmm5, xmm5
    phaddsw xmm2, xmm5   ; xmm5 : [   0   |    0   |    0   |    0   |   B3   |    B2    |    B1   |   B0   ]

; estos bx no estan divididos por cuatro, lo hacemos despues directo por 8
    movdqu xmm6, [ocho]
    pmovzxwd xmm7, xmm2 ; xmm7 : [      B3       |       B2      |      B1    |      B0    ]
    cvtdq2ps xmm7, xmm7 ; convierto int_32 a float
    divps xmm7, xmm6    ; xmm7 : [     B3/8      |      B2/8     |     B1/8   |     B0/8   ]
    ;cvtps2dq xmm7, xmm7 ; convierto float a int_32

    pmovzxwd xmm9, xmm0    ; xmm9  : [aa_ext | rr_ext | gg_ext | bb_ext ] (1er px)
    psrldq xmm0, 8
    pmovzxwd xmm10, xmm0   ; xmm10 : [aa_ext | rr_ext | gg_ext | bb_ext ] (2do px)

    pmovzxwd xmm11, xmm1   ; xmm11 : [aa_ext | rr_ext | gg_ext | bb_ext ] (3er px)
    psrldq xmm1, 8
    pmovzxwd xmm12, xmm1   ; xmm12 : [aa_ext | rr_ext | gg_ext | bb_ext ] (4do px)

    cvtdq2ps xmm9, xmm9   ; convierto int_32 a float
    cvtdq2ps xmm10, xmm10 ; convierto int_32 a float
    cvtdq2ps xmm11, xmm11 ; convierto int_32 a float
    cvtdq2ps xmm12, xmm12 ; convierto int_32 a float

    movdqu xmm6, [_09]
    mulps xmm9 , xmm6      ; xmm9  : [  aa * 1.0   |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ] px1
    movdqu xmm8, xmm7      ; copia xmm7
    shufps xmm8, xmm8, 0h  ; xmm8 :  [    b0      |      b0       |       b0      |      b0       ]
    psrldq xmm8, 4         ; xmm8 :  [    0       |      b0       |       b0      |      b0       ]
    addps xmm9, xmm8       ; xmm9  : [  aa + b0   |   rr*0.9 + b0 |   gg*0.9 + b0 |   bb*0.9 + b0 ] px1

    mulps xmm10, xmm6      ; xmm10 : [  aa * 1.0   |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ] px2
    movdqu xmm8, xmm7      ; copia xmm7
    shufps xmm8, xmm8, 55h  ; xmm8 : [    b1      |      b1       |       b1      |      b1       ]
    psrldq xmm8, 4         ; xmm8 :  [    0       |      b1       |       b1      |      b1       ]
    addps xmm10, xmm8       ; xmm10  : [  aa + b1  |   rr*0.9 + b1 |   gg*0.9 + b1 |   bb*0.9 + b1 ] px2

    mulps xmm11, xmm6      ; xmm11 : [  aa * 1.0   |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ] px3
    movdqu xmm8, xmm7      ; copia xmm7
    shufps xmm8, xmm8, 0xaa  ; xmm8 : [    b2      |      b2       |       b2      |      b2       ]
    psrldq xmm8, 4         ; xmm8 :  [    0       |      b2       |       b2      |      b2       ]
    addps xmm11, xmm8       ; xmm11  : [  aa + b2  |   rr*0.9 + b2 |   gg*0.9 + b2 |   bb*0.9 + b2 ] px3

    mulps xmm12, xmm6       ; xmm2  : [  aa * 1.0 |   rr * 0.9   |   gg * 0.9    |   bb * 0.9    ] px4
    movdqu xmm8, xmm7       ; copia xmm7
    shufps xmm8, xmm8, 0xff  ; xmm8 : [    b3     |      b3       |       b3      |      b3       ]
    psrldq xmm8, 4          ; xmm8 :  [    0     |      b3       |       b3      |      b3       ]
    addps xmm12, xmm8       ; xmm12 : [  aa + b3  |   rr*0.9 + b3 |   gg*0.9 + b3 |   bb*0.9 + b3 ] px4

    cvtps2dq xmm9, xmm9   ; convierto float a int_32
    cvtps2dq xmm10, xmm10 ; convierto float a int_32
    cvtps2dq xmm11, xmm11 ; convierto float a int_32
    cvtps2dq xmm12, xmm12 ; convierto float a int_32



    packssdw xmm9, xmm10
    packssdw xmm11, xmm12

    packuswb xmm9, xmm11   ; parece que empaqueta con signo

    movups [rsi], xmm9 ;movaps [rsi], xmm9
    add rsi, 16

    add r12d, 4
    cmp dword r12d, width
    jl .cicloWidth

  inc r13d
  cmp dword r13d, height
  jl .cicloHeight

    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop rbp
    ret

;gdb --args tp2 ImagenFantasma -i asm ../img/NottingHill.bmp 0 0

;b ImagenFantasma_asm.cicloHeight if $r13 == 0x2cf

;b ImagenFantasma_asm.cicloWidth if $r12 == 0x4fe

;
    ; mov [rsp+32], 0000
    ; movd [rsp+36], 00000000h
    ; movss [rsp+40], 3f800000h ; 1.0
    ; movd [rsp+44], 00000000h
    ; movss xmm6, [rsp+32]
;




; POR FAVOR VOLAR ESTO A LA RE GOMA CUANDO TERMINEMOS :D
; xorps xmm8, xmm8
; movdqu xmm8, [uno]       ;xmm8 : [   1   |    1   |    1   |    1   |    1   |    1    |    1    |    1    ]
; psrldq xmm8, 4           ;xmm8 : [  0  |   1    |    1   |    1    ]
; andps xmm0, xmm8         ;xmm0 : [  0  |rr * 0.9|gg * 0.9|bb * 0.9 ]
; andnps xmm9, xmm8        ;xmm9 : [ aa  |    0   |    0   |    0    ]
; orps xmm0, xmm9          ;xmm0 : [ aa  |rr * 0.9|gg * 0.9|bb * 0.9 ]
; andps xmm1, xmm8         ;xmm1 : [  0  |rr * 0.9|gg * 0.9|bb * 0.9 ]
; andnps xmm10, xmm8       ;xmm10: [ aa  |    0   |    0   |    0    ]
; orps xmm1, xmm10         ;xmm1 : [ aa  |rr * 0.9|gg * 0.9|bb * 0.9 ]

; COMO NO SE NOS OCURRIÓ, HICIMOS CABEZEADAS
; cabezeada1: times 4 dd [xmm3 + 96]
; ;cabezeada1: times 16 dd [xmm3 + 96]
; movdqu xmm6, [cabezeada1]
; movd  [xmm6 + 0], 0                   ; ver si xmm6 va con corchetes
; addps xmm0, xmm6
; cabezeada2: times 4 dd [xmm3 + 64]
; ;cabezeada2: times 16 dd [xmm3 + 64]
; movdqu xmm6, [cabezeada2]
; movd  [xmm6 + 0], 0                   ; ver si xmm6 va con corchetes
; addps xmm1, xmm6





;links utiles:

;https://cs.famaf.unc.edu.ar/~nicolasw/Docencia/CP/3-simdops.html#slide27





; Te hacemos una consulta,






;
