;6532 RIOT (U3)
RIOT = $0400
RIOT_PORTA   = RIOT+$00
RIOT_DDRA    = RIOT+$01
RIOT_PORTB   = RIOT+$02
RIOT_DDRB    = RIOT+$03

;6522 VIA (U4)
VIA = $8000
VIA_PORTB    = VIA+$00  ;Input/Ouput Register B
VIA_DDRB     = VIA+$02  ;Data Direction Register B
VIA_DDRA     = VIA+$03  ;Data Direction Register A
VIA_T1CL     = VIA+$04  ;read:  T1 counter, low-order
                        ;write: T1 latches, low-order
VIA_T1CH     = VIA+$05  ;T1 counter, high-order
VIA_T2CL     = VIA+$08  ;read:  T2 counter, low-order
                        ;write: T2 latches, low-order
VIA_T2CH     = VIA+$09  ;T2 counter, high-order
VIA_ACR      = VIA+$0B  ;Auxiliary Control Register
VIA_PCR      = VIA+$0C  ;Peripheral Control Register
VIA_IFR      = VIA+$0D  ;Interrupt Flag Register
VIA_IER      = VIA+$0E  ;Interrupt Enable Register
VIA_PORTA_NH = VIA+$0F  ;Input/Output Register A (No Handshaking)

;6850 ACIA (U5)
ACIA = $A000
ACIA_CR      = ACIA+$00 ;Control Register (on write)
ACIA_SR      = ACIA+$00 ;Status Register (on read)
ACIA_TDR     = ACIA+$01 ;Transmit Data Register (on write)
ACIA_RDR     = ACIA+$01 ;Receive Data Register (on read)

B_F9B7	= $F9B7

* = $F800				; Begin address of this block
MESSAGES
!byte $4F, $4B, $8D, $43, $4D, $44, $20, $45	; OK.CMD E
!byte $52, $52, $8D, $49, $31, $2E, $34, $8D	; RR.I1.4.
!byte $41, $54, $54, $20, $45, $52, $52, $8D	; ATT ERR.
 
P_F818		
    ldx	#$00
		jsr	P_F85F		; $F85F

B_F81D		
    dex
		beq	B_F84D
  
		lda	VIA_PORTA_NH
		and	#$41
		cmp	#$41
		beq	B_F81D
  
		lda	$02
		eor	#$FF
		sta	$0402

B_F830		
    bit	VIA_PORTA_NH
		bvc	B_F830
  
		jsr	P_F86C		; $F86C
		ldx	#$FF
		stx	VIA_T2CH

B_F83D		
    lda	VIA_PORTA_NH
		lsr	
		bcs	B_F852
  
		lda	VIA_IFR
		and	#$20
		beq	B_F83D
  
		lda	#$01

B_F84D = * + 1              ; Instruction parameter is jumped to.
  	bit $80a9
  	jsr P_F8D0

B_F852	jsr P_F85F
  	stx $0402
  	rts

P_F859		
    jsr	P_F896		; $F859 , $F896

P_F85C		
    lda	#$04
		!byte $2C			; dummy BIT opcode

P_F85F		
    lda	#$20
		!byte $2C			; dummy BIT opcode

P_F862		
    lda	#$02
		ora	VIA_PORTA_NH
		bne	B_F877
  
P_F869		
    lda	#$FB
		!byte $2C			; dummy BIT opcode

P_F86C		
    lda	#$DF
		!byte $2C			; dummy BIT opcode

P_F86F		
    lda	#$EF
		!byte $2C			; dummy BIT opcode

P_F872		
    lda	#$FD
P_F874		
    and	VIA_PORTA_NH
B_F877		
    sta	VIA_PORTA_NH
		rts
  
P_F87B		
    lda	#$00
		sta	$01
		jsr	P_F86F		; $F86F
		jsr	P_F862		; $F862
		lda	#$FF
		sta	VIA_T2CH

B_F88A		
    lda	VIA_IFR
		and	#$20      ; Has Timer 2 timed out?
		beq	B_F89E
  
		lda	#$02
		jsr	P_F8D0		; $F8D0

