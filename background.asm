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
  cmp #30
  bne @done
  stz scroll_counter
  lda #<test_sprite
  sta ZP_PTR_1
  lda #>test_sprite
  sta ZP_PTR_1+1
  lda #8
  sta ZP_PTR_2
  lda #8
  sta ZP_PTR_3
  jsr scroll_4bpp_pixel_line_left
  jsr load_test_sprite
  @done:
  rts
