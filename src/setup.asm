;******************************************************************************
;*
;*      Subroutines.asm
;*
;******************************************************************************

INCLUDE "tiles.asm"

IF !DEF(SUBROUTINES)
SUBROUTINES SET 1

	SECTION "Support Routines",HOME

CLEAR_MAP:
        ld	hl,_SCRN0	        ; _SCRN0 = $9800, first point on screen
	ld	bc,$3FF		        ; counter for 32*32 tiles
CLEAR_MAP_LOOP:
	ld	a,0                     ; load 0 into a (tile 0 is blank)
        ld	[hl+],a		        ; put tile 0 onto hl, increment hl
        dec	bc	                ; decrement tile counter
        ld	a,b
        or	c
        jr	nz,CLEAR_MAP_LOOP       ; if B or C != 0 then loop
        ret

LOAD_TILES:
	ld	hl,CHAPO_TILES
	ld	de, _VRAM
	ld	bc,19*16	        ; 9 tiles, 16B each
LOAD_TILES_LOOP:
        ld	a,[hl+]	                ; get a byte from our tiles, and increment.
        ld	[de],a	                ; put that byte in VRAM and
        inc	de
        dec	bc
        ld	a,b		        ; if b and c != 0, this seems wrong.
        or	c
        jr	nz,LOAD_TILES_LOOP
        ret

LOAD_MAP:
	ld	hl,HELLO_MAP            ; pointer to byte of map
	ld	de,_SCRN0	        ; _SCRN0 = $9800, first point on screen
	ld	c,18   	                ; tile counter
LOAD_MAP_LOOP:
        ld	a,[hl+]	                ; grab current map byte, increment hl
        ld	[de],a	                ; put the byte onto the screen
        inc	de		        ; move to next point on screen
        dec	c                       ; decrement tile counter
        jr	nz,LOAD_MAP_LOOP	; if tile counter != 0 then loop
        ret

;*** End Of File ***
ENDC
