HELD_BUTTONS                equ $ff8b
LAST_HELD_BUTTONS           equ $dfff
LAST_KIRBY_STATE_BITMAP     equ $dffe
KIRBY_STATE_BITMAP          equ $ff8d
KIRBY_BIT_AIRBORNE          equ 7
BUTTON_BIT_UP               equ 6
BUTTON_BIT_A                equ 0
ORIGINAL_CODE_HOVER         equ $449a
ORIGINAL_CODE_NO_HOVER      equ $452a



SECTION "original_check_for_up_press", ROMX[$4492], BANK[1]
original_check_for_up_press::
        jp      my_up_press

SECTION "standing_in_front_of_door", ROM0[$04cd]
standing_in_front_of_door::
        jp      my_door

SECTION "not_standing_in_front_of_door", ROMX[$44be], BANK[1]
        jp      my_hovering


SECTION "my_code", ROMX[$4e00], BANK[1]
my_up_press::
.save_last_held_buttons
        ld      a, [LAST_HELD_BUTTONS]
        ld      c, a
        ldh     a, [HELD_BUTTONS]
        ld      [LAST_HELD_BUTTONS], a
.save_last_kirby_state_bitmap
        ld      a, [LAST_KIRBY_STATE_BITMAP]
        ld      d, a
        ldh     a, [KIRBY_STATE_BITMAP]
        ld      [LAST_KIRBY_STATE_BITMAP], a
.check_for_up_press
        ; replace original instructions
        ldh     a, [HELD_BUTTONS]
        ld      b, a
        bit     BUTTON_BIT_UP, a
        jr      nz, .hover
.check_if_airborne
        ld      a, d
        bit     KIRBY_BIT_AIRBORNE, a
        jr      z, .no_hover
.check_for_new_a_press
        ld      a, c
        bit     BUTTON_BIT_A, a
        jr      nz, .no_hover
        ld      a, b
        bit     BUTTON_BIT_A, a
        jr      z, .no_hover
.hover
        jp      ORIGINAL_CODE_HOVER
.no_hover
        jp      ORIGINAL_CODE_NO_HOVER


my_door::
        ldh     a, [HELD_BUTTONS]
        bit     BUTTON_BIT_UP, a
        jr      nz, .enter_door
.do_not_enter_door
        xor     a
        ret
.enter_door
        ; replace original instruction
        ld      a, [$d052]
        jp      $04d0


my_hovering::
        ldh     a, [HELD_BUTTONS]
        bit     BUTTON_BIT_A, a
        jp      z, $452a
        ; replace original instruction
        bit     1, b
        jp      nz, $452a
        jp      $44c2
