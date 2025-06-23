SECTION "GameSystem", ROM0

; Access state variables and map data

INCLUDE "src/utils/constants.asm"

InitGameSystem::
    xor a
    ld [MapIndex], a           ; MapIndex ← 0
    ld a, 1
    ld [PlayerX], a            ; PlayerX   ← 1 (start inside map)
    ld [PlayerPrevX], a        ; initial previous position
    ld a, 1
    ld [PlayerY], a            ; PlayerY   ← 1
    ld [PlayerPrevY], a

    ld hl, Map1                ; HL ← dirección de Map1

    ld a, l                    ; A ← byte bajo de HL
    ld [CurrentMapPtr], a      ; almacena L en CurrentMapPtr
    ld a, h                    ; A ← byte alto de HL
    ld [CurrentMapPtr+1], a    ; almacena H en CurrentMapPtr+1
    ld hl, EnemyPosTable
    ld a, [hl+]
    ld [Enemy1X], a
    ld a, [hl+]
    ld [Enemy1Y], a
    ld a, [hl+]
    ld [Enemy2X], a
    ld a, [hl+]
    ld [Enemy2Y], a
    ld a, [hl+]
    ld [Enemy3X], a
    ld a, [hl]
    ld [Enemy3Y], a
    xor a
    ld [GameOver], a
    ld [MoveCooldown], a

    ret

UpdateGameSystem::
    ; Save current position
    ld a, [PlayerX]
    ld [PlayerPrevX], a
    ld a, [PlayerY]
    ld [PlayerPrevY], a

    ; Handle movement cooldown
    ld hl, MoveCooldown
    ld a, [hl]
    or a
    jr z, ReadInput
    dec [hl]
    jp UpdateReturn
ReadInput:

    ; Read directional input
    ld a, JOY_SELECT_DPAD
    ld [rJOYP], a
    ld a, [rJOYP]
    ld b, a                     ; Guarda el valor de entrada para pruebas

    ; Move left if pressed (bit cleared)
    bit 1, b
    jr nz, CheckRight
    ld hl, PlayerX
    ld a, [hl]
    cp 1
    jr z, CheckRight
    dec a                      ; candidate X
    ld d, a
    ld a, [PlayerY]
    ld e, a                    ; D = newX, E = current Y
    push bc                    ; preserve input bits
    ld b, d
    ld c, e
    call IsWalkable
    pop bc
    or a
    jr z, CheckRight         ; blocked by wall
    ld a, d
    ld [hl], a
    ld a, PLAYER_MOVE_DELAY
    ld [MoveCooldown], a

CheckRight:
    ; Move right if pressed (bit cleared)
    bit 0, b
    jr nz, CheckUp
    ld hl, PlayerX
    ld a, [hl]
    cp MAP_WIDTH-1
    jr z, CheckUp
    inc a                      ; candidate X
    ld d, a
    ld a, [PlayerY]
    ld e, a
    push bc
    ld b, d
    ld c, e
    call IsWalkable
    pop bc
    or a
    jr z, CheckUp
    ld a, d
    ld [hl], a
    ld a, PLAYER_MOVE_DELAY
    ld [MoveCooldown], a

CheckUp:
    ; Move up if pressed (bit cleared)
    bit 2, b
    jr nz, CheckDown
    ld hl, PlayerY
    ld a, [hl]
    cp 1
    jr z, CheckDown
    dec a                      ; candidate Y
    ld e, a
    ld a, [PlayerX]
    ld d, a
    push bc
    ld b, d
    ld c, e
    call IsWalkable
    pop bc
    or a
    jr z, CheckDown
    ld a, e
    ld [hl], a
    ld a, PLAYER_MOVE_DELAY
    ld [MoveCooldown], a

CheckDown:
    ; Move down if pressed (bit cleared)
    bit 3, b
    jr nz, UpdateDone
    ld hl, PlayerY
    ld a, [hl]
    cp MAP_HEIGHT-1
    jr z, UpdateDone
    inc a                      ; candidate Y
    ld e, a
    ld a, [PlayerX]
    ld d, a
    push bc
    ld b, d
    ld c, e
    call IsWalkable
    pop bc
    or a
    jr z, UpdateDone
    ld a, e
    ld [hl], a
    ld a, PLAYER_MOVE_DELAY
    ld [MoveCooldown], a

