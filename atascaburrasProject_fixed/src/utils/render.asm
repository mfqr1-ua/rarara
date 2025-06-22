SECTION "render", ROM0

INCLUDE "src/utils/constants.asm"

; External resources from UI module
EXPORT Tiles8p8
EXPORT TilesEnd

EXPORT InitRender
EXPORT RenderFrame
EXPORT DrawMap
EXPORT DisplayWinMessage


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
    call WaitVBlankStart
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

; Displays "YOU WIN" using the window layer
DisplayWinMessage::
    ; Wait for VBlank before modifying VRAM
    call WaitVBlankStart
    call SwitchOffScreen

    ; Write window tilemap
    ld hl, WinWindowMap
    ld de, $9C00                ; window tile map
    ld b, WinWindowMapRows
.row_loop:
    ld c, WinWindowMapCols
.col_loop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .col_loop
    ld a, e
    add a, 32 - WinWindowMapCols
    ld e, a
    ld a, d
    adc a, 0
    ld d, a
    dec b
    jr nz, .row_loop

    ; Position and enable the window
    ld a, 40                    ; Y position (pixels)
    ld [rWY], a
    ld a, 39                    ; X position (pixels) = 4 tiles + 7
    ld [rWX], a
    ld a, [rLCDC]
    set 5, a                   ; enable window
    set 6, a                   ; window tile map at $9C00
    ld [rLCDC], a

    call SwitchOnScreen
    ret

WinMessage:
    db TILE_Y, TILE_O, TILE_U, MT_FLOOR, TILE_W, TILE_I, TILE_N
DEF WinMessageLen = @-WinMessage

; Tile map for the win window (11x5)
WinWindowMap:
    db TILE_UI_TL
    REPT 9
        db TILE_UI_HOR
    ENDR
    db TILE_UI_TR
    db TILE_UI_VERT, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_VERT
    db TILE_UI_VERT, TILE_UI_GREY, TILE_Y, TILE_O, TILE_U, MT_FLOOR, TILE_W, TILE_I, TILE_N, TILE_UI_GREY, TILE_UI_VERT
    db TILE_UI_VERT, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_GREY, TILE_UI_VERT
    db TILE_UI_BL
    REPT 9
        db TILE_UI_HOR
    ENDR
    db TILE_UI_BR
DEF WinWindowMapCols = 11
DEF WinWindowMapRows = 5
