.setcpu "65C02"

.include "lynx.inc"

.segment "CODE"
.org $0200

START:
	ldy MAPCTL
	lda #ROM_SPACE
	sta MAPCTL

	ldy	#$ff
	ldx	#$ff
	txs
read2nd:
    inx
	lda	RCART0
	sta $FE00,x
	dey
	bne	read2nd
	jmp	$FE00
End: