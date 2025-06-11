INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"
INCLUDE "src/utils/render.asm"
INCLUDE "src/system/game_system.asm"
INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start:
    call InitRender
    call InitGameSystem

.loop:
    call UpdateGameSystem
    call RenderFrame
    jp .loop
