.include "x16.inc"
.include "macros.inc"

;This code initialises the x16 for low res graphical mode as default but can be edited for any task

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

  jmp start



VERA_INTERUPT = $01 ;$01 VSYNC, $02 Line, $04 sprite collisions, $08 AFLOW set when audio buffer below 1/4 full
VERA_SCALE = 64
VERA_L0_COLOR_DEPTH_MASK = $02 ;$00 1 bpp (1 colour), $01 2 bpp (4 colours), $02 4 bpp (16 colours), $03 8 bpp (256 colours)
VERA_L1_COLOR_DEPTH_MASK = $02
VERA_DC_VIDEO_MASK = $70 ;$10 Layer 0 enable, $20 Layer 1 enable, $40 sprites enable

TILE_ADDR = $0000

default_irq_vector: .addr 0
counter: .byte 0

.include "background.asm"

start: ;initialise game states
  sei
  jsr initialise_interupts
  jsr initialise_vera
  jsr initialise_game
  cli
  jmp main

initialise_game: ;use this for any initial conditions or loading assets in memory on loading the game(e.g. pallets, graphics etc...)
  jsr load_background ;under background.asm
  rts

custom_irq: ;game loop
  lda VERA_isr
  and #$01
  bne @update
  lda VERA_isr
  and #$02
  bne @line
  jmp @done
  @update: ;place per frame operations in here
    jsr scroll_background_left ;under background.asm
    jmp @done
  @line: ;place per line operations in here (can be removed if not using line interupts)
    jmp @done
  @done:
  jmp (default_irq_vector)

main: ;loop forever
  wai
  jmp main

initialise_vera:
  lda #VERA_INTERUPT
  sta VERA_ien
  lda #VERA_SCALE
  sta VERA_dc_hscale
  sta VERA_dc_vscale
  lda VERA_dc_video
  ora #VERA_DC_VIDEO_MASK
  sta VERA_dc_video
  lda VERA_L0_config
  ora #VERA_L0_COLOR_DEPTH_MASK
  sta VERA_L0_config
  lda VERA_L1_config
  ora #VERA_L1_COLOR_DEPTH_MASK
  sta VERA_L1_config
  lda VERA_L1_tilebase
  ora #$03
  sta VERA_L1_tilebase
  rts

initialise_interupts: ;overwrite the defaut irq handler vector with a vector to custom irq handler
  lda IRQVec
  sta default_irq_vector
  lda IRQVec + 1
  sta default_irq_vector + 1

  lda #<custom_irq
  sta IRQVec
  lda #>custom_irq
  sta IRQVec + 1
  rts

test_sprite:
  .include "test_sprite.inc"
palette:
  .include "palette.inc"
