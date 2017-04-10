
    * = $f800

messages:
    !text "OK", $8d
    !text "CMD ERR", $8d
    !text "I1.6", $8d
    !text "ATT ERR", $8d


LF818:  ldx     #$00
        jsr     LF85F
LF81D:  dex
        beq     LF84D
        lda     $800F
        and     #$41
        cmp     #$41
        beq     LF81D
        lda     $02
        eor     #$FF
        sta     $0402
LF830:  bit     $800F
        bvc     LF830
        jsr     LF86C
        ldx     #$FF
        stx     $8009
LF83D:  lda     $800F
        lsr     ;a
        bcs     LF852
        lda     $800D
        and     #$20
        beq     LF83D
        lda     #$01
        !byte   $2C
LF84D:  lda     #$80
        jsr     LF8F2
LF852:  jsr     LF85F
        stx     $0402
        rts

LF859:  jsr     LF8AC
LF85C:  lda     #$04
        !byte   $2C
LF85F:  lda     #$20
        !byte   $2C
LF862:  lda     #$02
        ora     $800F
        bne     LF877
        lda     #$FB
        !byte   $2C
LF86C:  lda     #$DF
        !byte   $2C
LF86F:  lda     #$EF
        !byte   $2C
LF872:  lda     #$FD
LF874:  and     $800F
LF877:  sta     $800F
        rts

LF87B:  lda     #$00
        sta     $01
        lda     $1D
        beq     LF895
        ldy     $10
        lda     messages,y
        bpl     LF88E
        ldx     #$40
        stx     $01
LF88E:  and     #$7F
        sta     $07
        inc     $10
        rts

LF895:  jsr     LF86F
        jsr     LF862
        lda     #$FF
        sta     $8009
LF8A0:  lda     $800D
        and     #$20
        beq     LF8B4
        lda     #$02
        jsr     LF8F2
LF8AC:  lda     #$ED
        jsr     LF874
        lda     #$0D
        rts

LF8B4:  bit     $800F
        bmi     LF8A0
        jsr     LF872
        bit     $8000
        bvs     LF8C6
        lda     #$40
        jsr     LF8F2
LF8C6:  lda     $0400
        eor     #$FF
        pha
        sta     $07
        sta     $04
        lda     #$01
        sta     $0B
        lda     $01
        sta     $03
        jsr     LFCA8
        lda     $800F
        ora     #$10
        sta     $800F
LF8E3:  bit     $800F
        bpl     LF8E3
        lda     $800F
        and     #$EF
        sta     $800F
        pla
        rts

LF8F2:  ora     $01
        sta     $01
        rts

LF8F7:  sei
        cld
        lda     #$00
        tax
LF8FC:  pha
        dex
        bne     LF8FC
        stx     $0401
        stx     $8008
        lda     #$C0
        sta     $800B
        lda     #$18
        sta     $8004
        stx     $8005
        lda     #$8A
        sta     $8002
        lda     #$36
        sta     $8003
        lda     #$03
        sta     $A000
        lda     #$51
        sta     $A000
        lda     #$0B
        sta     $40
        lda     #$04
        sta     $0E
        dex
        txs
        stx     $800D
        stx     $0403
        stx     $0400
        stx     $0402
        stx     $800F
        stx     $8000
        ldy     #$1E
LF945:  stx     $21,y
        dey
        bpl     LF945
        lda     #$EF
        sta     $800C
        lda     #$7F
        sta     $800E
        lda     #$90
        sta     $800E
        lda     #$0B
        sta     $10
        cli
        ldx     #$28
LF960:  jsr     LF969
        dex
        bne     LF960
        jmp     LFAE3

LF969:  lda     #$FF
        sta     $8009
LF96E:  lda     $800D
        and     #$20
        beq     LF96E
        lda     $8000
        eor     #$02
        sta     $8000
        rts

        sta     $0F
        lda     #$10
        sta     $800D
        lda     $8000
        and     #$04
        bne     LF995
        lda     #$CD
        sta     $800C
        lda     #$FF
        sta     $15