P_F896		
    lda	#$ED
		jsr	P_F874		; $F874
		lda	#$0D
		rts
  
B_F89E		
    bit	VIA_PORTA_NH
		bmi	B_F88A
  
		jsr	P_F872		; $F872
		bit	VIA_PORTB
		bvs	B_F8B0
  
		lda	#$40
		jsr	P_F8D0		; $F8D0

B_F8B0		
    lda	RIOT_PORTA
		eor	#$FF
		pha
		jsr	P_FD15		; $FD15
		lda	VIA_PORTA_NH
		ora	#$10
		sta	VIA_PORTA_NH

B_F8C1		
    bit	VIA_PORTA_NH
		bpl	B_F8C1
  
		lda	VIA_PORTA_NH
		and	#$EF
		sta	VIA_PORTA_NH
		pla
		rts
  
P_F8D0		
    ora	$01
		sta	$01
		rts
  
RESET		
    cld
		lda	#$00
		tax
CLRSTK		
    pha
		dex
		bne	CLRSTK            ;Fill stack $01FF-$0100 with #$00

		stx	RIOT_DDRA         ;Set RIOT's PORT A to be all inputs
		stx	VIA_T2CL
		lda	#%11000000        ;Set VIA timer for continuous interrupts
		sta	VIA_ACR           ;  disable latch and shift register
		lda	#$18
		sta	VIA_T1CL
		stx	VIA_T1CH
		lda	#%10001010        ;VIA PORT B:  Bits 7, 4, 1 as outputs
		sta	VIA_DDRB          
		lda	#$36              ;VIA PORT A:  Bits 5, 4, 2, 1 as outputs
		sta	VIA_DDRA
		lda	#$03              ;ACIA Master Reset
		sta	ACIA_CR           
		lda	#$51              ;ACIA Settings: Div. Ratio: 16 (1200 baud), Word: 8N2,
		sta	ACIA_CR           ;  No xmit interrupts, RTS high, no recv interrupts
		lda	#$0B
		sta	$3D
		lda	#$04
		sta	$0E
		dex
		txs                   ;Init stack pointer to #$FF
		stx	VIA_IFR           ;Clear all VIA interrupt flags
		stx	RIOT_DDRB         ;Set RIOT's PORT B to be all outputs
		stx	RIOT_PORTA
		stx	RIOT_PORTB
		stx	VIA_PORTA_NH
		stx	VIA_PORTB
		ldy	#$1E

B_F922		
    stx	$1E,Y
		dey
		bpl	B_F922
  
		lda	#$EF
		sta	VIA_PCR
		lda	#$7F
		sta	VIA_IER
		lda	#$90
		sta	VIA_IER
		lda	#$0B
		sta	$10
		cli
		ldx	#$28

B_F93D		
    jsr	P_F946		; $F93D , $F946
		dex
		bne	B_F93D
  
		jmp	J_FA37		; $FA37
  
P_F946		
    lda	#$FF
		sta	VIA_T2CH

B_F94B		
    lda	VIA_IFR
		and	#$20
		beq	B_F94B
  
		lda	VIA_PORTB
		eor	#$02
		sta	VIA_PORTB       ; Blink LED
		rts
  
IRQ		
    sta	$0F
    lda #$10
    sta VIA_IFR
    lda VIA_PORTB
    and #$04
    bne $f9a7

lf969   
    lda VIA_PORTB
    and #$10
    bne lf969

lf970
    lda #$cd
    sta VIA_PCR
    lda #$ff
    sta $15
    lda $1f
    bne $f9a7

lf97d   
    jsr J_FFA5
    lda $1a
    beq lf987

lf984   
    jsr P_FE74

lf987   
    lda VIA_PORTA_NH
    and #$fb
    ora #$12
    sta VIA_PORTA_NH
    ldx #$00
    stx $14
    stx $1e
    stx $1b
    stx $1a
    stx $18
    stx $17
    stx $01
    dex
    stx $1f
    jmp J_FA40
    lda	$0F
		rti
  
