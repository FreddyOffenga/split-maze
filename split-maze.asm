; Outline 2k19
; F#READY may 2019

; could become a moving maze filled screen...
; and yeah, it works! :)

; 0.1 first stable version 127 bytes, optimized to 109 bytes
; 0.2 try with different screen width
; 0.3 creative DL

	org $80

SCR_MEM		= $4000
LAST_LINE	= 16
SCROLBITS	= $20		; vscroll on
DL_SIZE		= 19		; dl length

DL_MEM
	dta $46+SCROLBITS
scr_ptr
	dta a(SCR_MEM)
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $06+SCROLBITS
	dta $07
; DL_MEM + 17
	dta $41, a(DL_MEM)

; !!! the following 20 bytes are overwritten by a DL copy !!!

main	
	dec 559

	lda #0
	sta 708
	sta 561
		
	lda #226
	sta 756

	lda #<DL_MEM
	sta 560

	ldx #19
copy_half
	lda DL_MEM,x
	sta DL_MEM+17,x
	dex
	bpl copy_half

repeat
		
wt
	asl
	adc 20

	and #%10110010
;	sta $d01f
	ora #%00001000	
	sta $d40a
	sta $d019
;	eor #$f8
;	sta $d016
;	sta $d01a
	
	lda $d40b
no_middle
	cmp #130
	bne wt
	ldx #%00000000	
	stx $d401

jiffy
	lda 20
	and #7
	sta $d405
	bne wt
	
; maze line filler

	ldx #15
fill_maz	
	lda $d20a	; random
	lsr
	sta $d201
	and #%00000001
	ora #%11000110	
	sta SCR_MEM+(LAST_LINE*15),x
	dex
	bpl fill_maz

; move up
		
	ldy #0
move_up
	lda SCR_MEM+16,y
	sta (scr_ptr),y
	iny
	bne move_up

	beq repeat
		 
; 37 bytes, can this be generated in a shorter routine?
; no, but maybe a copy of the second half...

	run main