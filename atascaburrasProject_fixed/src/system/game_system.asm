SECTION "GameSystem", ROM0

InitGameSystem::
    ; initialize game-related variables
    ret

UpdateGameSystem::
    ; update game state each frame
    ret

SECTION "GameSystem", ROM0

InitGame:
    xor a
    ld [MapIndex], a
    ld a, 8
    ld [PlayerX], a
    ld [PlayerY], a
    call LoadCurrentMap
    ret

; LoadCurrentMap sets HL to point to the map data of MapIndex
LoadCurrentMap:
    ld a, [MapIndex]
    ld hl, MapPointers
    ld c, a
    ld b, 0
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld [CurrentMapPtr], hl
    ret

; UpdateGame is a placeholder for movement and collision handling
UpdateGame:
    ; here we would read input, move the player and check collisions
    ret
