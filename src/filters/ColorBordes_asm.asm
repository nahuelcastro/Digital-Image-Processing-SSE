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
mask_levantar_a:  dw 0, 0, 0, 255, 0, 0, 0, 255



section .text


ColorBordes_asm:

;RDI -> *src
;RSI -> *dst
;EDX -> width
;ECX -> height
;R8D  -> src_row_size
;R9D  -> dst_row_size

%define width [rbp - 8]
%define height [rbp - 16]

%define width_8 [rbp - 24]
%define desp_2 [rbp - 32]

;armo stackFrame
push rbp
mov rbp, rsp
sub rsp, 40
push r11
push r12  ;contador width i
push r13  ;contador Height j
push r14  ; ii
push r15  ; jj

mov width, edx
mov height, ecx
mov eax, 8
mul edx
mov width_8, eax
xor rdx, rdx
xor rcx, rcx


xor r13,r13
inc r13d
.cicloHeight:

    xor r12, r12
    inc r12d
    .cicloWidth:
    
        ; ;rsi + r12d * 4 + r13d * width * 4
        ; lea edx, [r13d * 4]
        ; mov eax, width
        ; mul edx                         ; eax <- width * r13d * 4
        ; lea eax, [eax + r12d * 4]
        ; xor r11, r11
        ; mov r11d, eax

        ; ; traemos 4 pixeles 
        ; pmovzxbw xmm0, [rdi + r11]         ; xmm0 : [ aa_1 | rr_1 | gg_1 | bb_1 | aa_0 | rr_0 | gg_0 | bb_0 ]
        ; pmovzxbw xmm1, [rdi + r11 + 8]     ; xmm1 : [ aa_3 | rr_3 | gg_3 | bb_3 | aa_2 | rr_2 | gg_2 | bb_2 ]


        pxor xmm2, xmm2
        pxor xmm3, xmm3

        pxor xmm0, xmm0
        pxor xmm1, xmm1


        mov r15d, r13d
        sub r15d, 1    ; arranco con jj = j - 1

        mov ebx, r13d
        inc ebx
        
        
        .ciclojj:
            mov edx, r12d   ; paso i a un auxiliar 
            ;4* (jj * width + (i-1))
            dec edx 
            mov eax, r15d
            mul dword width               ; eax <- width * jj
            add eax, edx            ; eax <- (width * jj) + (i-1)
            lea r11d, [eax * 4]   ; desp_1 <- 4* (width * jj + (i-1))
            ; lea desp, [eax * 4]   ; desp_1 <- 4* (width * jj + (i-1))


            ;;segundo elemento
            ;add edx, 2
            ;mov eax, r15d
            ;mul width               ; eax <- width * jj
            ;add eax, edx            ; eax <- (width * jj) + (i+1)
            ;lea desp_2, [eax * 4]   ; desp_1 <- 4* (width * jj) + (i+1)

            ; psubw
            pmovzxbw xmm2, [rdi + r11]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm3, [rdi + r11 + 8]     ; xmm3 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            pmovzxbw xmm4, [rdi + r11 + 16]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            ;pmovzxbw xmm5, [rdi + desp + 24]     ; xmm3 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            psubw xmm2, xmm3    ; restamos
            psubw xmm3, xmm4
            
            pabsw xmm2, xmm2    ;tomamos modulo
            pabsw xmm3, xmm3

            paddw xmm0, xmm2    ; sumamos el r,g,b al acumulador de rgb, la a va a quedar con basura
            paddw xmm1, xmm3
            

        inc r15d                                 ; inc r15d 
        cmp dword r15d, ebx
        jle .ciclojj



        mov r15d, r12d
        dec r15d    ; arranco con ii = i - 1

        mov ebx, r12d  ; ebx <- i + 1 (para el cmp de cicloii)
        inc ebx


        .cicloii:
            ; mov edx, r13d   ; paso j a un auxiliar 
            ; 4*( (j-1) * width + ii) y ; 4*( (j+1) * width + ii) //  REVISAR QUE CREO QUE ME CONFUNDI ENTRE j e i            ; dec edx 
            mov eax, r13d
            dec eax
            mul dword width               ; eax <- width * (j-1)
            add eax, r15d            ; eax <- (width * (j-1)) + (ii)
            lea r11d, [eax * 4]   ; desp_1 <- 4* (width * jj + (i-1))
            ; lea desp, [eax * 4]   ; desp_1 <- 4* (width * jj + (i-1))

            ;;segundo elemento
            ;add edx, 2
            ;mov eax, r15d
            ;mul width               ; eax <- width * jj
            ;add eax, edx            ; eax <- (width * jj) + (i+1)
            ;lea desp_2, [eax * 4]   ; desp_1 <- 4* (width * jj) + (i+1)

            ; psubw
            pmovzxbw xmm2, [rdi + r11]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm4, [rdi + r11 + 8]     ; xmm3 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            ; r11 = r11 + ( 2*width ) * 4
             
            pmovzxbw xmm3, [rdi + r11 + 16]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm5, [rdi + r11 + 24]     ; xmm5 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            ;;; para NAJU estos 3 de abajo van, pero en algo la rompo, pero para mi es asi 
            ;add r11d, width_8
            ; pmovzxbw xmm3, [rdi + r11 ]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            ; pmovzxbw xmm5, [rdi + r11 + 8]     ; xmm5 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            psubw xmm2, xmm3
            psubw xmm4, xmm5
            
            pabsw xmm2, xmm2
            pabsw xmm4, xmm4
            
            paddw xmm0, xmm2    ; sumamos el r,g,b al acumulador de rgb, la a va a quedar con basura
            paddw xmm1, xmm4

        inc r15d
        cmp dword r15d, ebx
        jle .cicloii

        ; hardcodeo la A
        movdqu xmm6, [mask_levantar_a]
        paddw xmm0, xmm6            ; todas las a + 255
        paddw xmm1, xmm6

        ; IMPORTANTE tengo que ver si toma como pre que vienen con signo o sin signo
        ; y no se si viene sin signo o signo
        packuswb xmm0, xmm1  ; este toma como pre que tiene signo CREO (naju)

        movups [rsi], xmm0 ;movaps [rsi], xmm9
        add rsi, 16

        add r12d, 4
        cmp dword r12d, width
        jl .cicloWidth

    inc r13d
    cmp dword r13d, height
    jl .cicloHeight


    ;;;;;;;;;;;;;;;;;; 

    ;;;;;;;;;;;;;;;;;;;


pop r15
pop r14
pop r13
pop r12
pop r11
add rsp, 40
pop rbp
ret
