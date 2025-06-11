INCLUDE "src/utils/constants.asm"

; External resources from UI module
EXPORT Tiles8p8
EXPORT TilesEnd
EXPORT Map1


EXPORT InitRender
EXPORT RenderFrame

SECTION "render", ROM0

wait_vblank_start:
    ld a, [$FF44]
    cp 144
    jr nz, wait_vblank_start
    ret

switch_off_screen:
    ld a, [$FF40]
    res 7, a
    ld [$FF40], a
    ret

switch_on_screen:
    ld a, [$FF40]
    set 7, a
    ld [$FF40], a
    ret

; Initializes tile data and screen settings
InitRender::
    call switch_off_screen

    ld a, [rLCDC]
    set 4, a
    ld [rLCDC], a

    xor a
    ld hl, $8000
    ld bc, $1800
.clear_tiles:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .clear_tiles

    ld hl, $8000
    ld de, Tiles8p8
    ld b, (TilesEnd - Tiles8p8) / 8
.tile_loop:
    ld c, 8
.tile_row:
    ld a, [de]
    inc de
    ld [hl+], a
    ld [hl+], a
    dec c
    jr nz, .tile_row
    dec b
    jr nz, .tile_loop

    xor a
    ld hl, $9800
    ld bc, $0400
.clear_map:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .clear_map

    ld hl, $9800
    ld de, Map1
    ld b, MAP_HEIGHT
.row_loop:
    ld c, MAP_WIDTH
.col_loop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, .col_loop
    ld a, l
    add a, $20 - MAP_WIDTH
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec b
    jr nz, .row_loop

    call switch_on_screen
    ret

; Renders the current frame (map and player)
RenderFrame::
    call wait_vblank_start
    ; Placeholder for additional rendering
    ret
