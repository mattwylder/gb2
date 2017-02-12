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
	;to OAM from RAM
        
        call CONTROLS
        cp $10
        jp nz, A_PRESSED
A_NOT_PRESSED:
        jp VBLANK_CONT        
A_PRESSED:
        call DRAW_SPRITE
VBLANK_CONT:
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
