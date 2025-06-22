SECTION "AISystem", ROM0

INCLUDE "src/utils/constants.asm"

EXPORT InitAISystem
EXPORT UpdateAISystem

;--------------------------------------
; Initialise enemy position
InitAISystem::
    ld a, MAP_WIDTH-2
    ld [EnemyX], a
    ld [EnemyPrevX], a
    ld a, MAP_HEIGHT-2
    ld [EnemyY], a
    ld [EnemyPrevY], a
    ret

;--------------------------------------
; Move enemy towards the player and
; end the game if it reaches the player
UpdateAISystem::
    ; Save current position
    ld a, [EnemyX]
    ld [EnemyPrevX], a
    ld a, [EnemyY]
    ld [EnemyPrevY], a

    ; Horizontal movement towards player
    ld a, [PlayerX]
    ld b, a            ; player X
    ld a, [EnemyX]
    cp b
    jr z, .check_vert
    jr c, .move_left
.move_right:
    ld hl, EnemyX
    ld a, [hl]
    cp MAP_WIDTH-1
    jr z, .check_vert
    inc a
    ld d, a
    ld a, [EnemyY]
    ld e, a
    ld b, d
    ld c, e
    call IsWalkable
    or a
    jr z, .check_vert
    ld [hl], d
    jr .check_vert
.move_left:
    ld hl, EnemyX
    ld a, [hl]
    cp 1
    jr z, .check_vert
    dec a
    ld d, a
    ld a, [EnemyY]
    ld e, a
    ld b, d
    ld c, e
    call IsWalkable
    or a
    jr z, .check_vert
    ld [hl], d
.check_vert:
    ; Vertical movement towards player
    ld a, [PlayerY]
    ld b, a            ; player Y
    ld a, [EnemyY]
    cp b
    jr z, .done
    jr c, .move_up
.move_down:
    ld hl, EnemyY
    ld a, [hl]
    cp MAP_HEIGHT-1
    jr z, .done
    inc a
    ld e, a
    ld a, [EnemyX]
    ld d, a
    ld b, d
    ld c, e
    call IsWalkable
    or a
    jr z, .done
    ld [hl], e
    jr .done
.move_up:
    ld hl, EnemyY
    ld a, [hl]
    cp 1
    jr z, .done
    dec a
    ld e, a
    ld a, [EnemyX]
    ld d, a
    ld b, d
    ld c, e
    call IsWalkable
    or a
    jr z, .done
    ld [hl], e
.done:
    ; Check collision with player
    ld a, [EnemyX]
    ld b, a
    ld a, [PlayerX]
    cp b
    jr nz, .ret
    ld a, [EnemyY]
    ld b, a
    ld a, [PlayerY]
    cp b
    jr nz, .ret
    ld a, 1
    ld [GameOver], a
.ret:
    ret
