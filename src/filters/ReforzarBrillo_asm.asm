extern ReforzarBrillo_c
global ReforzarBrillo_asm


section .rodata

cuatro:   times 4 dd 4.0
; maskBSup: times 16 db brilloSup 
; maskBInf: times 16 db brilloInf

mask_levantar_a: db 0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255

;mask_blend: db 0,0,0,0,0,0,0,0,0,0,0,0,255,0,0,0
mask_blend: db 0,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0

regMayor: times 16 db 50
regMenor: times 16 db 50


section .text

ReforzarBrillo_asm:

;RDI       -> *src
;RSI       -> *dst
;EDX       -> width
;ECX       -> height
;R8D       -> src_row_size
;R9D       -> dst_row_size
;RBP + 16  -> umbralSup
;RBP + 24  -> umbralInf
;RBP + 30  -> brilloSup
;RBP + 38  -> brilloInf

push rbp
mov rbp, rsp
sub rsp, 56
push r11
push r12    ; j
push r13    ; i
push r14
push r15


%define umbralSup [rbp + 16]
%define umbralInf [rbp + 24]
%define brilloSup [rbp + 32]
%define brilloInf [rbp + 40]

%define width [rbp - 8]
%define height [rbp - 16]

mov width, edx
mov height, ecx

xor rdx, rdx
xor rcx,rcx

; regMayor: times 16 db brilloSup
; regMenor: times 16 db brilloInf

; Ponemos en todos los bytes de xmm11 y xmm2 el entero brilloSup y brilloInf respectivamente 
pxor xmm11, xmm11
pxor xmm12, xmm12
movss xmm11, brilloSup    
movss xmm12, brilloInf 
pshufd xmm11, xmm11, 0x00
pshufd xmm12, xmm12, 0x00 
packssdw xmm11, xmm11     
packuswb xmm11, xmm11     
packssdw xmm12, xmm12
packuswb xmm12, xmm12

