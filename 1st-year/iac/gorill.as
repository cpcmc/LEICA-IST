;===============================================================================
; Programa GORILL.as
;
; Autores:
; Cristiano Clemente - 92440 e Hugo Pitorro - 92478
; Grupo: 34
;
; Data: 23/11/2018
; Q8.8
;===============================================================================

SP_INIT 		EQU FDFFh
G 				EQU 0000100111001111b				; gravidade = 9.81 m/s^2
RND_MASK 		EQU 1000000000010110b
IO_WRITE 		EQU FFFEh
IO_STATUS 		EQU FFFDh
IO_CONTROL 		EQU FFFCh
IO_DISPLAY  	EQU  FFF0h
INT_MASK_ADDR 	EQU FFFAh
TIMER_COUNT  	EQU  FFF6h
TIMER_CTRL   	EQU  FFF7h

orig 8000h

			; sine TAB 91
sin0  WORD  0000000000000000b
sin1  WORD  0000000000000100b
sin2  WORD  0000000000001000b
sin3  WORD  0000000000001101b
sin4  WORD  0000000000010001b
sin5  WORD  0000000000010110b
sin6  WORD  0000000000011010b
sin7  WORD  0000000000011111b
sin8  WORD  0000000000100011b
sin9  WORD  0000000000101000b
sin10 WORD  0000000000101100b
sin11 WORD  0000000000110000b
sin12 WORD  0000000000110101b
sin13 WORD  0000000000111001b
sin14 WORD  0000000000111101b
sin15 WORD  0000000001000010b
sin16 WORD  0000000001000110b
sin17 WORD  0000000001001010b
sin18 WORD  0000000001001111b
sin19 WORD  0000000001010011b
sin20 WORD  0000000001010111b
sin21 WORD  0000000001011011b
sin22 WORD  0000000001011111b
sin23 WORD  0000000001100100b
sin24 WORD  0000000001101000b
sin25 WORD  0000000001101100b
sin26 WORD  0000000001110000b
sin27 WORD  0000000001110100b
sin28 WORD  0000000001111000b
sin29 WORD  0000000001111100b
sin30 WORD  0000000001111111b
sin31 WORD  0000000010000011b
sin32 WORD  0000000010000111b
sin33 WORD  0000000010001011b
sin34 WORD  0000000010001111b
sin35 WORD  0000000010010010b
sin36 WORD  0000000010010110b
sin37 WORD  0000000010011010b
sin38 WORD  0000000010011101b
sin39 WORD  0000000010100001b
sin40 WORD  0000000010100100b
sin41 WORD  0000000010100111b
sin42 WORD  0000000010101011b
sin43 WORD  0000000010101110b
sin44 WORD  0000000010110001b
sin45 WORD  0000000010110101b
sin46 WORD  0000000010111000b
sin47 WORD  0000000010111011b
sin48 WORD  0000000010111110b
sin49 WORD  0000000011000001b
sin50 WORD  0000000011000100b
sin51 WORD  0000000011000110b
sin52 WORD  0000000011001001b
sin53 WORD  0000000011001100b
sin54 WORD  0000000011001111b
sin55 WORD  0000000011010001b
sin56 WORD  0000000011010100b
sin57 WORD  0000000011010110b
sin58 WORD  0000000011011001b
sin59 WORD  0000000011011011b
sin60 WORD  0000000011011101b
sin61 WORD  0000000011011111b
sin62 WORD  0000000011100010b
sin63 WORD  0000000011100100b
sin64 WORD  0000000011100110b
sin65 WORD  0000000011101000b
sin66 WORD  0000000011101001b
sin67 WORD  0000000011101011b
sin68 WORD  0000000011101101b
sin69 WORD  0000000011101110b
sin70 WORD  0000000011110000b
sin71 WORD  0000000011110010b
sin72 WORD  0000000011110011b
sin73 WORD  0000000011110100b
sin74 WORD  0000000011110110b
sin75 WORD  0000000011110111b
sin76 WORD  0000000011111000b
sin77 WORD  0000000011111001b
sin78 WORD  0000000011111010b
sin79 WORD  0000000011111011b
sin80 WORD  0000000011111100b
sin81 WORD  0000000011111100b
sin82 WORD  0000000011111101b
sin83 WORD  0000000011111110b
sin84 WORD  0000000011111110b
sin85 WORD  0000000011111111b
sin86 WORD  0000000011111111b
sin87 WORD  0000000011111111b
sin88 WORD  0000000011111111b
sin89 WORD  0000000011111111b
sin90 WORD  0000000100000000b

