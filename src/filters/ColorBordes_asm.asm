extern ColorBordes_c
global ColorBordes_asm

%define pixel_size 4


section .rodata


mask_levantar_a:  dw 0, 0, 0, 255, 0, 0, 0, 255
blanco: times 16 db 0xff
mask_vertical: db 255,255,255,255,0,0,0,0,0,0,0,0,0,0,0,0

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
%define width_dec [rbp - 32]
%define height_dec [rbp - 40]
%define tope [rbp - 48]
%define rsi_original [rbp - 56]

;armo stackFrame
push rbp
mov rbp, rsp
sub rsp, 56
push r11
push r12  ;contador width i
push r13  ;contador Height j
push r14  ; ii
push r15  ; jj

mov width, edx
mov height, ecx
sub edx, 4
sub ecx, 1
mov width_dec  , edx
mov height_dec , ecx


; este tope es chino, pero anda, despues si podes emprolijalo mazi
mov rsi_original, rsi
mov eax, r8d
xor r11,r11
mov r11d, 0x4
cdq
div r11d
mov tope, eax

xor rdx, rdx
xor rcx, rcx

; acomoda el rsi para escribir la imagen

xor r13, r13
mov eax, 4
mul dword width
add eax, 4
mov r13d, eax
add rsi, r13

xor r13,r13
inc r13d
.cicloHeight:           ; j

    xor r12, r12
    inc r12d
    .cicloWidth:        ; i

        pxor xmm0, xmm0     ; acum px1 y px2
        pxor xmm1, xmm1     ; acum px3 y px4

        pxor xmm2, xmm2     ; px aux
        pxor xmm3, xmm3     ; px aux

        pxor xmm4, xmm4     ; px aux
        pxor xmm5, xmm5     ; px aux


        xor r15, r15
        mov r15d, r13d      ; r15 = jj
        sub r15d, 1         ; jj = j - 1

        mov ebx, r13d       ; ebx marca el fin de ciclo
        inc ebx             ; ebx = j + 1


        .ciclojj:
            mov r14d, r12d           ; paso i a un auxiliar
            ;4* (jj * width + (i-1))
            dec r14d
            xor eax, eax
            mov eax, r15d
            mul dword width         ; eax <- width * jj
            add eax, r14d            ; eax <- (width * jj) + (i-1)
            xor r11, r11
            lea r11d, [eax * 4]     ; r11 <- 4* (width * jj + (i-1))


            pmovzxbw xmm2, [rdi + r11]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm3, [rdi + r11 + 8]     ; xmm3 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]
            pmovzxbw xmm4, [rdi + r11 + 16]    ; xmm4 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]

            psubw xmm2, xmm3    ; restamos
            psubw xmm3, xmm4

            pabsw xmm2, xmm2    ;tomamos modulo
            pabsw xmm3, xmm3

            paddw xmm0, xmm2    ; sumamos el r,g,b al acumulador de rgb, la a va a quedar con basura
            paddw xmm1, xmm3

            inc r15d
            cmp dword r15d, ebx
            jle .ciclojj

        xor r14, r14
        mov r14d, r12d
        dec r14d        ; arranco con ii = i - 1
        mov ebx, r12d   ; ebx <- i + 1 (para el cmp de cicloii)
        inc ebx

        .cicloii:
            ; mov edx, r13d   ; paso j a un auxiliar
            ; 4*( (j-1) * width + ii) y ; 4*( (j+1) * width + ii) //  REVISAR QUE CREO QUE ME CONFUNDI ENTRE j e i      
            xor eax, eax
            mov eax, r13d
            dec eax
            mul dword width         ; eax <- width * (j-1)
            add eax, r14d           ; eax <- (width * (j-1)) + (ii)
            xor r11, r11
            lea r11d, [eax * 4]     ; r11 <- 4* (width * jj + (ii))


            pmovzxbw xmm2, [rdi + r11]         ; xmm2 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm4, [rdi + r11 + 8]     ; xmm4 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            ;;; para NAJU estos 3 de abajo van, pero en algo la rompo, pero para mi es asi
            ; r11 = r11 + ( 2*width ) * 4

            mov eax, 8; 8
            mul dword width
            add r11d, eax

            pmovzxbw xmm3, [rdi + r11 ]         ; xmm3 : [ a_1 | r_1 | g_1 | b_1 | a_0 | r_0 | g_0 | b_0 ]
            pmovzxbw xmm5, [rdi + r11 + 8]      ; xmm5 : [ a_3 | r_3 | g_3 | b_3 | a_2 | r_2 | g_2 | b_2 ]

            psubw xmm2, xmm3
            psubw xmm4, xmm5

            pabsw xmm2, xmm2    ; tomamos modulo
            pabsw xmm4, xmm4

            paddw xmm0, xmm2    ; sumamos el r,g,b al acumulador de rgb, la a va a quedar con basura
            paddw xmm1, xmm4

            inc r14d
            cmp dword r14d, ebx
            jle .cicloii


        ; hardcodeo la A
        movdqu xmm6, [mask_levantar_a]
        paddw xmm0, xmm6            ; todas las a + 255
        paddw xmm1, xmm6

        ; IMPORTANTE tengo que ver si toma como pre que vienen con signo o sin signo
        ; y no se si viene sin signo o signo
        packuswb xmm0, xmm1

        movups [rsi], xmm0 ;movaps [rsi], xmm0
        add rsi, 16

        add r12d, 4 ; con 8 anda 1/4 * 2
        cmp dword r12d, width
        jl .cicloWidth

    inc r13d
    cmp dword r13d, height_dec
    jl .cicloHeight


whiteBorder:
    ; rdi_original + width*4
    ; rdi_original + width*4 - 4
    mov rsi, rsi_original
    xor r12,r12
    xor r15, r15 ; aux
    pxor xmm1, xmm1
    movdqu xmm1, [blanco]

    .horizontal:
        movups [rsi], xmm1
        movups [rsi + 16 ], xmm1

        add rsi, 32
        add r12d, 8 ; porque hago de a 8 px

        cmp dword r12d, width_dec
        jl .horizontal

        xor r12, r12
        mov rsi, rsi_original
        cmp r15d, 1
        je .vertical

        inc r15d
        ; rsi =  rsi + ( width * (height - 1) )* 4
        xor rax, rax
        add rax, height
        dec rax
        mul dword width
        lea rax, [rax * 4]
        add rsi, rax
        jmp .horizontal

    .vertical:
        pxor xmm0, xmm0
        pxor xmm2, xmm2

        movdqu xmm0, [rsi]
        movdqu xmm2, [mask_vertical]
        paddusb xmm0, xmm2  ;paddusb -> suma saturada sin signo de a bytes
        movdqu [rsi], xmm0

        xor r13, r13
        mov eax, 4
        mul dword width
        sub eax, 4
        mov r13d, eax

        pxor xmm0, xmm0

        movdqu xmm0, [rsi + r13]
        movdqu xmm2, [mask_vertical]
        paddusb xmm0, xmm2  ;paddusb -> suma saturada sin signo de a bytes
        movdqu [rsi + r13], xmm0


        xor rax, rax
        mov rax, 4
        mul dword width
        add rsi, rax

        inc r12d
        cmp dword r12d, height_dec
        jl .vertical



pop r15
pop r14
pop r13
pop r12
pop r11
add rsp, 56
pop rbp
ret
