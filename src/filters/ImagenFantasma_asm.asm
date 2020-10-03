extern ImagenFantasma_c
global ImagenFantasma_asm

%define offsetX [rbp + 16]
%define offsetY [rbp + 24]

%define width [rsp + 8]
%define height [rsp + 16]

ImagenFantasma_asm:
;RSI -> *src
;RDI -> *dst
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
    pmovzxbd xmm0, [rsi + edx]     ; xmm0 : [ a_ext | r_ext | g_ext | b_ext ]

    pmovzxbd xmm1, [rsi + edx + 4] ; xmm1 : [ a_ext | r_ext | g_ext | b_ext ]

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
    pmovzxbd xmm3, [rsi + rax]     ; xmm3 : [ aaa | rrr | ggg | bbb ]
    pmovzxbd xmm4, [rsi + rax]     ; xmm4 : [ aaa | rrr | ggg | bbb ]

    ; float b = (rrr + 2 * ggg + bbb)/4;
    xorps xmm5, xmm5
    ; Creo registro: [  1  |  1  |  2  |  1  ]

    uno    : times 16 db 1
    movdqu xmm6, [uno]
    add [xmm6 + 64], 1

    mulps xmm3, xmm6    ; xmm3 : [ aaa | rrr | 2gg | bbb ]
    mulps xmm4, xmm6    ; xmm4 : [ aaa | rrr | 2gg | bbb ]

    haddps xmm3, xmm4   ; [ aaa + rrr | 2ggg + bbb | aaa + rrr | 2ggg + bbb ]




    ; tiene que quedar asi, el xmm5 ↓↓↓↓↓↓↓
    ; xmm5 : [ ? | ? | b1 | b0 ]


    ; Creo registro: [  1  |  1  |  2  |  1  ]
    ; uno    : times 16 db 1
    ; movdqu xmm6, [uno]
    ; add [xmm6 + 64], 1

    ; xmm3 : [ aaa | rrr | ggg | bbb ]
    ; xmm6 : [ 1   | 1   | 2   | 1   ]

    ; xmm4 : [ aaa | rrr | ggg | bbb ]
    ; xmm6 : [ 1   | 1   | 2   | 1   ]


    ; xmm3           : [ aaa | rrr | 2gg | bbb  ]
    ; shfl xmm3      : [ rrr | 2gg | bbb | 000  ]
    ; xmm4           : [ aaa | rrr | 2gg | bbb  ]
    ; shfl xmm4      : [    rrr  | 2gg   | bbb     | 000   ]
    ; hadd xmm3 xmm4 : [ 2gg+rrr | 0+bbb | 2gg+rrr | 0+bbb ]
    ;


    ; add xmm3 xmm4 : []

    hadd xmm3, xmm3

    repiteindo
    ; hadd : [ ??? | ??? |    b1   |   b0   ]


    ; divp : [ ??? | ??? | b1 / 4 | b0 / 4 ]


    inc r12d
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



; registro + i*iter + j*iter [adasdasdas ------------------- asdasdasdasdas]
;  (pos + 2 * [pos+32] + pos+32*2)/4



; Poner en un registro xmmx el número 0.9 extendido en 32 bits




/*

movdqu xmm0, [rbx + rcx*2*4]  ; xmm0: [ y1 | x1 | y0 | x0 ]
mulps xmm0, xmm0    ; xmm0: [ y1*y1 | x1*x1 | y0*y0 | x0*x0 ]
movdqu xmm1, [rbx + rcx*2*4 + 16]  ; xmm1: [ y3 | x3 | y2 | x2 ]
mulps xmm1, xmm1    ; xmm1: [ y4*y4 | x3*x3 | y2*y2 | x2*x2 ]

haddps xmm0, xmm1   ; [ y3*y3 + x3*x3 | y2*y2 + x2*x2 | y1*y1 + x1*x1 | y0*y0 + x0*x0 ]
sqrtps xmm0, xmm0   ; [ sqrt(y3*y3 + x3*x3) | sqrt(y2*y2 + x2*x2) | sqrt(y1*y1 + x1*x1) | sqrt(y0*y0 + x0*x0) ]
movdqu [rax + rcx * 4], xmm0

*/