LF995:  lda     $0F
        rti

LF998:  jsr     LFCD2
        lda     $01
        and     #$40
        beq     LF9A7
        jsr     LFD06
        jsr     LFCF9
LF9A7:  lda     $01
        and     #$BF
        beq     LF9B4
        lda     #$00
        sta     $0B
        jmp     LFCB0

LF9B4:  jsr     LFCC8
        jsr     LFD06
        lda     #$08
        sta     $06
LF9BE:  lda     $8000
        tay
        eor     $8000
        and     #$20
        bne     LF9BE
        tya
        and     #$20
        beq     LF9F9
        jsr     LFCA8
        ror     $07
        lda     #$6F
        ror     ;a
        ror     ;a
        ror     ;a
        sta     $800C
        ldx     #$0B
LF9DD:  dex
        bne     LF9DD
        jsr     LFCD2
        ldx     #$0A
LF9E5:  dex
        bne     LF9E5
        lda     #$ED
        sta     $800C
        dec     $06
        bne     LF9BE
        jsr     LFCF9
        lda     #$00
        sta     $0B
        rts

LF9F9:  lda     #$03
        jsr     LFCF4
        jsr     LFA04
        jmp     LFCDC

LFA04:  ldx     #$0A
LFA06:  dex
        bne     LFA06
        rts

LFA0A:  lda     $800F
        ldy     $09
        cpy     #$5F
        bne     LFA15
        ora     #$12
LFA15:  and     #$FB
        sta     $800F
        lda     $8000
        ora     #$08
        sta     $8000
        jsr     LFA6D
        lda     $23
        bne     LFA2B
        sta     $01
LFA2B:  rts

LFA2C:  lda     $09
        sta     $02
        lda     $23
        bpl     LFA3F
        lda     $1D
        beq     LFA3C
        jsr     LFDE5
        rts

LFA3C:  jmp     LFDA3

LFA3F:  lda     $8000
        bit     $16
        bvc     LFA49
        and     #$F7
        !byte   $2C
LFA49:  ora     #$08
        sta     $8000
        lda     $1E
        beq     LFA55
        jsr     LFE69
LFA55:  jsr     LF818
        lda     $23
        bne     LFA63
        ldx     $01
        bne     LFA64
        inx
        stx     $23
LFA63:  rts

LFA64:  ldx     #$FF
        stx     $23
        inx
        stx     $01
        beq     LFA2C
LFA6D:  lda     $09
        sta     $02
        jsr     LF818
        rts

LFA75:  jsr     LFCE2
        bcc     LFA75
        jsr     LFCD5
LFA7D:  lda     $8000
        and     #$20
        beq     LFA7D
        lda     #$01
        sta     $8009
LFA89:  lda     $8000
        and     #$10
        beq     LFAAE
        lda     $800D
        and     #$20
        beq     LFA89
        jsr     LFCCB
        ldx     #$0A
LFA9C:  dex
        bne     LFA9C
        jsr     LFCD5
        lda     #$40
        jsr     LFCF4
LFAA7:  lda     $8000
        and     #$10
        bne     LFAA7
LFAAE:  ldy     #$08
LFAB0:  lda     $8000
        and     #$10
        beq     LFAB0
        lda     $8000
        rol     ;a
        rol     ;a
        rol     ;a
        ror     $09
LFABF:  lda     $8000
        and     #$10
        bne     LFABF
        dey
        bne     LFAB0
        rts

LFACA:  sei
        lda     $8000
        and     #$04
        bne     LFAE3
        lda     $15
        beq     LFAD8
        bne     LFAE3
LFAD8:  cli
        jsr     LFCDC
LFADC:  lda     $8000
        and     #$04
        beq     LFADC
LFAE3:  sei
        ldx     #$00
        txs
        cli
        lda     $8000
        and     #$04
        bne     LFAE3
