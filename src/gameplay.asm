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
        ld b, 1
        call DRAW_SPRITE
	;to OAM from RAM
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
