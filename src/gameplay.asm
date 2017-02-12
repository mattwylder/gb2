;******************************************************************************
;*
;*      gameplay.asm
;*
;******************************************************************************

IF !DEF(GAMEPLAY_ROUTINES)
GAMEPLAY_ROUTINES SET 1

	SECTION "Gameplay Routines",HOME
; TODO: Dpad updates info in player location block (see todo in player.asm)
; button input should not affect what calls are made, only alter player state


VBLANK:
	push af
        ld b, 1
	;to OAM from RAM
        
        call CONTROLS
        ld a, [$ff8c]
        cp $10
        jp nz, A_NOT_PRESSED
A_PRESSED:
        call DRAW_FROG
A_NOT_PRESSED:
        call DRAW_PLAYER
        jp VBLANK_CONT        
VBLANK_CONT:
	pop af
	reti

CONTROLS:
        push bc
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
        pop bc
	ret

ENDC
