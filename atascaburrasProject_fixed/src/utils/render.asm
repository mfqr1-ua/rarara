SECTION "render", ROM0

INCLUDE "src/utils/constants.asm"

; External resources from UI module
EXPORT Tiles8p8
EXPORT TilesEnd

EXPORT Map1
EXPORT PlayerX
EXPORT PlayerY
EXPORT PlayerPrevX
EXPORT PlayerPrevY

EXPORT InitRender
EXPORT RenderFrame


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
    add hl, de               ; HL = Map1 offset
    ld de, Map1
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