UpdateDone:
    call CheckEnemyCollision
    ; If the player reaches the bottom-right corner, switch maps
    ld a, [PlayerX]
    cp MAP_WIDTH-1
    jr nz, .check_exit
    ld a, [PlayerY]
    cp MAP_HEIGHT-1
    jr nz, .check_exit
    jr .change_map


.check_exit:
    ; Otherwise, check if the tile is an explicit exit
    ld a, [PlayerX]
    ld b, a
    ld a, [PlayerY]
    ld c, a
    call GetTileAt
    cp MT_EXIT
    jr z, .change_map

    ; Additionally, switch maps when standing to the left of an exit tile
    ld a, [PlayerX]
    cp MAP_WIDTH-1            ; Ensure within bounds
    jp z, UpdateReturn
    inc a                     ; check tile to the right
    ld b, a
    ld a, [PlayerY]
    ld c, a
    call GetTileAt
    cp MT_EXIT
    jp nz, UpdateReturn

.change_map:
    ld hl, MapIndex
    ld a, [hl]
    cp 0
    jr nz, .check_map2
    inc a                 ; next index -> 1
    ld [hl], a
    ld hl, Map2
    jr .load_map

.check_map2:
    cp 1
    jr nz, .check_map3
    inc a                 ; next index -> 2
    ld [hl], a
    ld hl, Map3
    jr .load_map

.check_map3:
    cp 2
    jr nz, .check_map4
    inc a                 ; next index -> 3
    ld [hl], a
    ld hl, Map4
    jr .load_map

.check_map4:
    cp 3
    jr nz, .win_game
    inc a                 ; next index -> 4
    ld [hl], a
    ld hl, Map5

.load_map:
    ld a, l
    ld [CurrentMapPtr], a
    ld a, h
    ld [CurrentMapPtr+1], a
    ld a, [MapIndex]
    ld l, a
    ld h, 0
    add hl, hl               ; *2
    ld b, h
    ld c, l                  ; BC = index*2
    add hl, hl               ; *4
    add hl, bc               ; *6
    ld de, EnemyPosTable
    add hl, de
    ld a, [hl+]
    ld [Enemy1X], a
    ld a, [hl+]
    ld [Enemy1Y], a
    ld a, [hl+]
    ld [Enemy2X], a
    ld a, [hl+]
    ld [Enemy2Y], a
    ld a, [hl+]
    ld [Enemy3X], a
    ld a, [hl]
    ld [Enemy3Y], a
    ld a, 1
    ld [PlayerX], a
    ld [PlayerPrevX], a
    ld a, 1
    ld [PlayerY], a
    ld [PlayerPrevY], a
    call DrawMap
    xor a
    ld [MoveCooldown], a
    jp UpdateReturn
.win_game:
    ld a, 1
    ld [GameOver], a
    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
UpdateReturn:
    ret

CheckEnemyCollision:
    ; Kill the player if standing on an enemy tile
    ld a, [PlayerX]
    ld b, a
    ld a, [PlayerY]
    ld c, a
    call GetTileAt
    cp MT_ENEMY
    jr z, .death

    ; Check against enemy 1
    ld a, [PlayerX]
    ld b, a
    ld a, [Enemy1X]
    cp b
    jr nz, .check_e2
    ld a, [PlayerY]
    ld b, a
    ld a, [Enemy1Y]
    cp b
    jr z, .death
.check_e2:
    ld a, [PlayerX]
    ld b, a
    ld a, [Enemy2X]
    cp b
    jr nz, .check_e3
    ld a, [PlayerY]
    ld b, a
    ld a, [Enemy2Y]
    cp b
    jr z, .death
.check_e3:
    ld a, [PlayerX]
    ld b, a
    ld a, [Enemy3X]
    cp b
    jr nz, .no
    ld a, [PlayerY]
    ld b, a
    ld a, [Enemy3Y]
    cp b
    jr z, .death
.no:
    ret
.death:
    jp Start

EnemyPosTable:
    ; Map1
    db 3,3, 5,6, 7,4
    ; Map2
    db 2,2, 10,5, 8,7
    ; Map3
    db 2,12, 5,9, 15,14
    ; Map4
    db 5,4, 12,9, 5,14
    ; Map5
    db 5,5, 8,8, 12,12