; convenciona-se 0° <= ang <= 90°
; x = x0 + v0cos(0)t
; y = y0 + v0sin(0)t - (1/2)gt^2

logo0  		STR      '                  _ _ _           '
logo1  		STR      '                (_) | |           '
logo2  		STR      ' __ _  ___  _ __ _| | | __ _  ___ '
logo3  		STR      '/  _ |/ _ \| |__| | | |/ _  |/  _\'
logo4 		STR      '| (_|| (_) | |  | | | | (_| |\__ \'
logo5  		STR      '\__, |\___/|_|  |_|_|_|\__,_|/___/'
logo6  		STR      ' __) |                            '
logo7  		STR      '|___/                             '

welcome 	STR	'GORILAS'
start   	STR	'press any key to start'
congrats 	STR	'CONGRATULATIONS! You won :)'
press0		STR 'press IA to exit'
press1		STR 'press IB to play again'
thx			STR 'Thank you for playing :D'

mark        STR  ')'
space       STR  ' '

ghead       STR  'O'
gbodyl      STR  '\( )\'
gbodyr      STR  '/( )/'
glower      STR  '] ['

angulo      STR  'Angle: '
veloci      STR  'Velocity: '

gameover 	STR	 'GAMEOVER'
lost    	STR	 'You have ran out of lives'
winner  	STR	 'You have won the game!'
thanks  	STR	 'Thank you for playing!'
restart 	STR	 'Press 0 if you want to play again'
surprise  	STR	 'Please do not kill yourself'
hotline   	STR	 'Suicide-hotline: 800-273-8255'

player1 	WORD 5
last    	WORD 0
randoml 	WORD 0
randomr 	WORD 0
seed    	WORD 0
update  	WORD 0
turn    	WORD 0
lastarm 	WORD 0
digitos 	WORD 0
pressed 	WORD 0
pressedn 	WORD 0		                        ; bttcode entre [0,9]
icount		WORD 0
bttcode 	WORD 0
lastbtt		WORD 0

v0          WORD 0000000000000000b
t           WORD 0000000000000000b				; em segundos
ang         WORD 0								; em graus
x0          WORD 0000000000000000b
y0          WORD 0000000000000000b

;===============================================================================
; Tabela de Interrupcoes

		ORIG FE00h
INT0 	WORD trata0
INT1 	WORD trata1
INT2 	WORD trata2
INT3 	WORD trata3
INT4 	WORD trata4
INT5 	WORD trata5
INT6 	WORD trata6
INT7 	WORD trata7
INT8 	WORD trata8
INT9 	WORD trata9
INTA 	WORD trataA
INTB 	WORD trataB
INTC 	WORD trataC
INTD 	WORD trataD
INTE 	WORD trataE
INT15 	WORD timer

        orig 0000h
        JMP main

;===============================================================================
; Trata Interrupcoes

trata0:	PUSH 0
		CALL btt
		RTI
trata1:	PUSH 1
		CALL btt
		RTI
trata2:	PUSH 2
		CALL btt
		RTI
trata3:	PUSH 3
		CALL btt
		RTI
trata4:	PUSH 4
		CALL btt
		RTI
trata5:	PUSH 5
		CALL btt
		RTI
trata6:	PUSH 6
		CALL btt
		RTI
trata7:	PUSH 7
		CALL btt
		RTI
trata8:	PUSH 8
		CALL btt
		RTI
trata9:	PUSH 9
		CALL btt
		RTI
trataA:	PUSH 10
		CALL btt
		RTI
trataB:	PUSH 11
		CALL btt
		RTI
trataC:	PUSH 12
		CALL btt
		RTI
trataD:	PUSH 13
		CALL btt
		RTI
trataE:	PUSH 14
		CALL btt
		RTI

timer:  INC M[update]
        RTI

;===============================================================================
; programa principal

