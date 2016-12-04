;******************************************************************************
;*
;*      player.asm
;*
;******************************************************************************

IF !DEF(PLAYER_DEF)
PLAYER_DEF SET 1

; Player Macros
PC_Y EQU _RAM
PC_X EQU PC_Y + 1

        SECTION "Player Routines",HOME

LOAD_PLAYER:
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

ENDC
