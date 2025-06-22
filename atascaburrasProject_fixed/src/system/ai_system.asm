INCLUDE "src/utils/constants.asm"

SECTION "AISystem", ROM0

EXPORT InitAISystem
EXPORT UpdateAISystem

;--------------------------------------
; Initialise enemy position and state
InitAISystem::
    ld a, 8
    ld [EnemyX], a
    ld [EnemyPrevX], a
    ld a, 2
    ld [EnemyY], a
    ld [EnemyPrevY], a
    xor a
    ld [EnemyDir], a
    ret

;--------------------------------------
; Very simple AI to move the enemy up and down
UpdateAISystem::
    ld   a, [EnemyX]
    ld   [EnemyPrevX], a
    ld   a, [EnemyY]
    ld   [EnemyPrevY], a

    ; Ejemplo: enemigo sube y baja entre y=2 y y=MAP_HEIGHT-2
    ld   a, [EnemyY]
    cp   2
    jr   c, .go_down
    cp   MAP_HEIGHT-2
    jr   nz, .go_up
    ; al llegar al límite superior/inferior invierte el signo
    xor  a
    ld   [EnemyDir], a      ; EnemyDir = 0↑arriba, 1↑abajo

.go_down:
    ld   a, [EnemyY]
    inc  a
    ld   [EnemyY], a
    jr   .check_collision

.go_up:
    ld   a, [EnemyY]
    dec  a
    ld   [EnemyY], a

.check_collision:
    ld   a, [EnemyX]
    ld   b, a
    ld   a, [PlayerX]
    cp   b
    jr   nz, .ret
    ld   a, [EnemyY]
    ld   b, a
    ld   a, [PlayerY]
    cp   b
    jr   nz, .ret
    ld   a, 1
    ld   [GameOver], a

.ret:
    ret