P_F9AA		
    jsr	P_FD05		; $F9AA , $FD05
		bit	$05
		bpl	B_F9B7
  
		jsr	P_FD44		; $FD44
		jsr	P_FD37		; $FD37
		jsr	P_FD44		; $FD44
		lda	$01
		and	#$BF
		beq	B_F9C6
  
B_F9C0		
    lda	#$00
		sta	$0B
		beq	B_F9C0
  
B_F9C6		
    jsr	P_FCFB		; $F9C6 , $FCFB
		ldx	#$32

B_F9CB		
    dex
		bne	B_F9CB
  
		lda	#$08
		sta	$06

B_F9D2		
    lda	VIA_PORTB
		tay
		eor	VIA_PORTB
		and	#$20
		bne	B_F9D2
  
		tya
		and	#$20
		beq	B_FA28
  
		jsr	P_FD15		; $FD15
		ror	$07
		lda	#$6F
		ror
		ror
		ror
		sta	VIA_PCR
		ldx	#$0B

B_F9F1		
    dex
		bne	B_F9F1
  
		jsr	P_FD05		; $FD05
		ldx	#$0A

B_F9F9		
    dex
		bne	B_F9F9
  
		lda	#$ED
		sta	VIA_PCR
		dec	$06
		bne	B_F9D2
  
		lda	#$04
		sta	VIA_T2CH

B_FA0A		
    cli
		lda	VIA_IFR
		and	#$20
		bne	B_FA28
  
		sei
		jsr	P_FD15		; $FD15
		jsr	P_FD20		; $FD20
		lsr	          ;A
		bcs	B_FA0A
  
		lda	#$00
		sta	$0B
		jsr	P_FD15		; $FD15
		cli
		rts
  
 
S_FA25
    !byte $A9, $80, $2C			; ..,
 
B_FA28		
    lda	#$03

J_FA2A		
    jsr	P_FD32		; $FA2A , $FD32
  	bne	P_FA2F
  
P_FA2F		
    ldx	#$0B

B_FA31		
    dex
		bne	B_FA31
  
		jmp	P_FD0F		; $FD0F
  
J_FA37		
    cli
		jsr	P_FBE0		; $FBE0

J_FA3B		
    cli
		lda	$15
		beq	J_FA3B
  
J_FA40		
    cli
		ldx	#$F8
		txs
		jsr	P_FBE0		; $FBE0

J_FA47		
    jsr	P_FD05		; $FA47 , $FD05

B_FA4A		
    lda	VIA_PORTB
		and	#$04
		bne	B_FA5B
  
		lda	VIA_PORTB
		and	#$10
		beq	B_FA4A
  
		jmp	J_FA79		; $FA79
  
B_FA5B		
    lda	VIA_PORTB
		and	#$04
		bne	B_FA68
  
		brk
		nop
		nop
		jmp	J_FA47		; $FA47
  
B_FA68		
    lda	VIA_PORTB
		and	#$10
		beq	B_FA5B
  
		lda	$1F
		bmi	B_FA76
  
		jmp	J_FB13		; $FB13
  
B_FA76		
    jmp	J_FB7C		; $FA76 , $FB7C
  
J_FA79		
    jsr	P_FC45		; $FA79 , $FC45
		sta	$02
		cli
		ldx	$16
		bne	B_FABE
  
		and	#$1F
		tay
		lda	$02
		cmp	#$3F
		beq	B_FAC6
  
		cmp	#$5F
		beq	B_FAC6
  
		and	#$F0
		cmp	#$F0
		beq	B_FAC9
  
		cmp	#$E0
		beq	B_FAB4
  
		and	#$E0
		cmp	#$60
		beq	B_FAD6
  
		cmp	#$20
		bne	B_FAAA
  
		ldx	#$FF
		stx	$1F
		bne	B_FAFF
  
B_FAAA		
    cmp	#$40
		bne	B_FB10
  
		lda	#$01
		sta	$1F
		bne	B_FAFF
  