LFAEF:  lda     #$00
        sta     $15
        lda     #$CD
        sta     $800C
        lda     #$FF
        sta     $19
        jsr     LFCD2
        jsr     LFA75
        jsr     LFCC8
        lda     #$02
        sta     $8008
        sta     $8009
        lda     $09
        cmp     #$3F
        beq     LFB89
        cmp     #$5F
        beq     LFB89
        and     #$F0
        cmp     #$E0
        beq     LFB50
        cmp     #$F0
        beq     LFB5C
        and     #$60
        cmp     #$20
        beq     LFB3C
        cmp     #$40
        beq     LFB46
        jsr     LFD16
        cmp     #$1F
        bne     LFB39
        ldx     $23
        bne     LFB39
        dex
        stx     $1D
LFB39:  jmp     LFBC7

LFB3C:  lda     #$FF
        sta     $18
        lda     #$00
        sta     $17
        beq     LFB68
LFB46:  lda     #$FF
        sta     $17
        lda     #$00
        sta     $18
        beq     LFB68
LFB50:  jsr     LFD19
        jsr     LFF5D
        jsr     LFF15
        jmp     LFB89

LFB5C:  jsr     LFD19
        jsr     LFF5D
        jsr     LFF15
        jmp     LFBC7

LFB68:  ldx     #$00
        stx     $01
        inx
        stx     $23
        lda     $800F
        ora     #$12
        sta     $800F
        lda     #$80
        sta     $0D
        lda     $09
        and     #$1F
        sta     $0C
        eor     $0E
        bne     LFBA4
        sta     $23
        beq     LFBA4
LFB89:  lda     $01
        and     #$BF
        bne     LFB92
        jsr     LFCCB
LFB92:  lda     #$00
        sta     $17
        sta     $18
        jsr     LFA0A
        jsr     LF85C
        jsr     LF969
        jmp     LFACA

LFBA4:  lda     $23
        beq     LFBC7
LFBA8:  jsr     LFCE2
        lsr     ;a
        bcc     LFBB7
        lda     $800D
        and     #$20
        beq     LFBA8
        bne     LFBC7
LFBB7:  jsr     LFCE2
        lsr     ;a
        bcs     LFBC7
        lda     $800D
        and     #$20
        beq     LFBB7
        jmp     LFAD8

LFBC7:  jsr     LFCCB
        jsr     LFA0A
        lda     $17
        beq     LFBDE
        jsr     LF969
        lda     $8000
        and     #$04
        beq     LFBDE
        jmp     LFC53

LFBDE:  sec
        ror     $14
        jsr     LFCD2
LFBE4:  lda     $8000
        tax
        and     #$04
        bne     LFBF4
        txa
        and     #$10
        beq     LFBE4
        jmp     LFAEF

LFBF4:  jsr     LF85C
        lda     #$00
        sta     $19
LFBFB:  lda     $8000
        tax
        and     #$04
        bne     LFC06
        jmp     LFAE3

LFC06:  txa
        and     #$10
        beq     LFBFB
        lda     $17
        bne     LFC53
        lda     $18
        bne     LFC16
        jmp     LF8F7

LFC16:  jsr     LFCD5
        jsr     LFA75
        lda     $01
        and     #$BF
        bne     LFC3C
        lda     $16
        and     #$BF
        bne     LFC3C
        jsr     LFCCB
        jsr     LFCC8
        jsr     LFA2C
        jsr     LFCD2
LFC34:  lda     $8000
        tax
        and     #$04
        bne     LFC4C
LFC3C:  lda     $1D
        beq     LFC43
        jsr     LFE33
LFC43:  ldx     #$00
        stx     $1E
        stx     $1A
        jmp     LFAE3

LFC4C:  txa
        and     #$10
        beq     LFC34
        bne     LFC16
LFC53:  jsr     LFF6E
        bcs     LFC5B
        lda     #$01
        !byte   $2C
