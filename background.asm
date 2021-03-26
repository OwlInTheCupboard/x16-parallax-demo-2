.include "scroll.asm"

load_palette:
  VERA_SET_ADDR $1FA00, 1
  store_16_value ZP_PTR_1, palette
  ldy #0
  @loop:
    lda (ZP_PTR_1),y
    sta VERA_data0
    add_16_value ZP_PTR_1 ,1
    compare_16_value ZP_PTR_1, (palette + 64), @loop
  rts

load_test_sprite:
  VERA_SET_ADDR $F800,1
  store_16_value ZP_PTR_1, test_sprite
  ldy #0
  @loop:
    lda (ZP_PTR_1),y
    sta VERA_data0
    add_16_value ZP_PTR_1 ,1
    compare_16_value ZP_PTR_1, (test_sprite + 128), @loop
  rts


load_background:
  jsr load_palette
  jsr load_test_sprite
  lda #$10
  sta VERA_addr_bank
  ldy #0
  @yloop:
    stz VERA_addr_low
    tya
    sta VERA_addr_high
    ldx #0
    @xloop:
      lda #0
      sta VERA_data0
      sta VERA_data0
      inx
      cpx #24
      bne @xloop
    iny
    cpy #15
    bne @yloop
  rts

scroll_counter: .byte 0
scroll_background_left:
  inc scroll_counter
  lda scroll_counter
  cmp #2
  bne @done
  stz scroll_counter
  jsr load_test_sprite
  _scroll_tile_left test_sprite, 16, 16, 4 ;16x16 tile with each pixel at 4bpp
  @done:
  rts
