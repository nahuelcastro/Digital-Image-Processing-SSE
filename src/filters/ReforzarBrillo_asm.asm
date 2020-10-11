extern ReforzarBrillo_c
global ReforzarBrillo_asm


section .rodata

cuatro:   times 4 dd 4.0


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
%define brilloSup [rbp + 30]
%define brilloInf [rbp + 38]

%define width [rbp - 8]
%define height [rbp - 16]

mov width, edx
mov height, ecx

xor rdx, rdx
xor rcx,rcx




xor r13,r13
.cicloHeight:           ; i 

    xor r12, r12
    .cicloWidth:        ; j

    
    lea edx,[r15d * 4]            ; edx <-  jj * tamaño pixel
    mov eax, width
    mul edx                        ; eax <- (jj * 4) * width
    lea eax, [eax + r14d * 4]      ; eax <- eax + r14d * 4
    xor r11, r11
    mov r11d, eax
    
    pmovzxbw xmm2, [rdi + r11]           ; xmm2 : (ghosting) [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
    pmovzxbw xmm3, [rdi + r11 + 8]       ; xmm3 : (ghosting) [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]


  ;creamos B
    pxor xmm4, xmm4
    pblendw xmm2, xmm4, 0x88      ; xmm2  : [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm8, xmm8
    pblendw xmm8, xmm2, 0x22     ; xmm12 : [   0  |   0  |   gg  |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm2, xmm8             ; xmm2  : [   0  |   rg |  2gg  |   bg   |   0    |    rg    |   2gg   |   bg  ]

    pxor xmm4, xmm4
    pblendw xmm3, xmm4, 0x88      ; xmm2 :  [   0  |   rg |   gg  |   bg   |   0    |    rg    |   gg   |   bg   ]
    pxor xmm8, xmm8
    pblendw xmm8, xmm3, 0x22     ; xmm12 : [   0  |   0  |    gg   |   0    |   0    |    0     |    gg   |   0   ]
    paddw xmm3, xmm8             ; xmm3 :  [   0  |   rg |   2gg  |   bg   |   0    |    rg    |   2gg   |   bg   ]

    phaddsw xmm2, xmm3            ; xmm2 : [(0+r)_3|(2g+b)_3|(0+r)_2 |(2g+b)_2|(0+r)_1 | (2g+b)_1 | (0+r)_0 | (b+2g)_0]
    xorps xmm5, xmm5
    phaddsw xmm2, xmm5            ; xmm5 : [   0   |    0   |    0   |    0   |   B3   |    B2    |    B1   |   B0   ]

    
    pxor xmm7, xmm7
    movdqu xmm6, [cuatro]
    pmovzxwd xmm7, xmm2         ; xmm7 : [      B3       |       B2      |      B1    |      B0    ]
    cvtdq2ps xmm7, xmm7         ; convierto int_32 a float
    divps xmm7, xmm6            ; xmm7 : [     B3/4      |      B2/4     |     B1/4   |     B0/4   ]



    add rsi, 16
    
    add r12d, 4 
    cmp dword r12d, width
    jl .cicloWidth

    inc r13d 
    cmp dword r13d, height
    jl .cicloHeight


pop r15
pop r14
pop r13
pop r12
pop r11
add rsp, 56
pop rbp
ret