B_FAB4		
    sty	$0D
		lda	$0C
		jsr	P_FF3E		; $FF3E
		jsr	P_FF86		; $FF86

B_FABE		
    sei
		lda	$15
		bne	B_FAC6
  
		jsr	P_FD0F		; $FD0F

B_FAC6		
    jmp	J_FA37		; $FAC6 , $FA37
  
B_FAC9		
    tya
		and	#$0F
		sta	$0D
		jsr	P_FF3E		; $FF3E
		jsr	P_FF86		; $FF86
		ldy	$0D

B_FAD6		
    lda	$1F
		bmi	B_FADD
  
		sei
		dec	$1F

B_FADD		
    sty	$0D
		cpy	#$1F
		bne	B_FAF2
  
		lda	$0C
		cmp	$0E
		bne	B_FAF2
  
		ldx	#$00
		stx	$14
		dex
		stx	$1A
		bne	B_FB10
  
B_FAF2		
    cpy	#$0F
		bne	B_FB10
  
		ldx	#$FF
		stx	$1B
		inx
		stx	$00
		beq	B_FB10
  
B_FAFF		
    sty	$0C
		cpy	$0E
		beq	B_FB08
  
		lda	#$FF
		!byte $2C			; dummy BIT opcode

B_FB08		
    lda	#$00
		sta	$20
		lda	#$80
		sta	$0D

B_FB10		
    jmp	J_FA40		; $FB10 , $FA40
  
J_FB13		
    lda	$1A
		beq	B_FB1A
  
		jmp	J_FBB7		; $FBB7
  
B_FB1A		
    sei
		jsr	P_FF37		; $FF37
		bcs	B_FB22
  
		dec	$1B

B_FB22		
    jsr	P_FF97		; $FB22 , $FF97
		bcs	B_FB2A
  
		lda	#$01
		!byte $2C			; dummy BIT opcode

B_FB2A		
    lda	#$00
		sta	$0B
		cli
		jsr	P_F859		; $F859
		lda	#$ED
		sta	VIA_PCR

B_FB37		
    jsr	P_FD15		; $FB37 , $FD15
		lda	$0B
		beq	B_FB49
  
		lda	$04
		sta	$07
		lda	$03
		sta	$01
		jmp	J_FB65		; $FB65
  
B_FB49		
    inc	$1F
		jsr	P_F87B		; $F87B
		sta	$07
		sta	$04
		lda	$01
		sta	$03
		inc	$0B
		sei
		lda	$15
		beq	B_FB62
  
		dec	$1F
		brk
		nop
		nop

B_FB62		
    dec	$1F
		cli

J_FB65		
    lda	$01
		asl	                ;A
		sta	$05

B_FB6A		
    jsr	P_F9AA		; $FB6A , $F9AA
		cli
		lda	$1B
		beq	B_FB37
  
		lda	$05
		bpl	B_FB37
  
		lda	#$0D
		sta	$07
		bne	B_FB6A
  
J_FB7C		
    jsr	P_FC45		; $FB7C , $FC45
		sta	$02
		lda	$1A
		beq	B_FB8C
  
		lda	#$00
		sta	$14
		jsr	P_FE14		; $FE14

B_FB8C		
    lda	$16
		bne	B_FB9E
  
		lda	$1B
		beq	B_FB97
  
		jsr	P_FE84		; $FE84

B_FB97		
    jsr	P_FBE0		; $FB97 , $FBE0
		cli
		jmp	J_FB7C		; $FB7C
  
B_FB9E		
    lda	$1A
		beq	B_FBA8
  
		jsr	P_FE62		; $FE62
		jsr	P_FF86		; $FF86

B_FBA8		
    ldx	#$00
		stx	$1B
		stx	$17
		jsr	P_FCFB		; $FCFB
		jsr	P_FD15		; $FD15
		jmp	J_FA37		; $FA37
  
J_FBB7		
    lda	#$ED
		sta	VIA_PCR
		lda	#$00
		sta	$01
		sta	$1F
		cli
		ldy	$10