LFC5B:  lda     #$00
        sta     $0B
        lda     $1D
        bne     LFC66
        jsr     LF859
LFC66:  jsr     LFA04
        jsr     LFCC8
        lda     $0B
        beq     LFC7E
        lda     $04
        sta     $07
        lda     $03
        sta     $01
        and     #$BF
        beq     LFC85
        bne     LFCA2
LFC7E:  lda     $01
        bne     LFCA2
LFC82:  jsr     LF87B
LFC85:  jsr     LFCA8
        jsr     LFCDC
LFC8B:  jsr     LFCA8
        lda     $8000
        and     #$20
        beq     LFC8B
        jsr     LFCA8
        jsr     LF998
        lda     $01
        beq     LFC82
        jsr     LFCD2
LFCA2:  lda     #$0D
        sta     $07
        bne     LFC85
LFCA8:  lda     $8000
        and     #$04
        beq     LFCB0
        rts

LFCB0:  lda     $1D
        beq     LFCBA
        jsr     LFE59
        jmp     LFCBD

LFCBA:  jsr     LFF7C
LFCBD:  lda     #$00
        sta     $1B
        sta     $1A
        sta     $01
        jmp     LFAE3

LFCC8:  lda     #$FD
        !byte   $2C
LFCCB:  lda     #$DF
        and     $800C
        bne     LFCDE
LFCD2:  lda     #$02
        !byte   $2C
LFCD5:  lda     #$20
        ora     $800C
        bne     LFCDE
LFCDC:  lda     #$EF
LFCDE:  sta     $800C
        rts

LFCE2:  lda     $8000
        tay
        eor     $8000
        and     #$10
        bne     LFCE2
        tya
        lsr     ;a
        lsr     ;a
        lsr     ;a
        lsr     ;a
        lsr     ;a
        rts

LFCF4:  ora     $16
        sta     $16
        rts

LFCF9:  sei
LFCFA:  jsr     LFCA8
        lda     $8000
        and     #$20
        bne     LFCFA
        beq     LFD11
LFD06:  sei
LFD07:  jsr     LFCA8
        lda     $8000
        and     #$20
        beq     LFD07
LFD11:  jsr     LFCA8
        cli
        rts

LFD16:  lda     #$1F
        !byte   $2C
LFD19:  lda     #$0F
        and     $09
        sta     $0D
        cmp     #$0F
        bne     LFD26
        ldx     #$FF
        !byte   $2C
LFD26:  ldx     #$00
        stx     $1E
        rts

LFD2B:  !byte   $6F
        !byte   $9F
        !byte   $1A
        inc     $CE
        ror     $32
        clc
        !byte   $0F
        !byte   $0B
        !byte   $07
        ora     $01
LFD38:  !byte   $02
        ora     ($01,x)
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
LFD45:  cpx     #$0D
        bne     LFD51
        lda     $40
        ora     #$08
        and     #$FB
        bne     LFD70
LFD51:  bcs     LFD60
        lda     LFD2B,x
        sta     $8004
        lda     LFD38,x
        sta     $8005
        rts

LFD60:  txa
        clc
        ror     ;a
        tax
        lda     LFD86,x
        bcs     LFD6E
        eor     #$FF
        and     $40
        !byte   $2C
LFD6E:  ora     $40
LFD70:  sta     $40
        and     #$0F
        tax
        lda     LFD93,x
        bpl     LFD7F
        lda     #$10
        sta     $10
        rts

LFD7F:  and     #$5F
        bit     $40
        bpl     LFD87
        !byte   $09
LFD86:  !byte   $20
LFD87:  ora     #$40
        sta     $A000
        rts

        !byte   $0C
        !byte   $02
        ora     ($40,x)
        !byte   $80
        !byte   $20
LFD93:  ora     ($09,x)
        !byte   $80
        ora     $8080,y
        !byte   $80
        !byte   $80
        !byte   $80
        !byte   $80
        ora     ($15),y
        ora     $0D
        !byte   $80
        !byte   $1D
