SECTION "Header", ROM0[$100]
    nop
    jp Start

NintendoLogo:
    ; Official Nintendo logo required by the boot ROM
    db $CE,$ED,$66,$66,$CC,$0D,$00,$0B
    db $03,$73,$00,$83,$00,$0C,$00,$0D
    db $00,$08,$11,$1F,$88,$89,$00,$0E
    db $DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
    db $BB,$BB,$67,$63,$6E,$0E,$EC,$CC
    db $DD,$DC,$99,$9F,$BB,$B9,$33,$3E

GameTitle:
    db "UNDERFLOW",0,0,0,0,0,0,0

    ; Cartridge type, ROM size and other header bytes
    db $00            ; CGB flag
    db $00,$00        ; New licensee code
    db $00            ; SGB flag
    db $00            ; Cartridge type (ROM only)
    db $00            ; ROM size (32KB)
    db $00            ; RAM size (none)
    db $01            ; Destination code (non-Japanese)
    db $33            ; Old licensee code use new licensee
    db $00            ; Mask ROM version
    db $00            ; Header checksum (fixed later)
    dw $0000          ; Global checksum (fixed later)

    ; Pad the header up to $150
    ds $150 - @
