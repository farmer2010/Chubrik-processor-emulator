COLORED equ 0b00110101
MONO equ 0b00010001

KEY_UP equ 0x12
KEY_RIGHT equ 0x13
KEY_DOWN equ 0x14
KEY_LEFT equ 0x11
KEY_SPACE equ 0x20

BANK_IMAGE equ 1
BANK_DRAW equ 2


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                       ОБЩАЯ ОБЛАСТЬ                         W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 0


ldi a, display
ldi c, display_blue
ldi b, 32

clear:
st d, a
st d, c

inc a
inc c
dec b
jnz clear

jmp start

void db 0,0,0,0,0,0,0,0,0,0, 0,0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0

color db 0b00000001;00 - clear, 01 - red, 10 - blue, 11 - magenta
		 
draw_x db 5
draw_y db 5

fn_output_index db 0,0

X db		 0b00000000,
			 0b01001000,
			 0b00110000, 
			 0b00110000,
			 0b01001000,
			 0b00000000

O db		 0b00000000,
			 0b00110000,
			 0b01001000,
			 0b01001000,
			 0b00110000,
			 0b00000000

selection db 0b11111100,
			 0b10000100,
			 0b10000100,
			 0b10000100,
			 0b10000100,
			 0b11111100

indicator1 db 0;0x3A
indicator2 db 0;0x3B
terminal_input db 0;0x3C
terminal_graphics db 0;0x3D
connect db COLORED;0x3E
bank db 1;0x3F

display db          0b00000000, 0b00000000,
                    0b01001000, 0b00000000,
                    0b00110000, 0b00000000,
                    0b00110000, 0b00000000,
                    0b01001000, 0b00000000,
                    0b00000111, 0b11100000,
                    0b00000110, 0b01100000,
                    0b00000101, 0b10100000,
                    0b00000101, 0b10100000,
                    0b00000110, 0b01100000,
                    0b00000111, 0b11100000,
                    0b00000010, 0b01000000,
                    0b00000001, 0b10000000,
                    0b00000001, 0b10000000,
                    0b00000010, 0b01000000,
                    0b00000000, 0b00000000

display_blue db     0b00000000, 0b00000000,
                    0b00000000, 0b00001100,
                    0b00000000, 0b00010010,
                    0b00000000, 0b00010010,
                    0b00000000, 0b00001100,
                    0b00000111, 0b11100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000111, 0b11100000,
                    0b00110000, 0b00001100,
                    0b01001000, 0b00010010,
                    0b01001000, 0b00010010,
                    0b00110000, 0b00001100,
                    0b00000000, 0b00000000


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 1                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 1
start:

ldi d, $ + 10
st d, fn_output_index
ldi c, BANK_DRAW
ldi d, draw
jmp change_bank
hlt

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2

mask_image db 0b00000000
mask_display db 0b00000000, 0b00000000

draw:

ldi c, 0b10000000
st c, mask_image
st c, mask_display


ld a, draw_x
test a
jz skip_shift

shift_display_mask:

ld b, mask_display
ld c, mask_display + 1
shr b
rcr c
st b, mask_display
st c, mask_display + 1

dec a
jnz shift_display_mask

skip_shift:

ldi c, display
ld b, draw_y
shl b
add c, b


ldi a, 6
st a, buffer
st a, buffer + 1
;c - адрес на дисплее
ldi d, selection;d - адрес на картинке

x_cycle:

y_cycle:
ld a, d
ld b, mask_image
and a, b
jz skip_draw

ld a, c
ld b, mask_display
or a, b
st a, c
inc c

ld a, c
ld b, mask_display + 1
or a, b
st a, c
inc c

jmp skip_draw_end
skip_draw:
inc c
inc c
skip_draw_end:

inc d

ld a, buffer + 1
dec a
st a, buffer + 1
jnz y_cycle


ldi a, 6
st a, buffer + 1
sub d, a
shl a;умножаем на 2
sub c, a

ld a, mask_image
shr a
st a, mask_image
ld a, mask_display
ld b, mask_display + 1
shr a
rcr b
st a, mask_display
st b, mask_display + 1

ld a, buffer
dec a
st a, buffer
jnz x_cycle


ldi c, BANK_IMAGE
ld d, fn_output_index
jmp change_bank

.bank 3
