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
PC_Y EQU _RAM
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

; TODO: subroutine SPAWN_PLAYER draws player at spawn point, facing right
;       only called on game start / level start

; TODO: refactor DRAW_PLAYER to draw player based on current player location 
;       and direction

DRAW_SPRITE:
        call DRAW_PLAYER
        call DRAW_FROG
        ret

DRAW_PLAYER:
	ld hl, _OAMRAM             ; Y position byte
	ld [hl], PC_SPAWN_Y
	inc hl                  ; X position byte
	ld [hl], PC_SPAWN_X
	inc hl                  ; tile number byte
        ld b, 1                 ; TILE NUMBER 1 = player 1 head
                                ; TODO: should this stay hardcoded? 

	ld [hl], b              ; Current tile 
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

DRAW_FROG:
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