main:   MOV R1, SP_INIT
        MOV SP, R1          		; inicializa stack pointer
        MOV R1, FFFFh
        MOV M[IO_CONTROL], R1       ; inicializa porto de controlo
        ENI
        MOV R1, 1111111111111111b
        MOV M[INT_MASK_ADDR], R1
		MOV M[IO_DISPLAY], R0		; escreve 0 no ultimo segmento

        CALL login
		JMP game

;===============================================================================
; login
; mostra mensagem de boas vindas
;===============================================================================

login:  CALL ascii
		PUSH 0F1Ch
        PUSH start
        PUSH 22
        CALL write

input:	INC M[seed]				    ; utilizado para gerar numeros aleatorios
        CMP M[pressed], R0
        BR.Z input
		DSI
		MOV M[pressed], R0
        CALL blank
        RET

;===============================================================================
; game
; ciclo correspondente ao decorrer do jogo
;===============================================================================

game:   CALL gorilas

round:  CALL lives
        CALL inputs

newmove:CALL reset
hold:   CMP M[update], R0
        BR.Z hold

		PUSH R0             ; reserva espaco na pilha para o valor de y
        PUSH R0             ; reserva espaco na pilha para o valor de x
        CALL coord          ; efetua as contas da parabola
		CALL addtime
        CALL compare        ; verifica se as condições finais foram encontradas
        CALL banana         ; compara a posição calculada com a última e desenha

        BR newmove

;===============================================================================
; fulri7 (full reset)
; reinicia as variaveis necessarias para o inicio de um novo jogo
;===============================================================================

fulri7:	MOV R1, SP_INIT
        MOV SP, R1          	;inicializa stack pointer
		MOV R1, 5
		MOV M[player1], R1
		MOV M[last], R0
		MOV M[update], R0
		MOV M[turn], R0
		MOV M[lastarm], R0
		MOV M[digitos], R0
		MOV M[pressed], R0
		MOV M[pressedn], R0		; 0<=n<=9
		MOV M[icount], R0
		MOV M[bttcode], R0
		MOV M[lastbtt], R0
		CALL blank
		JMP game

;===============================================================================
; lives
; escreve o numero de vidas no display 7 segmentos; se for zero acaba o jogo
;===============================================================================

lives:  CALL wbanana
		CMP M[turn], R0
        BR.Z turn1
        DEC M[player1]
turn1:  INC M[turn]
        CALL score         ; update life count display
        CMP M[player1], R0
        JMP.Z loss
        RET

;===============================================================================
; loss
; apaga o ecra e mostra mensagens de encerramento
;===============================================================================

loss:   CALL blank

        PUSH 0930h
        PUSH gameover
        PUSH 8
        CALL write
        PUSH 0D30h
        PUSH lost
        PUSH 25
        CALL write
		JMP newgame

;===============================================================================
; win
; apaga o gorila alvo quando existe colisao e mostra animacao
;===============================================================================

win:    CALL wgorila            ; apaga gorila quando morre
		CALL wbanana            ; apaga banana quando ha colisao
        CALL dance              ; alterna entre o corpo do gorila esq/dir quando ganha
		JMP final

dance:  MOV R6, 70				; duracao da danca
        MOV R7, 0
dgorila:CMP R7, R6
        JMP.Z acaba
        MOV M[update], R0
        CALL reset
        MOV R3, M[randoml]
        SUB R3, 0002			; R3 = coordenadas do braco esquerdo do gorila
hold1:  CMP M[update], R0
        BR.Z hold1
        INC R7
        CMP M[lastarm], R0
        JMP.Z dirarm
        CMP M[lastarm], R0
        JMP.P esqarm

        ; corpo do gorila da direita
dirarm: PUSH R3
        PUSH gbodyr
        PUSH 5
        CALL write
        INC M[lastarm]
        JMP dgorila

        ; corpo do gorila da esquerda
esqarm: PUSH R3
        PUSH gbodyl
        PUSH 5
        CALL write
        DEC M[lastarm]
        JMP dgorila
acaba:	RET

        ; apaga (3x5) a volta gorila quando existe colisao
wgorila:MOV R7, M[randomr]
        MOV R6, R7
        SUB R6, 0102h       ; inicio da str a apagar
        ADD R7, 0200h
        SUB R7, 0002h       ; final da str a apagar
