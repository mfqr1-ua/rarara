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
InitRender:
    ; Placeholder: load tiles, turn on LCD
    call switch_off_screen
    call switch_on_screen
    ret

; Renders the current frame (map and player)
RenderFrame:
    call wait_vblank_start
    ; Placeholder: draw map and sprite here
    ret