B_FBC5		
    tya
		pha
		lda	MESSAGES,Y
		sta	$05
		and	#$7F
		sta	$07
		jsr	P_FD15		; $FD15
		jsr	P_F9AA		; $F9AA
		cli
		pla
		tay
		bit	$05
		bmi	B_FBC5
  
		iny
		bne	B_FBC5
  
P_FBE0		
    lda	$16
		sta	$08
		lda	#$00
		sta	$16
		sta	$06
		lda	$14
		bpl	J_FC41
  
		lda	$1E
		bpl	B_FC04
  
		lda	$20
		bmi	B_FC04
  
		beq	B_FBFE
  
B_FBF8		
    jsr	P_FDCC		; $FBF8 , $FDCC
		jmp	J_FC2C		; $FC2C
  
B_FBFE		
    lda	$0E
		cmp	#$04
		bne	B_FBF8
  
B_FC04		
    jsr	P_F818		; $FC04 , $F818
		ldx	$1E
		bmi	J_FC2C
  
		lda	$02
		cmp	#$3F
		beq	B_FC15
  
		cmp	#$5F
		bne	B_FC1B
  
B_FC15		
    lda	#$00
		sta	$01
		beq	B_FC24
  
B_FC1B		
    and	#$F0
		cmp	#$E0
		bne	J_FC2C
  
		lda	#$04
		!byte $2C			; dummy BIT opcode

B_FC24		
    lda	#$36
		ora	VIA_PORTA_NH
		sta	VIA_PORTA_NH

J_FC2C		
    lda	$20
		bne	J_FC41
  
		txa
		bpl	J_FC41
  
		lda	$01
		beq	B_FC3D
  
		jsr	P_FDCC		; $FDCC
		jmp	J_FC41		; $FC41
  
B_FC3D		
    lda	#$FF
		sta	$20

J_FC41		
    clc
		ror	$14
		rts
  
P_FC45		
    lda	VIA_PORTB
		lsr	;A
		lsr	;A
		lsr	;A
		ror	$1E
		bpl	B_FC52
  
		jsr	P_F85C		; $F85C

B_FC52		
    jsr	P_FD20		; $FC52 , $FD20
		bcc	B_FC52
  
		lda	#$00
		sta	$15
		jsr	P_FD08		; $FD08

B_FC5E		
    lda	#$01
		sta	VIA_T2CH

B_FC63		
    lda	VIA_PORTB
		and	#$10
		beq	B_FC8A
  
		lda	VIA_IFR
		and	#$20
		beq	B_FC63
  
		lda	$06
		beq	B_FC7B
  
		sei
		lda	#$02
		jmp	J_FA2A		; $FA2A
  
B_FC7B		
    jsr	P_FCFE		; $FC7B , $FCFE
		jsr	P_FA2F		; $FA2F
		lda	#$40
		jsr	P_FD32		; $FD32
		inc	$06
		bne	B_FC5E
  
B_FC8A		
    ldy	#$08

B_FC8C		
    lda	VIA_PORTB
		and	#$10
		beq	B_FC8C
  
		lda	VIA_PORTB
		rol	;A
		rol	;A
		rol	;A
		ror	$09
		
B_FC9B		
    lda	VIA_PORTB
		and	#$10
		bne	B_FC9B
  
		dey
		bne	B_FC8C
  
		lda	VIA_PORTB
		bit	$16
		bvc	B_FCAF
  
		and	#$F7
		!byte $2C			; dummy BIT opcode

B_FCAF		
    ora	#$08
		sta	VIA_PORTB
		sei
		lda	$1E
		bmi	B_FCDC
  
		lda	$09
		cmp	#$3F
		beq	B_FCDC
  
		cmp	#$5F
		beq	B_FCDC
  
		ldx	#$0C

B_FCC5		
    jsr	P_FD20		; $FCC5 , $FD20
		lsr	;A
		bcc	B_FCD0
  
		dex
		bne	B_FCC5
  
		beq	B_FCDC
  
