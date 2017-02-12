;******************************************************************************
;*
;*      gameplay.asm
;*
;******************************************************************************

IF !DEF(GAMEPLAY_ROUTINES)
GAMEPLAY_ROUTINES SET 1

	SECTION "Gameplay Routines",HOME
; TODO: Dpad updates info in player location block (see todo in player.asm)
;       button input should not affect what calls are made, only alter player state

; TODO: VBLANK should only
;       call CONTROLS
;       call GAME   

VBLANK:
	push af
        call CONTROLS
        call GAME
	pop af
	reti

GAME:
        push af
        ld a, [$ff8c]
        cp $10
        jp nz, A_NOT_PRESSED ; This logic is backwards
                             ; still don't really understand nz
                             ; this responds to DP-R, not A
A_PRESSED:
        call SPAWN_FROG
        jp GAME_CONT        
A_NOT_PRESSED:
        call SPAWN_PLAYER
GAME_CONT:
        pop af
        ret

CONTROLS:
        push bc ; TODO: Does pushing / popping bc really belong here?
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