LFDA3:  lda     $A000
        and     #$02
        !byte   $F0
LFDA9:  sbc     $02A5,y
        bit     $40
        bvc     LFDC6
        cmp     #$41
        bcc     LFDC6
        cmp     #$5B
        bcs     LFDBC
        ora     #$20
        bne     LFDC6
LFDBC:  cmp     #$C1
        bcc     LFDC6
        cmp     #$DB
        bcs     LFDC6
        and     #$7F
LFDC6:  sta     $A001
        ldx     #$FF
        cmp     #$0D
        bne     LFDE4
        lda     $40
        and     #$20
        beq     LFDE4
        ldy     #$04
LFDD7:  stx     $8009
LFDDA:  lda     $800D
        and     #$20
        beq     LFDDA
        dey
        bpl     LFDD7
LFDE4:  rts

LFDE5:  lda     $1A
        bmi     LFE26
        ldx     $02
        cpx     #$0D
        beq     LFE0C
        and     #$01
        bne     LFDF6
        txa
        lsr     ;a
        !byte   $2C
LFDF6:  txa
        asl     ;a
        eor     $1B
        clc
        adc     #$05
        sta     $1B
        inc     $1A
        ldx     #$05
        cpx     $1A
        beq     LFE0D
        inx
        cpx     $1A
        beq     LFE1C
LFE0C:  rts

LFE0D:  lda     #$45
        cmp     $1B
        bne     LFE0C
        lda     #$0C
LFE15:  sta     $12
        lda     #$FD
        sta     $1A
        rts

LFE1C:  lda     #$F2
        cmp     $1B
        bne     LFE0C
        lda     #$0E
        bne     LFE15
LFE26:  tay
        iny
        beq     LFE32
        sty     $1A
        iny
        iny
        lda     $02
        sta     ($12),y
LFE32:  rts

LFE33:  lda     $1A
        bmi     LFE49
        lda     $1B
        ldx     #$1A
LFE3B:  dex
        bmi     LFE5C
        cmp     LFF1F,x
        bne     LFE3B
        jsr     LFE59
        jmp     LFD45

LFE49:  lda     $1B
        cmp     #$45
        bne     LFE55
        jsr     LFF5D
        jmp     LFE59

LFE55:  cmp     #$F2
        bne     LFE5C
LFE59:  lda     #$00
        !byte   $2C
LFE5C:  lda     #$03
        sta     $10
        lda     #$00
        sta     $1A
        sta     $1B
        sta     $1D
        rts

LFE69:  ldx     $1A
        bpl     LFE6F
LFE6D:  rts

LFE6E:  inx
LFE6F:  lda     LFF39,x
        bpl     LFE6D
        tay
        iny
        beq     LFEBB
        iny
        beq     LFEA8
        iny
        beq     LFE90
        lda     #$20
        cmp     $02
        beq     LFE6D
LFE84:  jsr     LFE6E
        beq     LFEB6
        cmp     $02
        beq     LFE9F
        inx
        bne     LFE84
LFE90:  jsr     LFE6E
        bne     LFE96
        rts

LFE96:  cmp     $02
        beq     LFE9F
        inx
        bne     LFE90
        beq     LFEB6
LFE9F:  inx
        lda     LFF39,x
        bmi     LFEB8
        sta     $1A
        rts

LFEA8:  lda     #$1F
        cmp     $02
        bcc     LFEB6
        lda     $02
        jsr     LFEE9
        jsr     LFEFD
LFEB6:  ldx     #$FF
LFEB8:  stx     $1A
        rts

LFEBB:  lda     $02
        ldx     $00
        bmi     LFEE8
        beq     LFEDD
        jsr     LFEF1
        bcs     LFED2
        ldx     #$FF
        stx     $00
        sec
        sbc     #$26
        jmp     LFEE9