B_FCD0		
    jsr	P_FD20		; $FCD0 , $FD20
		lsr	;A
		bcs	B_FCDC
  
		dex
		bne	B_FCD0
  
		jmp	J_FA37		; $FA37
  
B_FCDC		
    lda	$20
		bpl	B_FCEB
  
		lda	$01
		beq	B_FCEB
  
		lda	#$00
		sta	$01
		jmp	J_FA3B		; $FA3B
  
B_FCEB		
    jsr	P_FCFE		; $FCEB , $FCFE
		lda	$1E
		bmi	B_FCF5
  
		jsr	P_F869		; $F869

B_FCF5		
    sec
		ror	$14
		lda	$09
		rts
  
P_FCFB		
    lda	#$FD
		!byte $2C			; dummy BIT opcode

P_FCFE		
    lda	#$DF
		and	VIA_PCR
		bne	B_FD11
  
P_FD05		
    lda	#$02
		!byte $2C			; dummy BIT opcode

P_FD08		
    lda	#$20
		ora	VIA_PCR
		bne	B_FD11
  
P_FD0F		
    lda	#$EF

B_FD11		
    sta	VIA_PCR
		rts
  
P_FD15		
    lda	VIA_PORTB
		and	#$04
		bne	B_FD1F
  
		brk
		nop
		nop

B_FD1F		
    rts
  
P_FD20		
    lda	VIA_PORTB
		tay
		eor	VIA_PORTB
		and	#$10
		bne	P_FD20
  
		tya
		lsr
		lsr
		lsr
		lsr
		lsr
		rts

P_FD32		
    ora	$16
		sta	$16
		rts
  
P_FD37		
    sei

B_FD38		
    jsr	P_FD15		; $FD38 , $FD15
		lda	VIA_PORTB
		and	#$20
		bne	B_FD38
  
		beq	B_FD4F
  
P_FD44		
    sei

B_FD45		
    jsr	P_FD15		; $FD45 , $FD15
		lda	VIA_PORTB
		and	#$20
		beq	B_FD45
  
B_FD4F		
    jsr	P_FD15		; $FD4F , $FD15
		cli
		rts
  
 
S_FD54
  !byte $6F, $9F, $1A, $E6, $CE, $66, $32, $18	; o....f2.
  !byte $0F, $0B, $07, $05, $01, $02, $01, $01	; ........
  !byte $00, $00, $00, $00, $00, $00, $00, $00	; ........
  !byte $00, $00				; ..
 
J_FD6E		
    cpx	#$0D
		bne	B_FD7A
  
		lda	$3D
		ora	#$08
		and	#$FB
		bne	B_FD99
  
B_FD7A		
    bcs	B_FD89
		lda	$FD54,X
		sta	VIA_T1CL
		lda	$FD61,X
		sta	VIA_T1CH
		rts
  
B_FD89		
    txa
		clc
		ror	;A
		tax
		lda	$FDAF,X
		bcs	B_FD97
  
		eor	#$FF
		and	$3D
		!byte $2C			; dummy BIT opcode

B_FD97		
    ora	$3D
B_FD99		
    sta	$3D
		and	#$0F
		tax
		lda	$FDBC,X
		bpl	B_FDA8
  
		lda	#$10
		sta	$10
		rts
  
B_FDA8		
    and	#$5F
		bit	$3D
		bpl	B_FDB0
  
		ora	#$20

B_FDB0		
    ora	#$40
		sta	ACIA_CR
		rts
  
 
S_FDB6
  !byte $0C, $02, $01, $40, $80, $20, $01, $09	; ...@. ..
  !byte $80, $19, $80, $80, $80, $80, $80, $80	; ........
  !byte $11, $15, $05, $0D, $80, $1D	; ......
 
P_FDCC		
    lda	ACIA_SR
		and	#$02            ;DCD carrier detected?
		beq	P_FDCC
  
		lda	$02
		bit	$3D
		bvc	B_FDEF
  
		cmp	#$41
		bcc	B_FDEF
  
		cmp	#$5B
		bcs	B_FDE5
  
		ora	#$20
		bne	B_FDEF
  
