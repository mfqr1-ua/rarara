INCLUDE "src/utils/constants.asm"

SECTION "AudioSystem", ROM0

EXPORT InitAudioSystem
EXPORT UpdateAudioSystem

; Internal routine to play the current note
PlayCurrentNote:
    ; Calculate index offset (index * 3)
    ld a, [CurrentNoteIndex]
    ld c, a                ; c = index
    sla a
    add a, c
    ld e, a
    ld d, 0
    ; Select normal or win sequence depending on game state
    ld a, [GameOver]
    or a
    jr z, .use_normal
    ld hl, WinNoteSequence
    jr .add_offset
.use_normal:
    ld hl, NoteSequence
.add_offset:
    add hl, de             ; HL points to entry
    ld a, [hl+]
    ld [rNR23], a          ; frequency low
    ld a, [hl+]
    or $80                 ; trigger with freq high
    ld [rNR24], a
    ld a, [hl]
    ld [NoteTimer], a      ; set duration
    ret

;--------------------------------------
; Initialise sound hardware and first note
InitAudioSystem::
    ld a, $80
    ld [rNR52], a          ; enable sound
    ld a, $77
    ld [rNR50], a          ; max volume
    ld a, $FF
    ld [rNR51], a          ; route all channels

    ld a, %01000000        ; 50% duty, length=0
    ld [rNR21], a
    ld a, $F0              ; constant volume envelope
    ld [rNR22], a

    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
    call PlayCurrentNote
    ret

;--------------------------------------
; Updates music, progressing notes when timer expires
UpdateAudioSystem::
    ld hl, NoteTimer
    ld a, [hl]
    or a
    jr z, .next
    dec [hl]
    ret
.next:
    ld hl, CurrentNoteIndex
    ld a, [hl]
    inc a
    ld b, a                ; candidate index
    ld a, [GameOver]
    or a
    jr z, .check_normal
    ld a, b
    cp WinNumNotes
    jr c, .store
    xor a
    jr .store
.check_normal:
    ld a, b
    cp NumNotes
    jr c, .store
    xor a
.store:
    ld [hl], a
    call PlayCurrentNote
    ret

; Note data: frequency low byte, high byte, duration frames
NoteSequence:
    db $06, $07, 16  ; C5
    db $39, $07, 16  ; E5
    db $59, $07, 16  ; G5
    db $83, $07, 16  ; C6
    db $59, $07, 16  ; G5
    db $39, $07, 16  ; E5
    db $06, $07, 16  ; C5
    db $59, $07, 16  ; G5
DEF NumNotes = 8

; Short victory fanfare
WinNoteSequence:
    db $06, $07, 12  ; C5
    db $39, $07, 12  ; E5
    db $59, $07, 12  ; G5
    db $83, $07, 12  ; C6
    db $59, $07, 12  ; G5
    db $39, $07, 16  ; E5
DEF WinNumNotes = 6
