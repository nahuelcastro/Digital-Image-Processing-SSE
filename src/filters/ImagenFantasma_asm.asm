extern ImagenFantasma_c
global ImagenFantasma_asm

%define offsetX [rbp + 16]
%define offsetY [rbp + 24]

%define width [rsp + 8]
%define height [rsp + 16]

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
sub rsp, 16
push r12  ;contador Height
push r13  ;contador width
push r14  ; ii
push r15  ; jj

mov width, edx
mov height, ecx

xor rdx, rdx
xor ecx, ecx

.cicloHeight:

  xor r12, r12
  .cicloWidth:
    ; rsi + r12d * 4 + r13d * width
    lea edx, [r12d * 4]
    mov rax, width
    mul r13d                       ; rax <- width * r13d
    add edx, rax                   ; edx <- [r12d * 4 + width * r13d]
    pmovzxbd xmm0, [rdi + edx]     ; xmm0 : [ a_ext | r_ext | g_ext | b_ext ]
    pmovzxbd xmm1, [rdi + edx + 4] ; xmm1 : [ a_ext | r_ext | g_ext | b_ext ]

    ; Calculamos ii y jj
    div r12d, 2          ;devuelve en rax
    add rax, offsetX
    mov r14d, rax

    div r13d, 2
    add rax, offsetY
    mov r15d, rax

    ; Guardamos en xmm3 y xmm4 los pixel para ghosting ponele rey (?
    lea edx, [r15d * 4 + offsetX]
    mov rax, width
    mul edx                        ; rax <- (r15d * 4 + offsetY) * width
    add rax, r14d                  ; rax <- rax + r14d
    add rax, offsetX               ; rax <- rax +  offsetX
    pmovzxbd xmm3, [rdi + rax]     ; xmm3 : [ aaa | rrr | ggg | bbb ]
    pmovzxbd xmm4, [rdi + rax + 4] ; xmm4 : [ aaa | rrr | ggg | bbb ]

    creoB:
      xorps xmm5, xmm5

      ; Creo registro: [  1  |  1  |  2  |  1  ]
      uno    : times 4 dd 1
      ;uno    : times 16 db 1
      movdqu xmm6, [uno]
      add [xmm6 + 64], 1

      mulps xmm3, xmm6    ; xmm3 : [ aaa | rrr | 2ggg | bbb ]
      mulps xmm4, xmm6    ; xmm4 : [ aaa | rrr | 2ggg | bbb ]

      pslldq xmm3, 4 ; xmm3 : [ rrr | 2ggg | bbb |  0  ]
      pslldq xmm4, 4 ; xmm4 : [ rrr | 2ggg | bbb |  0  ]

      haddps xmm3, xmm4   ; xmm3 : [ rrr + 2ggg | bbb + 000 | rrr + 2ggg | bbb + 000 ]
      xorps xmm7, xmm7
      haddps xmm3, xmm7   ; xmm3 : [     0      |      0     |     b1    |     b0     ]

      dos    : times 4 dd 8
      ;dos    : times 16 db 2
      movdqu xmm6, [dos]
      divps xmm3, xmm6    ; xmm3 : [     0      |      0     |     b1/8   |     b0/8   ]


    alfa    : times 4 dd 0.9
    movdqu xmm6, [alfa]
    add [xmm6 + 0] , 0.1  ; ver si xmm6 va con corchetes
    mulps xmm0, xmm6      ; xmm0 : [  aa * 1    |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ]
    mulps xmm1, xmm6      ; xmm1 : [  aa * 1    |   rr * 0.9    |   gg * 0.9    |   bb * 0.9    ]

    ; COMO NO SE NOS OCURRIÓ, HICIMOS CABEZEADAS
    cabezeada1: times 4 dd [xmm3 + 96]
    ;cabezeada1: times 16 dd [xmm3 + 96]
    movdqu xmm6, [cabezeada1]
    movd  [xmm6 + 0], 0                   ; ver si xmm6 va con corchetes
    addps xmm0, xmm6
    cabezeada2: times 4 dd [xmm3 + 64]
    ;cabezeada2: times 16 dd [xmm3 + 64]
    movdqu xmm6, [cabezeada2]
    movd  [xmm6 + 0], 0                   ; ver si xmm6 va con corchetes
    addps xmm1, xmm6
    packssdw xmm0, xmm1 ; xmm0: [    aa    | rr*0.9+b1/2 | gg*0.9+b1/2 | bb*0.9+b1/2 |    aa    | rr*0.9+b0/2 | gg*0.9+b0/2 | bb*0.9+b0/2 ]
    xorps xmm7, xmm7
    packusdw xmm0, xmm7

    movq [rsi], xmm0
    add rsi, 8

    add r12d, 2
    cmp r12d, edx
    jl cicloWidth:

  inc r13d
  cmp r13d, ecx
  jl cicloWidth:

    pop r15
    pop r14
    pop r13
    pop r12
    sub rsp, 16
    ret