LFED2:  lda     #$FE
        sta     $00
        lda     $1F
        sbc     #$30
        jmp     LFEE9

LFEDD:  jsr     LFEF1
        bcs     LFEE8
        sta     $1F
        lda     #$01
        sta     $00
LFEE8:  rts

LFEE9:  sta     $0D
        jsr     LFF5D
        jmp     LFEB6

LFEF1:  cmp     #$30
        bcc     LFEFB
        cmp     #$3A
        bcs     LFEFB
        clc
        rts

LFEFB:  sec
        rts

LFEFD:  jsr     LFF0E
        !byte   $90
LFF01:  !byte   $0B
        txa
        bmi     LFF57
        lda     $0C
        sta     $24,x
        lda     $0D
        sta     $23,x
LFF0D:  rts

LFF0E:  ldx     #$08
        lda     #$24
        jmp     LFF9E

LFF15:  jsr     LFF0E
        bcs     LFF1E
        ldx     #$FF
        stx     $23,y
LFF1E:  rts

LFF1F:  !byte   $5C
        lsr     $6B09
        !byte   $07
        and     $1533,x
        !byte   $22
        rol     ;a
        !byte   $27
        eor     $F2
        cmp     $9E
        cmp     $EBE6
        eor     ($4F),y
        !byte   $37
        !byte   $EF
        sta     $0D
        !byte   $62
        !byte   $6E
LFF39:  !byte   $FC
        !byte   $42
        php
LFF3C:  bvc     LFF3C
        eor     $0C,x
        brk
        sbc     $162D,x
        brk
        !byte   $FC
        and     ($FF),y
        !byte   $32
        !byte   $FF
        eor     ($FF,x)
        !byte   $42
        !byte   $FF
        brk
        !byte   $FC
        !byte   $52
        !byte   $FF
        !byte   $50
LFF53:  !byte   $FF
        !byte   $57
        !byte   $FF
        brk
LFF57:  jsr     LF969
        jmp     LFF57

LFF5D:  jsr     LFF67
        bcs     LFF66
        ldx     #$FF
        stx     $2B,y
LFF66:  rts

LFF67:  lda     #$2C
        ldx     #$0A
        jmp     LFF9E

LFF6E:  jsr     LFF67
        bcs     LFF7B
        ldx     $36,y
        stx     $03
        ldx     $35,y
        stx     $04
LFF7B:  rts

LFF7C:  lda     $0B
        beq     LFF5D
        jsr     LFF67
        bcc     LFF93
        txa
        bmi     LFF57
        lda     $0C
        sta     $2C,x
        lda     $0D
        sta     $2B,x
        jmp     LFF95

LFF93:  tya
        tax
LFF95:  lda     $01
        sta     $36,x
        lda     $04
        sta     $35,x
        rts

LFF9E:  sta     $12
        stx     $1C
        ldx     #$FF
        ldy     #$FF
LFFA6:  iny
        cpy     $1C
        beq     LFFC1
        lda     ($12),y
        iny
        cmp     #$FF
        bne     LFFB6
        tya
        tax
        bne     LFFA6
LFFB6:  cmp     $0D
        bne     LFFA6
        lda     ($12),y
        cmp     $0C
        bne     LFFA6
        clc
LFFC1:  rts

        !byte   $FF
        brk
        ora     ($FF,x)
        ora     LFF01
        ora     LFF01
        ora     $0200
        !byte   $FF
        brk
        ora     ($FF,x)
        ora     LFF01
        ora     LFF01
        ora     $0200
        !byte   $FF
        brk
        ora     ($FF,x)
        ora     LFF01
        ora     LFF01
        ora     $0200
        !byte   $FF
        brk
        ora     ($FF,x)
        ora     LFF01
        ora     LFF01
        ora     $0200
        !byte   $FF
        brk
        ora     ($FF,x)
        ror     $F7F9,x
        sed
        !byte   $7E
        !byte   $F9
