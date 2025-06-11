INCLUDE "src/utils/constants.asm"

; Use tiles and first map from the UI module

; Allow other modules to call these routines
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
    ; Placeholder: load tiles, turn on LCD
    ; turn off LCD before touching VRAM
    call switch_off_screen

    ; use tile data at $8000 (set LCDC bit 4)
    ld a, [rLCDC]
    set 4, a
    ld [rLCDC], a

    ; clear tile data at $8000-$97FF so tile 0 is blank
    xor a
    ld hl, $8000
    ld bc, $1800
.clear_tiles:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .clear_tiles

    ; load built-in tiles into VRAM
    ld hl, $8000
    ld de, Tiles8p8
    ld b, (TilesEnd - Tiles8p8) / 8    ; number of tiles defined
.tile_loop:
    ld c, 8
.tile_row:
    ld a, [de]
    inc de
    ld [hl+], a        ; plane 0
    ld [hl+], a        ; plane 1 (duplicate for visibility)
    dec c
    jr nz, .tile_row
    dec b
    jr nz, .tile_loop

    ; clear background map at $9800-$9BFF
    xor a                 ; value 0
    ld hl, $9800
    ld bc, $0400
.clear_map:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .clear_map

    ; copy Map1 into top-left of background map
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
    ; skip the rest of the hardware row (32 bytes total)
    ld a, l
    add a, $20 - MAP_WIDTH
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec b
    jr nz, .row_loop

    ; re-enable LCD
    call switch_on_screen
    ret

; Renders the current frame (map and player)
RenderFrame::
    call wait_vblank_start
    ; Placeholder: draw map and sprite here
    ret