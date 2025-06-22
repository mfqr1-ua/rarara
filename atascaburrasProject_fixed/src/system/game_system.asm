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
    ; Check if player stepped on an enemy tile
    ld a, [PlayerX]
    ld b, a
    ld a, [PlayerY]
    ld c, a
    call GetTileAt
    cp MT_ENEMY
    jr nz, .continue_update
    ld a, 1
    ld [GameOver], a
    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
    jp UpdateReturn

.continue_update:
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
    jr z, UpdateReturn
    inc a                     ; check tile to the right
    ld b, a
    ld a, [PlayerY]
    ld c, a
    call GetTileAt
    cp MT_EXIT
    jr nz, UpdateReturn

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
    ld a, 1
    ld [PlayerX], a
    ld [PlayerPrevX], a
    ld a, 1
    ld [PlayerY], a
    ld [PlayerPrevY], a
    call DrawMap
    xor a
    ld [MoveCooldown], a
    jr UpdateReturn
.win_game:
    ld a, 1
    ld [GameOver], a
    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
UpdateReturn:
    ret

