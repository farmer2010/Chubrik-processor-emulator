COLORED equ 0b00110001
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
;.bank 0


ldi a, display
ldi b, 64

clear:
st d, a

inc a
dec b
jnz clear

jmp start

void db 0,0,0,0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

tie_text db "   A tie\n"
tie_text_len equ $ - tie_text

buffer db 0,0,0,0

color db 0b00000001;01 - red, 10 - blue, 11 - magenta
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

fn_output_index db 0

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
;.bank 1
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

void1 db 0,0,0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;.bank 2


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

;a - sum
ldi c, 8
ldi d, lines
line_test_cycle:

ld b, d
ld a, b
inc d

ld b, d
ld b, b
add a, b
inc d

ld b, d
ld b, b
add a, b
inc d

ldi b, 30
sub b, a
jz blue_win

ldi b, 3
sub b, a
jz red_win

dec c
jnz line_test_cycle


ldi c, BANK_IMAGE
ldi d, test_tie
jmp change_bank

red_win:
ldi c, BANK_DRAW
ldi d, red_win_display
jmp change_bank

blue_win:
ldi a, blue_win_text
ldi b, blue_len
text_cycle:
ld c, a
st c, terminal_input

inc a
dec b
jnz text_cycle

hlt

blue_win_text db "  Blue win!\n"
blue_len equ $ - blue_win_text

lines db field,   field+1, field+2,
		 field+3, field+4, field+5,
		 field+6, field+7, field+8,
		 field,   field+3, field+6,
		 field+1, field+4, field+7,
		 field+2, field+5, field+8,
		 field,   field+4, field+8,
		 field+2, field+4, field+6
		 
void2 db 0,0,0,0,0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;.bank 3

draw_img:;c - адрес изображения
st d, fn_output_index
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


ldi c, BANK_DRAW
ldi d, draw
jmp change_bank


draw_X:;a, b - coordinates

st a, draw_x
st b, draw_y

ldi a, 0b00000001
st a, color

ldi c, X
ldi d, draw_x_end
jmp draw_img


draw_O:

st a, draw_x
st b, draw_y

ldi a, 0b00000010
st a, color

ldi c, O
ldi d, draw_o_end
jmp draw_img


draw_selection:

st a, draw_x
st b, draw_y

ldi a, 0b00000011
st a, color

ldi c, selection
ldi d, draw_sel_end
jmp draw_img


clear_selection:

st a, draw_x
st b, draw_y

ldi a, 0b00000011
st a, color

ldi c, selection
ldi d, clear_sel_end
jmp draw_img


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
			 
test_tie:

ldi a, field
ldi b, 9
test_tie_cycle:

ld c, a
test c
jz not_tie

inc a
dec b
jnz test_tie_cycle

ldi a, tie_text
ldi b, tie_text_len
tie_text_cycle:

ld c, a
st c, terminal_input

inc a
dec b
jnz tie_text_cycle

hlt

not_tie:
ldi c, BANK_MAIN
ldi d, skip_set
jmp change_bank

void3 db 0,0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 4                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;рисование
;.bank 4

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
xor a, d
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
xor a, d
st a, c

ldi a, 32
sub c, a
blue_end:


inc b
inc c
ld a, buffer
dec a
st a, buffer
jnz render

ldi c, BANK_MAIN
ld d, fn_output_index
jmp change_bank



red_win_display:
ldi a, red_win_text
ldi b, red_len
red_text_cycle:
ld c, a
st c, terminal_input

inc a
dec b
jnz red_text_cycle

hlt


red_win_text db "  Red win!\n"
red_len equ $ - red_win_text

void4 db 0,0

;.bank 5
