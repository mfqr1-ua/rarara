
INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"
INCLUDE "src/utils/render.asm"
INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start:
    call InitRender

.loop:
    call RenderFrame
    jp .loop
