extern ReforzarBrillo_c
global ReforzarBrillo_asm


section .rodata

cuatro:   times 4 dd 4.0
; maskBSup: times 16 db brilloSup 
; maskBInf: times 16 db brilloInf

mask_levantar_a: db 0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255

;mask_blend: db 0,0,0,0,0,0,0,0,0,0,0,0,255,0,0,0
mask_blend: db 0,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0

mask_filter_a:  dw 0xFFFF,0xFFFF,0xFFFF,0x0000,0xFFFF,0xFFFF,0xFFFF,0x0000
mask_filter_g:  dw 0x0000,0xFFFF,0x0000,0x0000,0x0000, 0xFFFF,0x0000,0x0000

mask_128: times 16 db 0x80

mask_clean_1: dw 0xFFFF,0x0000,0x0000,0x0000
mask_clean_2: dw 0x0000,0xFFFF,0x0000,0x0000
mask_clean_3: dw 0x0000,0x0000,0xFFFF,0x0000
mask_clean_4: dw 0x0000,0x0000,0x0000,0xFFFF

mask_clean_dst: dw 0x0000,0xFFFF,0xFFFF,0xFFFF
mask_clean_2_dst: dw 0x0000,0xFFFF,0x0000,0x0000
mask_clean_3_dst: dw 0x0000,0x0000,0xFFFF,0x0000
mask_clean_4_dst: dw 0x0000,0x0000,0x0000,0xFFFF

; regMayor: times 16 db 50
; regMenor: times 16 db 50


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
sub rsp, 70
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
%define x1_row_bits [rbp - 24]
%define x2_row_bits [rbp - 32]
%define x3_row_bits [rbp - 40]

%define height_menos_4 [rbp - 48]

mov width, edx
mov height, ecx


lea eax, [edx * 4]
mov dword x1_row_bits, eax
mov r11d, eax
add eax, r11d
mov dword x2_row_bits, eax
add eax, r11d
mov dword x3_row_bits, eax


sub dword ecx, 4
mov dword height_menos_4, ecx


xor rdx, rdx
xor rcx,rcx

; Ponemos en todos los bytes de xmm11 y xmm2 el entero brilloSup y brilloInf respectivamente 
pxor xmm11, xmm11
pxor xmm12, xmm12
movss xmm11, brilloSup    
movss xmm12, brilloInf 
pshufd xmm11, xmm11, 0x00
pshufd xmm12, xmm12, 0x00 
packssdw xmm11, xmm11     
packuswb xmm11, xmm11  ; xmm11 : [  bs  |  bs  |  bs  |  bs  |  bs  |  bs   | bs  |  bs  |  bs  |  bs  |  bs  |  bs  |  bs  |  bs  |  bs  |  bs  ]    
packssdw xmm12, xmm12  
packuswb xmm12, xmm12   ; xmm12 : [  bi  |  bi  |  bi  |  bi  |  bi  |  bi   | bi  |  bi  |  bi  |  bi  |  bi  |  bi  |  bi |  bi  |  bi  |  bi  ]

; {[0] = 41, [1] = 34, [2] = 17, [3] = -1, [4] = 41, [5] = 34, [6] = 17, [7] = -1, [8] = 41, [9] = 34, [10] = 17, [11] = -1, [12] = 41, [13] = 34, [14] = 17, [15] = -1}
; {[0] = 41, [1] = 34, [2] = 17, [3] = -1, [4] = 41, [5] = 34, [6] = 17, [7] = -1, [8] = 41, [9] = 34, [10] = 17, [11] = -1, [12] = 41, [13] = 34, [14] = 17, [15] = -1}


