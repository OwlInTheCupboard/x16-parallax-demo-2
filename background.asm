.include "scroll.asm"

initialise_background:
  rts

scroll_background_left:
  lda #<TILE_ADDR
  sta pixel_line_addr
  lda #>TILE_ADDR
  sta pixel_line_addr
  scroll_4bpp_tile_left
  rts
