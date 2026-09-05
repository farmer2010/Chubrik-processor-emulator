COLORED equ 0b00110101
MONO equ 0b00010001

KEY_UP equ 0x12
KEY_RIGHT equ 0x13
KEY_DOWN equ 0x14
KEY_LEFT equ 0x11
KEY_SPACE equ 0x20

BANK_MAIN equ 1
BANK_LOGIC equ 2
BANK_IMAGE equ 3
BANK_DRAW equ 4


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

void db 0,0,0,0,0,0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0

color db 0b00000001;00 - clear, 01 - red, 10 - blue, 11 - magenta
render_buffer db 0b11111100, 0b00000000,
				 0b10000100, 0b00000000,
				 0b10000100, 0b00000000,
				 0b10000100, 0b00000000,
				 0b10000100, 0b00000000,
				 0b11111100, 0b00000000

player db 0

field db 0,0,0,;1 - X, 10 - O
		 0,0,0,
		 0,0,0
		 
draw_x db 1
draw_y db 1

select_x db 1
select_y db 1

fn_output_index db 0,0

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
ld a, select_x
ld b, select_y
jmp start_draw

cycle:

ld c, connect
ld a, select_x
ld b, select_y


ldi d, KEY_UP
sub d, c
jnz up_else
	dec b
	jns move_selection
up_else:

ldi d, KEY_RIGHT
sub d, c
jnz right_else
	inc a
	ldi d, 3
	sub d, a
	jnz move_selection
right_else:

ldi d, KEY_DOWN
sub d, c
jnz down_else
	inc b
	ldi d, 3
	sub d, b
	jnz move_selection
down_else:

ldi d, KEY_LEFT
sub d, c
jnz left_else
	dec a
	jns move_selection
left_else:


ldi d, KEY_SPACE
sub d, c
jz step
jmp cycle

move_selection:
st a, buffer + 1
st b, buffer + 2
ld a, select_x
ld b, select_y

ldi c, BANK_IMAGE
ldi d, clear_selection
jmp change_bank
clear_sel_end:

ld a, buffer + 1
ld b, buffer + 2
st a, select_x
st b, select_y

start_draw:
ldi c, BANK_IMAGE
ldi d, draw_selection
jmp change_bank
draw_sel_end:
jmp cycle


step:
ldi c, BANK_LOGIC
ldi d, set_test
jmp change_bank
set_end:

ld c, player
test c
jz set_x

set_o:

ldi c, BANK_IMAGE
ldi d, draw_O
jmp change_bank

set_x:

ldi c, BANK_IMAGE
ldi d, draw_X
jmp change_bank

draw_x_end:
draw_o_end:

ld c, player
not c
st c, player


ldi c, BANK_LOGIC
ldi d, test_win
jmp change_bank


skip_set:
jmp cycle

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2


set_test:
mov c, b
shl c
add c, b
add c, a
ldi d, field
add c, d

ld d, c
test d
jnz not_free

;st c, buffer

ld d, player
test d
jz write_x

write_o:
ldi d, 10
st d, c
jmp write_o_end

write_x:
inc d;если мы здесь, в d 0
st d, c

write_o_end:
ldi d, set_end
set_return:
ldi c, BANK_MAIN
jmp change_bank

not_free:
ldi d, skip_set
jmp set_return


test_win:

clr a;0 - not win, 1 - red win, 2 - blue win
st a, buffer
;b - sum

ldi c, 3
ldi d, field
hor_cycle:
ld a, d
mov b, a
inc d

ld a, d
add b, a
inc d

ld a, d
add b, a
inc d

ldi a, 3
sub a, b
jnz hor_x_win_else
ldi a, 1
st a, buffer

hor_x_win_else:

ldi a, 30
sub a, b
jnz hor_o_win_else
ldi a, 2
st a, buffer

hor_o_win_else:

dec c
jnz hor_cycle


ld a, buffer
test a
jz not_win



hlt

not_win:
ldi c, BANK_MAIN
ldi d, skip_set
jmp change_bank

blue_win db "Blue wins!"
red_win db "Red wins!"

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 3

draw_img:;c - адрес изображения
st d, fn_output_index + 1
ldi a, 6
ldi b, render_buffer
load_image_cycle:

ld d, c
st d, b

inc c
inc b
inc b
dec a
jnz load_image_cycle

ldi d, $ + 10
st d, fn_output_index
ldi c, BANK_DRAW
ldi d, draw
jmp change_bank

ld d, fn_output_index + 1
jmp d


draw_X:;a, b - coordinates

st a, draw_x
st b, draw_y

ldi a, 0b00000001
st a, color

ldi c, X
ldi d, $ + 4
jmp draw_img

ldi c, BANK_MAIN
ldi d, draw_x_end
jmp change_bank


draw_O:

st a, draw_x
st b, draw_y

ldi a, 0b00000010
st a, color

ldi c, O
ldi d, $ + 4
jmp draw_img

ldi c, BANK_MAIN
ldi d, draw_o_end
jmp change_bank


draw_selection:

st a, draw_x
st b, draw_y

ldi a, 0b00000011
st a, color

ldi c, selection
ldi d, $ + 4
jmp draw_img

ldi c, BANK_MAIN
ldi d, draw_sel_end
jmp change_bank


clear_selection:

st a, draw_x
st b, draw_y

ldi a, 0b00000000
st a, color

ldi c, selection
ldi d, $ + 4
jmp draw_img

ldi c, BANK_MAIN
ldi d, clear_sel_end
jmp change_bank


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

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 4                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;рисование
.bank 4

draw:

ldi a, 6
ldi b, render_buffer + 1
clr c
clear_render_buffer:

st c, b

inc b
inc b
dec a
jnz clear_render_buffer


ld a, draw_x
mov b, a
shl b
shl b
add a, b
jz skip_shift
st a, buffer


ldi b, 6
ldi c, render_buffer
for_bytes:

ld a, buffer
shift_right:

ld d, c
shr d
st d, c
inc c
ld d, c
rcr d
st d, c

dec c

dec a
jnz shift_right

inc c
inc c
dec b
jnz for_bytes

skip_shift:

ldi c, display
ld b, draw_y
mov a, b
shl a
shl a
shl a
add a, b
add a, b
add c, a
ldi a, 12
st a, buffer
ldi b, render_buffer

render:

ld a, color
ldi d, 0b00000001
and a, d
jz red_end

ld d, b
ld a, c
or a, d
st a, c
red_end:

ld a, color
ldi d, 0b00000010
and a, d
jz blue_end

ldi a, 32
add c, a
ld d, b
ld a, c
or a, d
st a, c

ldi a, 32
sub c, a
blue_end:

ld a, color
test a
jnz white_end

ld d, b
ld a, c
not d
and a, d
st a, c

ldi a, 32
add c, a

ld d, b
ld a, c
not d
and a, d
st a, c

ldi a, 32
sub c, a

white_end:

inc b
inc c
ld a, buffer
dec a
st a, buffer
jnz render

ldi c, BANK_IMAGE
ld d, fn_output_index
jmp change_bank

.bank 5