xor r13,r13
.cicloHeight:           ; i

    xor r12, r12
    .cicloWidth:        ; j

        ;rsi + r12d * 4 + r13d * width * 4  

        pmovzxbd xmm1, [rdi]           ; xmm1 :  [a_0 | r_0 | g_0 | b_0 ]
        xor r11,r11
        mov dword r11d, x1_row_bits 
        pmovzxbd xmm2, [rdi + r11]     ; xmm2 :  [a_1 | r_1 | g_1 | b_1]

        xor r11, r11
        mov dword r11d, x2_row_bits
        pmovzxbd xmm3, [rdi + r11]     ; xmm3 :  [a_2 | r_2 | g_2 | b_2]

        xor r11,r11
        mov dword r11d, x3_row_bits
        pmovzxbd xmm4, [rdi + r11]     ; xmm4 :  [a_3 | r_3 | g_3 | b_3]
    

        packssdw xmm1, xmm2
        packssdw xmm3, xmm4

        packuswb xmm1, xmm3            


        movdqu xmm14, xmm1           ; hacemos copia para el final
        
        pmovzxbw xmm2, xmm1          ; xmm2  : [a1_ext | r1_ext | g1_ext | b1_ext |a0_ext | r0_ext | g0_ext | b0_ext ] (1er y 2do px)
        psrldq xmm1, 8
        pmovzxbw xmm3, xmm1          ; xmm3  : [a3_ext | r3_ext | g3_ext | b3_ext |a2_ext | r2_ext | g2_ext | b2_ext  ] (3ero y 4to px)


        ;creamos B

        movdqu xmm4, [mask_filter_a]   
        pand xmm2, xmm4                 ; xmm2 : [   0   |   r  |   2g   |   b    |   0    |     r    |    2g   |   b   ]
        movdqu xmm13, [mask_filter_g]
        pand xmm13, xmm2                ; xmm13 : [   0  |   0  |    gg  |   0    |   0    |     0    |    gg   |   0   ]
        paddw xmm2, xmm13               ; xmm2 :  [   0  |   r  |   2g   |   b    |   0    |     r    |    2g   |   b   ]

        
        pand xmm3, xmm4                 ; xmm3  : [   0  |   r   |   g    |   b    |   0    |    r     |   g    |   b     ]
        movdqu xmm13, [mask_filter_g]
        pand xmm13, xmm3                ; xmm13 : [   0  |   0   |    g   |   0    |   0    |    0     |    g    |   0    ]
        paddw xmm3, xmm13               ; xmm3  : [   0  |   r   |   2g   |   b    |   0    |    r     |   2g    |   b    ]


        phaddsw xmm2, xmm3            ; xmm2 : [(0+r)_3|(2g+b)_3|(0+r)_2 |(2g+b)_2|(0+r)_1 | (2g+b)_1 | (0+r)_0 | (b+2g)_0]
        xorps xmm5, xmm5
        phaddsw xmm2, xmm5            ; xmm5 : [   0   |    0   |    0   |    0   |   B3   |    B2    |    B1   |   B0   ]


        pxor xmm4, xmm4
        movdqu xmm6, [cuatro]
        pmovzxwd xmm4, xmm2         ; xmm4 : [      B3       |       B2      |      B1    |      B0    ]
        cvtdq2ps xmm4, xmm4         ; convierto int_32 a float
        divps xmm4, xmm6            ; xmm4 : [     B3/4      |      B2/4     |     B1/4   |     B0/4   ]
        roundps xmm4, xmm4, 3       ; Redondeo a 0
        cvtps2dq xmm4, xmm4         ; convierto float a int_32
        




        
        pxor xmm9,  xmm9    ;suma
        pxor xmm10, xmm10   ;resta
    
        movdqu xmm0, [mask_blend]

        xor r14, r14
        .loop_:                         ; armamos super mega mascara
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

        ;  5 5 5 0 5 0 0 0 5 0 0  Ma

        ;  0 0 0 0 0 3 3 0 0 0 0  Me




    .fin1:
        movdqu xmm2, xmm14

        paddusb xmm2, xmm9
        psubusb xmm2, xmm10 

        movdqu xmm13, [mask_levantar_a]
        paddusb xmm2, xmm13 ; levantamos la a , 
        

        movd [rsi], xmm2
        psrldq xmm2, 4
        
        xor r11, r11
        mov dword r11d, x1_row_bits
        movd [rsi + r11], xmm2
        psrldq xmm2, 4

        xor r11, r11
        mov dword r11d, x2_row_bits
        movd [rsi + r11], xmm2
        psrldq xmm2, 4

        xor r11, r11
        mov dword r11d, x3_row_bits
        movd [rsi + r11], xmm2

        add rdi, 4
        add rsi, 4

        add r12d, 1
        cmp dword r12d, width
        jl .cicloWidth

    add r13d, 4
    add rdi, x3_row_bits
    ; add rdi, x1_row_bits
    
    add rsi, x3_row_bits
    ; add rsi, x1_row_bits
    ; cmp dword r13d, height
    
    cmp dword r13d, height
    jl .cicloHeight


.fin:
pop r15
pop r14
pop r13
pop r12
pop r11
add rsp, 70
pop rbp
ret        
       