loop3:  CMP R6, R7
        BR.P return4
        MOV R5, R6
        PUSH R5
        PUSH 5
        CALL clean
        ADD R6, 0100h
        BR loop3
return4:RET

wbanana:MOV R1, M[last]
		PUSH R1
		PUSH 1
		CALL clean
		RET

final:	PUSH 0102h
		PUSH congrats
		PUSH 27
		CALL write
		JMP newgame

;===============================================================================
; newgame
; pergunta se quer comecar um novo jogo ou encerrar
;===============================================================================

newgame:PUSH 0302h
		PUSH press0
		PUSH 16
		CALL write

		PUSH 0402h
		PUSH press1
		PUSH 22
		CALL write

fim:	MOV M[pressed], R0
input1:	CMP M[pressed], R0
		BR.Z input1
		MOV M[pressed], R0
		MOV R1, 10
		CMP M[bttcode], R1		      ; bttcode - 10
		BR.N input1
		MOV R1, 11
		CMP M[bttcode], R1		      ; bttcode - 11
		BR.P input1
		MOV R1, 10
		CMP M[bttcode], R1
		JMP.NZ fulri7				  ; se input = IB

        ;ecra final
		CALL blank
		PUSH 0B1Bh
		PUSH thx
		PUSH 24
		CALL write

end: 	BR end

;===============================================================================
; --> Rotinas secundarias

;===============================================================================
; score
; mostra o numero de vidas atual do utilizador no display de 7 segmentos
;===============================================================================

score:  MOV R1, M[player1]
        MOV M[IO_DISPLAY], R1
        RET


;===============================================================================
; inputs
; pede e trata os inputs (ang, vel) do utilizador
;===============================================================================

inputs:		MOV M[icount], R0
			CALL inputang
			CALL inputvel
hold2:		CALL reseti
check:		CMP M[update], R0
			BR.Z check
			DEC M[update]
			MOV M[t], R0
			CALL cleani
			RET

inputang:	ENI
			PUSH 0102h
			PUSH angulo
			PUSH 7
			CALL write		         ; escreve 'Angle: '
			MOV R3, 0109h
			PUSH R0
			CALL press
			POP R1
			MOV M[ang], R1
			RET

inputvel:	PUSH 0302h
			PUSH veloci
			PUSH 10
			CALL write		         ; escreve 'Velocity: '
			MOV R3, 030Ch
			PUSH R0
			CALL press
			POP R1
			SHL R1, 8
			MOV M[v0], R1
			RET

press:		MOV R5, R0
			MOV M[pressedn], R0
press2:		MOV R1, 2
			CMP M[digitos], R1
			JMP.Z continua			; input acabou?

keep:   	CMP M[pressedn], R0
			BR.Z keep				; botao premido?
			DEC M[pressedn]
			MOV R1, 1
			CMP M[icount], R1		; 2º digito do angulo?
			BR.NZ segue1
			MOV R1, 9
			CMP M[lastbtt], R1		; o 1º digito do angulo e 9?
			BR.NZ segue1
			CMP M[bttcode], R0
			BR.NZ keep

segue1:		MOV R2, M[bttcode]
			MOV M[lastbtt], R2
			ADD R2, 48			    ; R2 = codigo ascii bttcode
			PUSH R2
			PUSH R3
			CALL draw
			MOV R4, 10
			MUL R4, R5
			ADD R5, M[bttcode]

			INC R3				    ; move cursor para a frente
			INC M[digitos]		    ; num dig input LOCAL
			INC M[icount]		    ; num dig input GLOBAL
			JMP press2

continua:	MOV M[SP+2], R5
			MOV M[digitos], R0
			RET

reseti:     MOV R1, 15
            MOV M[TIMER_COUNT], R1
            MOV R1, 1
            MOV M[TIMER_CTRL], R1
            RET

;===============================================================================
; cleani
; apaga label + inputs
;===============================================================================

cleani: PUSH 0102h
        PUSH 10
        CAll clean
        PUSH 0302h
        PUSH 14
        CALL clean
        RET

;===============================================================================
; btt
; trata da interrucao gerada pelos botoes
;===============================================================================

