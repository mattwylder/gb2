;******************************************************************************
;*	Header.asm
;*
;******************************************************************************
INCLUDE	"inc/hardware.inc"
INCLUDE "subroutines.asm"

;******************************************************************************
;*	cartridge header
;******************************************************************************

	SECTION	"Org $00",HOME[$00]
RST_00:
	jp	$100

	SECTION	"Org $08",HOME[$08]
RST_08:
	jp	$100

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	jp VBLANK

	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	jp READ_BUTTONS

	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do not modify or the program will not run)
	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	DB "PLANE      "
		 ;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, leave blank)
	DB	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	DB	$00	; $00 - DMG
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color cartridges are at least $19)
	DB	$00	; $00 - ROM Only

	; $0148 (ROM size)
	DB	$00	; $00 - 256Kbit = 32Kbyte = 2 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$00	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00


;******************************************************************************
;*	Program Start
;******************************************************************************

	SECTION "Program Start",HOME[$0150]

Start:

	di                      ; disable interrupts
	ld	 sp,$FFFE       ; set the stack to $FFFE

	ld	 a,0
	ldh	 [rLCDC],a	; turn off LCD

	call CLEAR_MAP	        ; clear the BG map
	call LOAD_TILES	        ; load up our tiles
;	call LOAD_MAP	        ; load up our map
 call STAGE_OAM

	ld	 a,%11100100	; load a normal palette up 11 10 01 00 - dark->light
	ldh	 [rBGP],a	; load the palette
	ldh  [rOBP0], a

	ld	 a,%10010011	;  =$91
	ldh	 [rLCDC],a      ; turn on the LCD, BG, etc

	ld a, $01               ; $01 enables v-blank interrupts, joypad
        ld hl, $FFFF
	ld [hl], a

	ei		        ; enables interrupts

Main:
	halt                    ; Stop system clock, return when interrupted
	nop                     ; line after halt will be run twice, nop protects for that

	jp     Main

