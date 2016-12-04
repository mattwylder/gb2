
;******************************************************************************
;* Subroutines
;******************************************************************************

INCLUDE "tile/chapo_tile.asm"

IF !DEF(subroutines)


	SECTION "Support Routines",HOME

; This was in the Hello World I downloaded, but it seems wasteful to check the
; 	current scanline every CPU cycle.
WAIT_VBLANK:
	ldh	a,[rLY]		      ;get current scanline
	cp	$91			        ;Are we in v-blank yet?
	jr	nz,WAIT_VBLANK	;do while A-91 != 0
	ret

CLEAR_MAP:
	ld	hl,_SCRN0		;_SCRN0 = $9800, first point on screen
	ld	bc,$3FF		;counter for 32*32 tiles
CLEAR_MAP_LOOP:
	ld	a,0			    ;load 0 into a (tile 0 is blank)
  ld	[hl+],a		  ;put tile 0 onto hl, increment hl
  dec	bc			    ;decrement tile counter
  ld	a,b
  or	c
  jr	nz,CLEAR_MAP_LOOP ;if B or C != 0 then loop
  ret

LOAD_TILES:
	ld	hl,CHAPO_TILES
	ld	de, _VRAM
	ld	bc,19*16	  ;9 tiles, 16B each
LOAD_TILES_LOOP:
  ld	a,[hl+]	  ;get a byte from our tiles, and increment.
  ld	[de],a	  ;put that byte in VRAM and
  inc	de
  dec	bc
  ld	a,b		    ;if b and c != 0, this seems wrong.
  or	c
  jr	nz,LOAD_TILES_LOOP
  ret

LOAD_MAP:
	ld	hl,HELLO_MAP  ;pointer to byte of map
	ld	de,_SCRN0	    ;_SCRN0 = $9800, first point on screen
	ld	c,18   	      ;tile counter
LOAD_MAP_LOOP:
  ld	a,[hl+]	      ;grab current map byte, increment hl
  ld	[de],a	      ;put the byte onto the screen
  inc	de		        ;move to next point on screen
  dec	c             ;decrement tile counter
  jr	nz,LOAD_MAP_LOOP	;if tile counter != 0 then loop
  ret

STAGE_OAM:
	ld hl, _RAM
	ld [hl], 16
	inc hl
	ld [hl], 16
	inc hl
	ld [hl], 1
	inc hl
	ld [hl], %0000
	inc hl
	ret

VBLANK:
	push af

	;to OAM from RAM
  ld de, _OAMRAM
	ld hl, _RAM

	;Load Y Position
	ld a, [hl]
	ld [de], a
	inc de
	inc hl

	;Load X Position
	ld a, [hl]
	ld [de], a
	inc de
	inc hl

	;Load Tile number
	ld a, [hl]
	ld [de], a
	inc de
	inc hl

	;Load Extra flags
	ld a, [hl]
	ld [de], a

	;Return
	pop af
	reti


READ_BUTTONS:
	ld a, $20
	ld [$ff00], a

        ;Debounce
	ld a, [$ff00]
	ld a, [$ff00]
	cpl
	and $0f
	swap a
	ld b, a
	ld a, $10
	ld [$ff00], a

        ;More Debounce
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	cpl
	and $0f
	or b
	ld b, a
	ld a, [$ff8b]
	xor b
	and b
	ld [$ff8c], a
	ld a, b
	ld [$ff8b],a
	ld a, $30
	ld [$ff00], a
	reti


;************************************************************
;* tile map

SECTION "Map",HOME

HELLO_MAP:
  DB $01,$00,$00,$00,$00,$00,$00
	DB $02

;*** End Of File ***
ENDC