btt:	PUSH R1
        INC M[pressed]
		MOV R1, M[SP+3]			; btt code
		MOV M[bttcode], R1
		MOV R1, 9
		CMP M[bttcode], R1		; bttcode - 9
		BR.P segue
		INC M[pressedn]
segue:	POP R1
		RETN 1

;===============================================================================
; compare
; compara a posicao atual da banana com as condicoes terminais
;===============================================================================

compare:CALL hitbox				; (colisao banana com jogador/alvo)
        CALL border             ; (x = 80, y = 0)
        RET

        ;hitbox 5x3 que rodeia o centro do gorila
hitbox: CALL selfhit
        CALL cima
        CALL meio
        CALL baixo
        RET

selfhit:MOV R1, M[randoml]		; colisao com o proprio jogador
        ADD R1, 0002h
        CMP R1, M[SP+4]
        CALL.Z surp
        JMP.Z game
        RET

cima:   MOV R1, M[randomr]
        SUB R1, 0102h			; coordenadas ombro esquerdo do gorila
        PUSH M[SP+4]        	; cordenadas da banana
        PUSH R1
        CALL collide
        RET

meio:   MOV R1, M[randomr]
        SUB R1, 0002h			; coordenadas braco esquerdo do gorila
        PUSH M[SP+4]			; coordenadas da banana
        PUSH R1
        CALL collide
        RET

baixo:  MOV R1, M[randomr]
        SUB R1, 0002h
        ADD R1, 0100h			; coordenadas ombro esquerdo do gorila
        PUSH M[SP+4]			; coordenadas da banana
        PUSH R1
        CALL collide
        RET

collide:MOV R1, M[SP+2]     	; R1 = hitbox
        MOV R2, 4
        ADD R2, R1
back:   CMP R2, R1          	; ciclo entre os 3 elementos da hitbox
        BR.Z miss
        CMP R1, M[SP+3]
        JMP.Z win
        INC R1
        BR back
miss:   RETN 2


border: CALL borderx
        CALL bordery
        RET

borderx:MOV R1, M[SP+4]     	; R1 = yyxx
        AND R1, 00FFh       	; obtem os ultimos dois digitos
        CMP R1, 0050h       	; verifica se x = 80
        JMP.P round
return2:RET

bordery:MOV R1, M[SP+4]
        AND R1, FF00h       	; obtem os primeiros dois digitos
        CMP R1, 1800h       	; verifica se y = 0
        JMP.P round
        RET

;===============================================================================
; gorilas
; desenha  os gorilas nas posicoes geradas aleatoriamente
;===============================================================================

gorilas:CALL random
        PUSH M[randoml]          ; coord gorila esquerda
        PUSH gbodyl           	 ; corpo gorila esquerda
        CALL gorila

        PUSH M[randomr]          ; coord gorila direita
        PUSH gbodyr              ; corpo gorila direita
        CALL gorila
        RET

gorila: CALL head
        CALL body
        CALL legs
        RETN 2

head:   MOV R1, M[SP+4]       	; R1 = coord gorila
        SUB R1, 0100h
        PUSH M[ghead]         	; desenha a cabeca do gorila
        PUSH R1
        CALL draw
        RET

body:   MOV R1, M[SP+4]       	; coord gorila random (yyxx)
        SUB R1, 0002h
        PUSH R1
        PUSH M[SP+4]          	; string gbody (esq/dir)
        PUSH 5
        CALL write
        RET

legs:   MOV R1, M[SP+4]       	; coord gorila random (yyxx)
        ADD R1, 0100h
        SUB R1, 0001h
        PUSH R1
        PUSH glower           	; endereco string pernas do gorila
        PUSH 3
        CALL write
        RET

;===============================================================================
; RANDOM
; seed (variavel) -> seed', randoml, randomr, y0, x0
;===============================================================================

random:	CALL newseed
		CALL gen_xy
		RET

newseed:MOV R1, M[seed]
		AND R1, 0001h
		CMP R1, R0
		MOV R1, M[seed]
		BR.Z next
		XOR R1, RND_MASK
next:   ROR R1, 1
		MOV M[seed], R1		; seed'
		RET

