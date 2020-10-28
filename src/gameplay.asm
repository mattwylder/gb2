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
GAME:
      push af

      ld hl, FRAME_COUNT
      ld a, [hl]
      inc a
      ; if FRAME_COUNT == 5
      ld b, 5
      cp b
      jp nz, GAME_CONT ; if it doesn't equal 5 jump to game_cont?

MOVE_PLAYER:
      ld a, 0
      ld [hl], a ; Reset frame counter if player has moved
      ld hl, $ff8c
      ld a, [hl] ; get joy data TODO: default value?
      ld hl, PC_DIRECTION
      ld [hl], a
      and JOY_RIGHT
      jp z, MOVE_PLAYER_RIGHT

GAME_CONT:
      call DRAW_PLAYER
      ret


        ; jump to MOVE_PLAYER
        ; increment FRAME_COUNT

        ;ld a, [$ff8c] ; get joy data
        ;and JOY_RIGHT
        ;jp nz, A_PRESSED ; if joy data && A button bit != 0 goto A_PRESSED

        ;jp GAME_CONT     ; else continue

;A_PRESSED:
;        call MOVE_PLAYER_RIGHT
;GAME_CONT:
;        call DRAW_PLAYER
;        pop af
;        ret

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
