;******************************************************************************
;*
;*      gameplay.asm
;*
;******************************************************************************

IF !DEF(GAMEPLAY_ROUTINES)
GAMEPLAY_ROUTINES SET 1

	SECTION "Gameplay Routines",HOME

;****************************************************************************
;*                      VBLANK
;*     Called from VBLANK interrupt between frames
;*
;****************************************************************************
VBLANK:
	push af
        call CONTROLS
        call GAME
	pop af
	reti
 
;****************************************************************************
;*                      GAME
;*      Handle main gameplay logic 
;*
;****************************************************************************
; TODO: Dpad update info in player location memory (see todo in player.asm)
;       button input should not affect what calls are made, only alter player state
GAME:
        push af

        ld a, [$ff8c] ; get joy data
        and P1F_0

        jp nz, A_PRESSED ; if joy data && A button bit != 0 goto A_PRESSED
        jp GAME_CONT     ; else continue

A_PRESSED:
        call SPAWN_FROG ; TODO: this should only be done once, not here
GAME_CONT:
        call SPAWN_PLAYER ; TODO: this should only be done once, not here
        pop af
        ret

;****************************************************************************
;*                      CONTROLS
;*      Grab button input value
;*
;*      outputs:
;*              $FF8C - new value
;*              $FF8B - old value 
;*
;****************************************************************************
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