gen_xy: MOV R1, M[seed]		; R1=y1x1y2x2 (abcd)
		MOV R3, 0000h
		MVBL R3, R1			; R3=00y2x2 (00cd)
		SHR R1, 8			; R1=00y1x1 (00ab)
		MOV R2, 0010h
		DIV R1, R2			; R1=y1(a)	R2=x1(b)
		MOV R4, 0010h
		DIV R3, R4			; R3=y2(c)	R4=x2(d)

		CALL gor1
		CALL gor2
		RET

gor1:	ADD R1, 2			; y1 real
		ADD R2, 2			; x1 real
		MOV R5, 23
		SUB R5, R1			; y1' copia	= 23-y1 real
		SHL R5, 8			; = y'y'00
		MVBL R5, R2			; R5 = y'y'xx1 (0a0b)
		MOV M[randoml], R5
		INC R1
		SHL R1, 8
		MOV M[y0], R1
		INC R2				; acima do ombro
		INC R2				; banana sai acima da mao
		SHL R2, 8
		MOV M[x0], R2
		RET

gor2:	ADD R3, 2			; y2 real
		ADD R4, 62			; x2 real
		MOV R5, 23
		SUB R5, R3			; y2' copia	= 23-y2 real
		SHL R5, 8			; = y'y'00
		MVBL R5, R4			; R5 = y'y'xx2 (0c0d)
		MOV M[randomr], R5
		RET

;===============================================================================
; reset
; reinicia o timer e adiciona 0.03125s a variavel tempo (t)
;===============================================================================

reset:  MOV R1, 1
        MOV M[TIMER_COUNT], R1
        MOV R1, 1
        MOV M[TIMER_CTRL], R1 ;1 segundo depois existe interrupt
        RET

addtime:DEC M[update]
        MOV R1, 0000000000001000b
        ADD M[t], R1        ; tempo + 0.03125s
        RET

;===============================================================================
; banana
; compara a posicao atual com a anterior e apaga/desenha se esta for diferente
;===============================================================================

banana: MOV R1, M[SP+2]
        CMP M[last], R1
        BR.Z volta
        CALL desenha
        MOV M[last], R1
volta:  RETN 1

desenha:PUSH R1
        PUSH M[mark]
        PUSH R1
        CALL draw          ; escreve banana atual
        PUSH M[space]
        PUSH M[last]
        CALL draw
        POP R1
        RET

;===============================================================================
; coord
; efetua os calculos da trajetoria do projetil; devolve ((23 - y), x)
;===============================================================================

coord:  CALL x              ; R1 = x <== (v0, ang, t)
        CALL y              ; R2 = y <== (v0, ang, t)
        CALL ygrid          ; transforma a coordenada y para o desenho (23 - y)
        CALL gridc          ; yyxx
        RETN 1

        ; (v0, ang, t) => (x)
x:      MOV R1, 90
        SUB R1, M[ang]     	; R1 = 90 - ang <=> angulo complementar
        MOV R2, 8000h       ; endereco do inicio da tabela
        ADD R2, R1          ; R2 = 8000h + ang
        MOV R1, M[R2]       ; sin(ang complementar) = cos(ang)
        MOV R2, M[v0]     	; R2 = velocidade inicial
        PUSH R0
        PUSH R1
        PUSH R2
        CALL multip
        POP R2
        ; R1 = 0
        ; R2 = v0x

        MOV R1, M[t]  		; R7 = tempo
        PUSH R0
        PUSH R1
        PUSH R2
        CALL multip
        POP R2
        ; R2 = v0x*t
        MOV R1, M[x0]  		; R1 = x0
        ADD R1, R2      	; R1 = x

        MOV M[SP+3], R1
        RET

        ; (v0, ang, t) => (y)
