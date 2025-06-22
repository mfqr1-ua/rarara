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
; Simple AI that chases the player one step at a time
UpdateAISystem::
    ; store previous position for render restoration
    ld   a, [EnemyX]
    ld   [EnemyPrevX], a
    ld   a, [EnemyY]
    ld   [EnemyPrevY], a

    ; ----- move horizontally towards player -----
    ld   a, [EnemyX]
    ld   d, a               ; D = current X
    ld   a, [PlayerX]
    cp   d                  ; compare playerX with enemyX
    jr   z, .vert_move
    jr   c, .move_left      ; playerX < enemyX -> move left
.move_right:
    inc  d                  ; candidate X = enemyX + 1
    ld   b, d
    ld   a, [EnemyY]
    ld   c, a
    call IsWalkable         ; check wall
    or   a
    jr   z, .vert_move
    ld   a, b
    ld   [EnemyX], a
    jr   .vert_move
.move_left:
    dec  d                  ; candidate X = enemyX - 1
    ld   b, d
    ld   a, [EnemyY]
    ld   c, a
    call IsWalkable
    or   a
    jr   z, .vert_move
    ld   a, b
    ld   [EnemyX], a

.vert_move:
    ; ----- move vertically towards player -----
    ld   a, [EnemyY]
    ld   e, a               ; E = current Y
    ld   a, [PlayerY]
    cp   e
    jr   z, .check_collision
    jr   c, .move_up        ; playerY < enemyY -> move up
.move_down:
    inc  e                  ; candidate Y = enemyY + 1
    ld   b, [EnemyX]
    ld   c, e
    call IsWalkable
    or   a
    jr   z, .check_collision
    ld   a, e
    ld   [EnemyY], a
    jr   .check_collision
.move_up:
    dec  e                  ; candidate Y = enemyY - 1
    ld   b, [EnemyX]
    ld   c, e
    call IsWalkable
    or   a
    jr   z, .check_collision
    ld   a, e
    ld   [EnemyY], a

.check_collision:
    ; check collision with player
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

