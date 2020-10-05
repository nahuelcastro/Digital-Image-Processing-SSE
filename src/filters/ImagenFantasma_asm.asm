extern ImagenFantasma_c
global ImagenFantasma_asm

%define offsetX [rbp + 16]
%define offsetY [rbp + 24]

%define width [rsp + 8]
%define height [rsp + 16]

.rodata:

unob    : times 12 db 255.0
alfa    : times 4 dd 0.9
uno     : times 4 dd 1.0
;mascara : dq 0x0000000100000000
ocho    : times 4 dd 8.0
unofin  : times 1 dd 1.0
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
sub rsp, 32
push r11
push r12  ;contador Height
push r13  ;contador width
push r14  ; ii
push r15  ; jj


mov width, edx
mov height, ecx

; xor rdx, rdx
; xor ecx, ecx

xor r13,r13
.cicloHeight:

  xor r12, r12
  .cicloWidth:

    xor rdx, rdx
    xor ecx, ecx

    ; rsi + r12d * 4 + r13d * width
    lea edx, [r12d * 4]
    mov eax, width
    mul r12d                       ; rax <- width * r12d
    add edx, eax                   ; edx <- [r12d * 4 + width * r12d]
    xor r11, r11
    mov r11d, edx
    pmovzxbd xmm0, [rdi + r11]     ; xmm0 : [ a_ext | r_ext | g_ext | b_ext ]
    pmovzxbd xmm1, [rdi + r11 + 4] ; xmm1 : [ a_ext | r_ext | g_ext | b_ext ]

    ; Calculamos ii y jj
    mov eax, r12d
    xor r11, r11
    mov r11d, 2h
    fdiv r11d           ;devuelve en rax     ;;;
    add eax, offsetX
    mov r14d, eax

    mov eax, r13d
    fdiv r11d
    add eax, offsetY
    mov r15d, eax

    ; Guardamos en xmm3 y xmm4 los pixel para ghosting ponele rey (?
    xor r11, r11
    mov r11d, offsetX
    lea edx, [r11d + r15d * 4]
    mov rax, width
    mul edx                        ; rax <- (r15d * 4 + offsetY) * width
    add eax, r14d                  ; rax <- rax + r14d
    add eax, offsetX               ; rax <- rax +  offsetX
    xor r11, r11
    mov r11d, eax
    pmovzxbd xmm3, [rdi + r11]     ; xmm3 : [ aaa | rrr | ggg | bbb ]
    pmovzxbd xmm4, [rdi + r11 + 4] ; xmm4 : [ aaa | rrr | ggg | bbb ]

    .creoB:
      xorps xmm5, xmm5
      ; Creo registro: [  1  |  1  |  2  |  1  ]
      movdqu xmm6, [uno]
      xorps xmm10, xmm10
      movdqu xmm10, [uno]
      psrldq xmm10, 12  ; 0 0 0 1
      pslldq xmm10, 4  ;  0 0 1 0
      ; movdqu xmm10, [unofin]
      ; pslldq xmm10, 4
      addps xmm6, xmm10
      mulps xmm3, xmm6    ; xmm3 : [ aaa | rrr | 2ggg | bbb ]
      mulps xmm4, xmm6    ; xmm4 : [ aaa | rrr | 2ggg | bbb ]

      pslldq xmm3, 4 ; xmm3 : [ rrr | 2ggg | bbb |  0  ]
      pslldq xmm4, 4 ; xmm4 : [ rrr | 2ggg | bbb |  0  ]

      haddps xmm3, xmm4   ; xmm3 : [ rrr + 2ggg | bbb + 000 | rrr + 2ggg | bbb + 000 ]
      xorps xmm7, xmm7
      haddps xmm3, xmm7   ; xmm3 : [     0      |      0     |     b1    |     b0     ]


      ;dos    : times 16 db 2
      movdqu xmm6, [ocho]
      divps xmm3, xmm6    ; xmm3 : [     0      |      0     |     b1/8   |     b0/8   ]


    movdqu xmm9,xmm0
    movdqu xmm10,xmm1

    movdqu xmm6, [alfa]
    mulps xmm0, xmm6      ; xmm0 : [  aa * 0.9    |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ]
    mulps xmm1, xmm6      ; xmm1 : [  aa * 0.9    |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ]



    xorps xmm8, xmm8
    pmovzxbd xmm8, [unob]    ;xmm8 : [  0  |   1    |    1   |    1    ]
    andps xmm0, xmm8         ;xmm0 : [  0  |rr * 0.9|gg * 0.9|bb * 0.9 ]
    andnps xmm9, xmm8        ;xmm9 : [ aa  |    0   |    0   |    0    ]
    orps xmm0, xmm9          ;xmm0 : [ aa  |rr * 0.9|gg * 0.9|bb * 0.9 ]

    andps xmm1, xmm8         ;xmm1 : [  0  |rr * 0.9|gg * 0.9|bb * 0.9 ]
    andnps xmm10, xmm8       ;xmm10: [ aa  |    0   |    0   |    0    ]
    orps xmm1, xmm10         ;xmm1 : [ aa  |rr * 0.9|gg * 0.9|bb * 0.9 ]

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

    packssdw xmm0, xmm1 ; xmm0: [    aa    | rr*0.9+b1/2 | gg*0.9+b1/2 | bb*0.9+b1/2 |    aa    | rr*0.9+b0/2 | gg*0.9+b0/2 | bb*0.9+b0/2 ]
    xorps xmm7, xmm7
    packusdw xmm0, xmm7

    movq [rsi], xmm0
    add rsi, 8

    add r12d, 2
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
    sub rsp, 32
    ret



;gdb --args tp2 ImagenFantasma -i asm ../img/NottingHill.bmp 0 0




;

    ; mov [rsp+32], 0000
    ; movd [rsp+36], 00000000h
    ; movss [rsp+40], 3f800000h ; 1.0
    ; movd [rsp+44], 00000000h
    ;
    ; movss xmm6, [rsp+32]
;
