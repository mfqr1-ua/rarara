SECTION "render", ROM0

INCLUDE "src/utils/constants.asm"

; External resources from UI module
EXPORT Tiles8p8
EXPORT TilesEnd

EXPORT InitRender
EXPORT RenderFrame
EXPORT DrawMap


WaitVBlankStart:
    ld a, [$FF44]
    cp 144
    jr nz, WaitVBlankStart
    ret

SwitchOffScreen:
    ld a, [$FF40]
    res 7, a
    ld [$FF40], a
    ret

SwitchOnScreen:
    ld a, [$FF40]
    set 7, a
    ld [$FF40], a
    ret

; Initializes tile data and screen settings
InitRender::
    call SwitchOffScreen

    ld a, [rLCDC]
    set 4, a                      ; use $8000 tile data
    ld [rLCDC], a

    ; Copy tiles into VRAM
    ld hl, Tiles8p8
    ld de, $8000
    ld bc, TilesEnd - Tiles8p8
CopyTiles:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, c
    or b
    jr nz, CopyTiles

    ; Draw initial map in the background
    ld hl, $9800
    ld a, [CurrentMapPtr]
    ld e, a
    ld a, [CurrentMapPtr+1]
    ld d, a
    ld b, MAP_HEIGHT
RowLoop:
    ld c, MAP_WIDTH
ColLoop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, ColLoop
    ld a, l
    add a, $20 - MAP_WIDTH
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec b
    jr nz, RowLoop

    call SwitchOnScreen
    ret

; Renders the current frame (map and player)
RenderFrame::
    call WaitVBlankStart
    ; Placeholder for additional rendering
    ; Restore tile at previous player position
    ld a, [PlayerPrevY]
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    ld d, h
    ld e, l                  ; DE = y*4
    ld a, [PlayerPrevY]
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl               ; HL = y*16
    add hl, de               ; HL = y*20
    ld a, [PlayerPrevX]
    ld e, a
    ld d, 0
    add hl, de               ; HL = tile offset
    ld a, [CurrentMapPtr]
    ld e, a
    ld a, [CurrentMapPtr+1]
    ld d, a
    add hl, de
    ld b, [hl]               ; B = original tile

    ; Compute VRAM address for previous position
    ld a, [PlayerPrevY]
    ld l, a
    ld h, 0
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h                    ; HL = 32 * prevY
    ld a, [PlayerPrevX]
    ld e, a
    ld d, 0
    add hl, de
    ld de, $9800
    add hl, de
    ld a, b
    ld [hl], a              ; restore background tile

    ; Draw player at current position
    ld a, [PlayerY]
    ld l, a
    ld h, 0
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h                    ; HL = 32 * Y
    ld a, [PlayerX]
    ld e, a
    ld d, 0
    add hl, de
    ld de, $9800
    add hl, de
    ld a, MT_PLAYER
    ld [hl], a              ; draw player tile
    ret

; Draws the current map pointed by CurrentMapPtr to the background
DrawMap::
    ld hl, $9800
    ld a, [CurrentMapPtr]
    ld e, a
    ld a, [CurrentMapPtr+1]
    ld d, a
    ld b, MAP_HEIGHT
.RowLoop:
    ld c, MAP_WIDTH
.ColLoop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, .ColLoop
    ld a, l
    add a, $20 - MAP_WIDTH
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec b
    jr nz, .RowLoop
    ret