y:      MOV R1, 8000h
        ADD R1, M[ang] 	     ; R1 = 8000h + ang
        MOV R2, M[R1]        ; R2 = sin(ang)
        MOV R1, M[v0] 	     ; R1 = velocidade inicial
        PUSH R0
        PUSH R1
        PUSH R2
        CALL multip
        POP R2               ; R2 = v0y

        MOV R1, M[t]         ; R1 = tempo
        PUSH R0
        PUSH R2
        PUSH R1
        CALL multip
        POP R1               ; R1 = v0y*t

        MOV R2, M[t]         ; R2 = tempo
        MOV R3, R2
        PUSH R0
        PUSH R2
        PUSH R3
        CALL multip
        POP R3
        ; R3 = t*t [time(s) square(d)]

        MOV R2, G   		; R2 = gravidade
        PUSH R0
        PUSH R2
        PUSH R3
        CALL multip
        POP R3              ; R3 = g * t**2
        SHR R3, 1          	; R3 = 1/2 * g * t**2

        SUB R1, R3      	; R1 = v0y * t - 1/2* g * t**2
        MOV R2, M[y0]   	; R2 = y0
        ADD R1, R2        	; R1 = y
        MOV M[SP+4], R1
        RET

		;transforma y em (23 - y) para desenho
ygrid:  MOV R1, M[SP+4]
        MOV R2, 1700h       ; R2 = 23
        SUB R2, R1
        MOV M[SP+4], R2     ; M[SP+4] = 23 - y
        RET

		;transforma x, (23 - y) num numero de 16bits
gridc:  MOV R1, M[SP+4]     ; R1 = 23 - y
        MOV R2, M[SP+3]     ; R2 = x
        SHR R2, 8
        MVBL R1, R2         ; R1 = y'y'xx
        MOV M[SP+4], R1
        RET

;===============================================================================
; funcoes auxiliares
; seed (variavel) -> seed', randoml, randomr, y0, x0
;===============================================================================

draw:   MOV R1, M[SP+3]     ; char
        MOV R2, M[SP+2]     ; io_control
        MOV M[IO_CONTROL], R2
        MOV M[IO_WRITE], R1
        RETN 2

blank:  MOV R1, FFFFh
        MOV M[IO_CONTROL], R1
        RET

write:  MOV R1, M[SP+3]     ; stack do adr string
        MOV R2, M[SP+2]     ; length da string
        ADD R2, R1          ; adr last char
        MOV R4, M[SP+4]     ; io_control
length: CMP R1, R2
        BR.Z return
        MOV R3, M[R1]
        MOV M[IO_CONTROL], R4
        MOV M[IO_WRITE], R3
        INC R1
        INC R4
        BR length
return: RETN 3

clean:  MOV R1, M[SP+3]     ; recebe io_control
        MOV R2, M[SP+2]     ; len string
        ADD R2, R1          ; final io_control
loop2:  CMP R1, R2
        BR.Z return1
        MOV M[IO_CONTROL], R1
        MOV R3, 32
        MOV M[IO_WRITE], R3 ; write space
        INC R1
        BR loop2
return1:RETN 2

;===============================================================================
; multip
; espaco_resultado, 1ºop, 2ºop -> espaco_resultado = 1ºop*2ºop
;===============================================================================

multip:	PUSH R1				; salvaguarda R1
		PUSH R2				; salvaguarda R2
		MOV R1, M[SP+5] 	; R1 = 1ºop (00aa)
		MOV R2, M[SP+4]		; R2 = 2ºop (00bb)
		MUL R1, R2			; R1 = parte+significativa (00cc) R2 = parte-significativa (00dd)
		SHL R1, 8			; R1 = cc00
		SHR R2, 8			; R2 = 00dd
		MVBL R1, R2			; R1 = ccdd
        MOV M[SP+6], R1		; espaco_resultado = 1ºop*2ºop
		POP R2				; repoe R2
		POP R1				; repoe R1
        RETN 2


;===============================================================================
; ascii
; escreve ascii art no ecra inicial
;===============================================================================

ascii:  MOV R5, logo0
        MOV R6, 0616h
loop7:  CMP R5, logo7			;pointer-final
        BR.P return7
        MOV R7, R6
        PUSH R7
        PUSH R5
        PUSH 34
        CALL write
        ADD R6, 0100h
        ADD R5, 34
        BR loop7
return7:RET

;===============================================================================
; surp
; --> mostra uma mensagem quando o jogador acerta no proprio gorila
;===============================================================================

surp:   PUSH 0102h
        PUSH surprise
        PUSH 27
        CALL write
        PUSH 0302h
        PUSH hotline
        PUSH 29
        CALL write
		CALL reseti
hold3:	CMP M[update], R0
        BR.Z hold3
        DEC M[update]
        CALL blank
        RET
