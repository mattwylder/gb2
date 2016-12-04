;******************************************************************************
;*
;*      gameplay.asm
;*
;******************************************************************************

IF !DEF(GAMEPLAY_ROUTINES)
GAMEPLAY_ROUTINES SET 1

	SECTION "Gameplay Routines",HOME

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

CONTROLS:
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
	ret

ENDC