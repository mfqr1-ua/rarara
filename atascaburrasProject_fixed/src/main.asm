INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"

INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start::
    call InitRender
    call InitGameSystem

.loop:
    call UpdateGameSystem
    ld a, [GameOver]
    or a
    jr nz, .end
    call RenderFrame
    jp .loop

.end:
    jr .end ; halt on game completion
