SECTION "GameSystem", ROM0

; Access state variables and map data
EXPORT MapIndex
EXPORT PlayerX
EXPORT PlayerY
EXPORT CurrentMapPtr
EXPORT Map1

InitGameSystem::
    xor a
    ld [MapIndex], a           ; MapIndex ← 0
    ld [PlayerX], a            ; PlayerX   ← 0
    ld [PlayerY], a            ; PlayerY   ← 0

    ld hl, Map1                ; HL ← dirección de Map1

    ld a, l                    ; A ← byte bajo de HL
    ld [CurrentMapPtr], a      ; almacena L en CurrentMapPtr
    ld a, h                    ; A ← byte alto de HL
    ld [CurrentMapPtr+1], a    ; almacena H en CurrentMapPtr+1

    ret

UpdateGameSystem::
    ; placeholder for game logic
    ret