xor r13,r13
.cicloHeight:           ; i

    xor r12, r12
    .cicloWidth:        ; j


    lea edx,[r13d * 4]            ; edx <-  jj * tamaño pixel
    mov eax, width
    mul edx                        ; eax <- (jj * 4) * width
    lea eax, [eax + r12d * 4]      ; eax <- eax + r14d * 4
    xor r11, r11
    mov r11d, eax

    pmovzxbw xmm2, [rdi + r11]           ; xmm2 :  [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
    pmovzxbw xmm3, [rdi + r11 + 8]       ; xmm3 :  [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]


  ;creamos B
    pxor xmm4, xmm4
    pblendw xmm2, xmm4, 0x88      ; xmm2  : [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm7, xmm7
    pblendw xmm7, xmm2, 0x22     ; xmm7 : [   0  |   0  |   gg  |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm2, xmm7             ; xmm2  : [   0  |   rg |  2gg  |   bg   |   0    |    rg    |   2gg   |   bg  ]

    ; hasta aca hacemos g*2 (en xmm2)

    pxor xmm4, xmm4
    pblendw xmm3, xmm4, 0x88      ; xmm2 :  [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm7, xmm7
    pblendw xmm7, xmm3, 0x22     ; xmm12 : [   0  |   0  |    gg   |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm3, xmm7             ; xmm3 :  [   0  |   rg |   2gg  |   bg   |   0    |    rg    |   2gg   |   bg   ]

    ; hasta aca hacemos g*2 (en xmm3)

    phaddsw xmm2, xmm3            ; xmm2 : [(0+r)_3|(2g+b)_3|(0+r)_2 |(2g+b)_2|(0+r)_1 | (2g+b)_1 | (0+r)_0 | (b+2g)_0]
    xorps xmm5, xmm5
    phaddsw xmm2, xmm5            ; xmm5 : [   0   |    0   |    0   |    0   |   B3   |    B2    |    B1   |   B0   ]


    pxor xmm4, xmm4
    movdqu xmm6, [cuatro]
    pmovzxwd xmm4, xmm2         ; xmm4 : [      B3       |       B2      |      B1    |      B0    ]
    cvtdq2ps xmm4, xmm4         ; convierto int_32 a float
    divps xmm4, xmm6            ; xmm4 : [     B3/4      |      B2/4     |     B1/4   |     B0/4   ]
    roundps xmm4, xmm4, 3 ; Redondeo a 0
    cvtps2dq xmm4, xmm4 ; convierto float a int_32
    

    pxor xmm2, xmm2
    pxor xmm3, xmm3
    pmovzxbw xmm2, [rdi + r11]           ; xmm2 :  [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
    pmovzxbw xmm3, [rdi + r11 + 8]       ; xmm3 :  [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]
    
    
    pxor xmm9,  xmm9    ;suma
    pxor xmm10, xmm10   ;resta
  
    movdqu xmm0, [mask_blend]
    xor r14, r14

    packuswb xmm2, xmm3

    .loop_:             ; armamos super mega mascara
      cmp r14d, 4
      je .fin1
      inc r14d
      cmp dword r14d, 1
      je .inicio
      pslldq xmm0, 4

      .inicio:
      extractps r15d, xmm4, 0x00   ; Colocamos en r15 el b_i que corresponde 
      psrldq xmm4, 4                  
    
      cmp dword r15d, umbralSup
      jg .mayor
       
      cmp dword r15d, umbralInf
      jl .menor
      
      jmp .loop_
    
      .mayor:
      blendvps xmm9, xmm11, xmm0    ; mayor  219,220
      jmp .loop_

      .menor:
      blendvps xmm10, xmm12, xmm0
      jmp .loop_

.fin1:

    paddusb xmm2, xmm9
    psubusb xmm2, xmm10 

    movdqu xmm13, [mask_levantar_a]
    paddusb xmm2, xmm13 ; levantamos la a , 
  
    movups [rsi], xmm2
    add rsi, 16

    add r12d, 4
    cmp dword r12d, width
    jl .cicloWidth

    inc r13d
    cmp dword r13d, height
    jl .cicloHeight


.fin:
pop r15
pop r14
pop r13
pop r12
pop r11
add rsp, 56
pop rbp
ret


    ;Vas shifteando y agarras los primeros como en el otro shifteo







  ;    movdqu xmm8, [rdi] ; xmm8: [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 | a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]


  ;   xor r14, r14 ;contador que va a chequear que hicimos la comparacion con los 4 pixeles
  ;   .comparacion: ;vamos a iterar 4 veces para comparar las b de los 4 pixeles
      
  ;     ; xmm4 : [     B3/4      |      B2/4     |     B1/4   |     B0/4   ]
      
  ;     xor r15, r15
  ;     extractps r15, xmm4, 0x00   ; Colocamos en r15 el b_i que corresponde 
  ;     psrldq xmm4, 4
  ;     extractps r11, xmm8, 0x00   ; Colocamos en r11 el pixel que corresponde
  ;     psrldq xmm8, 4
  ;     cmp dword r15d, umbralSup
  ;     jg .sumaSat
  ;     cmp dword r15d, umbralInf
  ;     jl .restaSat
  ;     .finComparacion:
  ;     inc r14
  ;     cmp dword r14d, 3
  ;     jne .comparacion

    

; ;APARTE:
;   .sumaSat:
;     ; xor xmm9, xmm9
;     ; xor xmm10, xmm10
;     ; movdqu xmm10, [brilloSup]
;     ; movdqu xmm9, r11
;     ; paddsb xmm9, xmm10
;     ; jmp .finComparacion

;   .restaSat:
;     ; xor xmm9, xmm9
;     ; xor xmm10, xmm10
;     ; movdqu xmm10, [brilloInf]
;     ; movdqu xmm9, r11
;     ; psubsb xmm9, xmm10
;     ; jmp .finComparacion




;   ;reforzarBrillo:
;     pxor xmm2, xmm2
;     pxor xmm3, xmm3
;     pxor xmm5, xmm5
;     pxor xmm6, xmm6
;     pmovzxbw xmm2, [rdi + r11]       ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
;     pmovzxbw xmm3, [rdi + r11 + 8]   ; xmm3 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]
;     pmovzxwd xmm6, xmm2              ; xmm6 : [    a_0    |     r_0   |     g_0   |    b_0    ]
;     psrldq xmm2, 8                   ;shift a la derecha x 4 words del xmm2
;     pmovzxwd xmm2, xmm2              ; xmm2 : [    a_1    |     r_1   |     g_1   |    b_1    ]
;     pmovzxwd xmm5, xmm3              ; xmm5 : [    a_2    |     r_2   |     g_2   |    b_2    ] 
;     psrldq xmm2, 8                   ;shift a la derecha x 4 words del xmm3
;     pmovzxwd xmm3, xmm3              ; xmm3 : [    a_3    |     r_3   |     g_3   |    b_3    ] 