B_FDE5		
    cmp	#$C1
		bcc	B_FDEF
  
		cmp	#$DB
		bcs	B_FDEF
  
		and	#$7F

B_FDEF		
    sta	ACIA_TDR
		ldx	#$01
		stx	$20
		dex
		stx	$01
		dex
		cmp	#$0D
		bne	B_FE13
  
		lda	$3D
		and	#$20
		beq	B_FE13
  
		ldy	#$04

B_FE06		
    stx	VIA_T2CH

B_FE09		
    lda	VIA_IFR
		and	#$20
		beq	B_FE09
  
		dey
		bpl	B_FE06
  
B_FE13		
    rts
  
P_FE14		
    lda	$17
		bmi	B_FE55
  
		ldx	$02
		cpx	#$0D
		beq	B_FE3B
  
		and	#$01
		bne	B_FE25
  
		txa
		lsr	;A
		!byte $2C			; dummy BIT opcode

B_FE25		
    txa
		asl	;A
		eor	$18
		clc
		adc	#$05
		sta	$18
		inc	$17
		ldx	#$05
		cpx	$17
		beq	B_FE3C
  
		inx
		cpx	$17
		beq	B_FE4B
  
B_FE3B		
    rts
  
B_FE3C		
    lda	#$45
		cmp	$18
		bne	B_FE3B
  
		lda	#$0C

B_FE44		
    sta	$12
		lda	#$FD
		sta	$17
		rts
  
B_FE4B		
    lda	#$F2
		cmp	$18
		bne	B_FE3B
  
		lda	#$0E
		bne	B_FE44
  
B_FE55		
    tay
		iny
		beq	B_FE61
  
		sty	$17
		iny
		iny
		lda	$02
		sta	($12),Y

B_FE61		
    rts
  
P_FE62		
    lda	$18
		ldx	#$1A

B_FE66		
    dex
		bmi	B_FE77
  
		cmp	$FF48,X
		bne	B_FE66
  
		jsr	P_FE74		; $FE74
		jmp	J_FD6E		; $FD6E
  
P_FE74		
    lda	#$00
		!byte $2C			; dummy BIT opcode

B_FE77		
    lda	#$03
		sta	$10
		lda	#$00
		sta	$17
		sta	$18
		sta	$1A
		rts
  
P_FE84		
    ldx	$17
		bpl	B_FE8A
  
B_FE88		
    rts
  
P_FE89		
    inx

B_FE8A		
    lda	$FF62,X
		bpl	B_FE88
  
		tay
		iny
		beq	B_FED6
  
		iny
		beq	B_FEC3
  
		iny
		beq	B_FEAB
  
		lda	#$20
		cmp	$02
		beq	B_FE88
  
B_FE9F		
    jsr	P_FE89		; $FE9F , $FE89
		beq	J_FED1
  
		cmp	$02
		beq	B_FEBA
  
		inx
		bne	B_FE9F
  
B_FEAB		
    jsr	P_FE89		; $FEAB , $FE89
		bne	B_FEB1
  
		rts
  
B_FEB1		
    cmp	$02
		beq	B_FEBA
  
		inx
		bne	B_FEAB
  
		beq	J_FED1
  
B_FEBA		
    inx
		lda	$FF62,X
		bmi	B_FED3
  
		sta	$17
		rts
  
B_FEC3		
    lda	#$1F
		cmp	$02
		bcc	J_FED1
  
		lda	$02
		jsr	P_FF12		; $FF12
		jsr	P_FF26		; $FF26

J_FED1		
    ldx	#$FF

B_FED3		
    stx	$17
		rts
  
B_FED6		
    lda	$02
		ldx	$00
		bmi	B_FF0B
  
		beq	B_FEF8
  
		jsr	P_FF1A		; $FF1A
		bcs	B_FEED
  
		ldx	#$FF
		stx	$00
		sec
		sbc	#$26
		jmp	P_FF12		; $FF12
  
B_FEED		
    lda	#$FE
		sta	$00
		lda	$1C
		sbc	#$30
		jmp	P_FF12		; $FF12
  
