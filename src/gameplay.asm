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

        ld a, [$ff8c]   ; TODO: Update to some kind of bit manipulation logic
        cp $10          ;       see inc/hardware.inc line 33 

        jp nz, A_NOT_PRESSED ; This logic is backwards
                             ; still don't really understand nz
                             ; this responds to DP-R, not A
A_PRESSED:
        call SPAWN_FROG ; TODO: this should only be done once, not here
        jp GAME_CONT        

A_NOT_PRESSED:
        call SPAWN_PLAYER ; TODO: this should only be done once, not here
GAME_CONT:
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
