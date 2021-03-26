.macro _scroll_tile_left tile_addr, tile_width, tile_height, pixel_size
  lda #<tile_addr
  sta ZP_PTR_1
  lda #>tile_addr
  sta ZP_PTR_1+1
  lda #tile_width/2
  sta ZP_PTR_2
  lda #tile_height
  sta ZP_PTR_3
  lda #pixel_size
  sta ZP_PTR_4
  jsr scroll_tile_left
.endmacro


scroll_shift_left: ;ZP_PTR_1 set to first pixel of line, x to length of line (1 indexed)
  clc
  ldy #0
  lda (ZP_PTR_1),y
  rol ;load the initial bit into the carry
  txa
  dec
  tay ;load y with length -1
  @loop:
    lda (ZP_PTR_1),y
    rol
    sta (ZP_PTR_1),y
    dey
    dex
    bne @loop
  rts

scroll_pixel_line_left: ;ZP_PTR_2 equals line length
  ldy ZP_PTR_4
  @loop:
    phy
    ldx ZP_PTR_2
    jsr scroll_shift_left
    ply
    dey
    bne @loop
  rts

scroll_tile_left:
  ldy ZP_PTR_3
  @loop:
    phy
    jsr scroll_pixel_line_left
    lda ZP_PTR_2
    add_a_to_16_value ZP_PTR_1 ;macro adds a to a 16 value                               ;in this case the pixel line address (we want to jump 8 bytes each loop)
    ply
    dey
    bne @loop
  rts
