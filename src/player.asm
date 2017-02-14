;******************************************************************************
;*
;*      player.asm
;*
;******************************************************************************

IF !DEF(PLAYER_DEF)
PLAYER_DEF SET 1

;******************************************************************************
;*      Macros
;******************************************************************************

; Memory Locations of stored X and Y positions
PC_IS_SPAWNED EQU _RAM
PC_Y EQU _RAM + 1
PC_X EQU PC_Y + 1

PC_TILE_COUNT EQU 6
PC_FIRST_TILE EQU 1

; Spawn Coordinates
PC_SPAWN_X EQU 50
PC_SPAWN_Y EQU 50

NF_SPAWN_X EQU 70
NF_SPAWN_Y EQU 42
NF_FIRST_TILE EQU 8
NF_TILE_COUNT EQU 8

;******************************************************************************
;*      Subroutines
;******************************************************************************
        SECTION "Player Routines",HOME

; TODO: Create a block in memory that holds info on
;       current player x
;       current player y
;       current player direction
;       maybe there's a more efficient way of handling direction

; TODO: refactor DRAW_PLAYER to draw player based on current player location 
;       and direction

;****************************************************************************
;*                           DRAW_SPRITES
;*      Look up all sprites (player, npc, etc) that should appear in
;*      the current frame
;*
;****************************************************************************
DRAW_SPRITES:
        ;call DRAW_PLAYER
        ;call DRAW_FROG
        ret

MOVE_PLAYER_RIGHT:
        ld hl, PC_X
        ld a, [hl]
        inc a
        ld [hl], a
        ret

;****************************************************************************
;*                      SPAWN_PLAYER
;*      Draw the player sprite at its spawn location
;*
;****************************************************************************
SPAWN_PLAYER:
        ld hl, PC_Y
        ld [hl], PC_SPAWN_Y

        ld hl, PC_X
        ld [hl], PC_SPAWN_X 

        ld hl, PC_IS_SPAWNED
        ld [hl], %0001

        ret

DRAW_PLAYER:
        ; TODO: remove this, call SPAWN_PLAYER in setup
        ld a, [PC_IS_SPAWNED]
        and %0001
        call z, SPAWN_PLAYER

	ld hl, _OAMRAM             ; Y position byte
        ld a, [PC_Y]
	ld [hl], a
	inc hl                  ; X position byte
        ld a, [PC_X] 
	ld [hl], a
	inc hl                  ; tile number byte

        ld b, PC_FIRST_TILE ; Note: First tile (player character's head) is offset
	ld [hl], b

        inc b                   ; Next tile
	inc hl                  ; Options byte
	ld [hl], %0000         
	inc hl                  ; Next 

        ld c, PC_SPAWN_Y
        ld a, 8
        add a, c
        ld c, a
        ld a, PC_SPAWN_X
        sub 2
        ld d, a
        ld e, 5
        call DRAW_COLUMN

        ld c, PC_SPAWN_Y
        ld a, 8
        add a, c
        ld c, a
        ld a, d
        add a, 8
        ld d, a
        ld e, 8
        call DRAW_COLUMN
        ret

;****************************************************************************
;*                           SPAWN_FROG
;*      Draw the frog sprite for the first time at its spawn location
;*
;****************************************************************************
; TODO: Refactor, separate setting the location from drawing the shape
SPAWN_FROG:
        ld b, NF_FIRST_TILE
        ld c, NF_SPAWN_Y
        ld d, NF_SPAWN_X
        ld e, $0D
        call DRAW_COLUMN

        ld c, NF_SPAWN_Y
        ld a, 8
        add a, d
        ld d, a
        ld e, $12
        call DRAW_COLUMN
        ret

; TODO: Replace register-based parameters with values above SP

; TODO: Both inout params may need to be reconsidered
;       though there was a comment that I was happy with first tile as an inout

; TODO: Why are there two labels for this func?
;       just because of the loop?
;       seems like a waste

; PARAMS:
; b - first tile (inout)
; c - Y start (inout)
; d - X start
; e - height
DRAW_COLUMN:
        ld [hl], c
        inc hl 
        ld [hl], d
        inc hl
        ld [hl], b
        inc hl
        ld [hl], %0000
        inc hl

        ; c+=8, b++
        ld a, 8
        add a, c
        ld c, a
        inc b

        ld a, b
        cp e
        jr nz, DRAW_COLUMN

        ret

ENDC