B_FEF8		
    cmp	#$20
		beq	B_FF0B
  
		cmp	#$3A
		beq	B_FF0B
  
		jsr	P_FF1A		; $FF1A
		bcs	B_FF0C
  
		sta	$1C
		lda	#$01
		sta	$00

B_FF0B		
    rts
  
B_FF0C		
    lda	#$80
		sta	$00
		bne	J_FED1
  
P_FF12		
    sta	$0D
		jsr	P_FF86		; $FF86
		jmp	J_FED1		; $FED1
  
P_FF1A		
    cmp	#$30
		bcc	B_FF24
  
		cmp	#$3A
		bcs	B_FF24
  
		clc
		rts
  
B_FF24		
    sec
		rts
  
P_FF26		
    jsr	P_FF37		; $FF26 , $FF37
		bcc	B_FF36
  
		txa
		bmi	J_FF80
  
		lda	$0C
		sta	$21,X
		lda	$0D
		sta	$20,X

B_FF36		
    rts
  
P_FF37		
    ldx	#$08
		lda	#$21
		jmp	J_FFC7		; $FFC7
  
P_FF3E		
    jsr	P_FF37		; $FF3E , $FF37
		bcs	B_FF47
  
		ldx	#$FF
		stx	$20,Y

B_FF47		
    rts
  
S_FF48
  !byte $5C, $4E, $09, $6B, $07, $3D, $33, $15	; \N.k.=3.
  !byte $22, $2A, $27, $45, $F2, $C5, $9E, $CD	; "*'E....
  !byte $E6, $EB, $51, $4F, $37, $EF, $85, $0D	; ..QO7...
  !byte $62, $6E, $FC, $42, $08, $50, $FE, $55	; bn.B.P.U
  !byte $0C, $00, $FD, $2D, $16, $00, $FC, $31	; ...-...1
  !byte $FF, $32, $FF, $41, $FF, $42, $FF, $00	; .2.A.B..
  !byte $FC, $52, $FF, $50, $FF, $57, $FF, $00	; .R.P.W..
 
J_FF80		
    jsr	P_F946		; $FF80 , $F946
		jmp	J_FF80		; $FF80
  
P_FF86		
    jsr	P_FF90		; $FF86 , $FF90
		bcs	B_FF8F
  
		ldx	#$FF
		stx	$28,Y

B_FF8F		
    rts
  
P_FF90		
    lda	#$29
		ldx	#$0A
		jmp	J_FFC7		; $FFC7
  
P_FF97		
    jsr	P_FF90		; $FF97 , $FF90
		bcs	B_FFA4
  
		ldx	$33,Y
		stx	$03
		ldx	$32,Y
		stx	$04

B_FFA4		
    rts

J_FFA5  
		lda	$0B
		beq	P_FF86
  
		jsr	P_FF90		; $FF90
		bcc	B_FFBC
  
		txa
		bmi	J_FF80
  
		lda	$0C
		sta	$29,X
		lda	$0D
		sta	$28,X
		jmp	J_FFBE		; $FFBE
  
B_FFBC		
    tya
		tax

J_FFBE		
    lda	$01
		sta	$33,X
		lda	$04
		sta	$32,X
		rts
  
J_FFC7		
    sta	$12
		stx	$19
		ldx	#$FF
		ldy	#$FF

B_FFCF		
    iny
		cpy	$19
		beq	B_FFEA
  
		lda	($12),Y
		iny
		cmp	#$FF
		bne	B_FFDF
  
		tya
		tax
		bne	B_FFCF
  
B_FFDF		
    cmp	$0D
		bne	B_FFCF
  
		lda	($12),Y
		cmp	$0C
		bne	B_FFCF
  
		clc

B_FFEA		
    rts
  
S_FFEB
!byte $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA	; ........
!byte $AA, $AA, $AA, $AA, $AA, $AA, $AA	; .......

* = $FFFA
!word $F95B ; NMI
!word RESET
!word IRQ

;end
