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