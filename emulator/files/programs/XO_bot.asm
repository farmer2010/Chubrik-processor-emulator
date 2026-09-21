COLORED equ 0b00110001
MONO equ 0b00010001

KEY_UP equ 0x12
KEY_RIGHT equ 0x13
KEY_DOWN equ 0x14
KEY_LEFT equ 0x11
KEY_SPACE equ 0x20

BANK_MAIN equ 1
BANK_LOGIC equ 2
BANK_WIN equ 3
BANK_DRAW equ 4


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                       ОБЩАЯ ОБЛАСТЬ                         W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 0


ldi a, display
ldi b, 64

clear:
st d, a

inc a
dec b
jnz clear

jmp start

void db 0,0,0,0,0,0,0,0,0,0, 0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0

rotate_position db 255,;left
				   255,;up
				   1,  ;right
				   1   ;down

color db 0b00000001;01 - red, 10 - blue, 11 - magenta
render_buffer db 0b00000000, 0b00000000,
				 0b00000000, 0b00000000,
				 0b00000000, 0b00000000,
				 0b00000000, 0b00000000,
				 0b00000000, 0b00000000,
				 0b00000000, 0b00000000

player db 0

field db 0,0,0,;1 - X, 10 - O
		 0,0,0,
		 0,0,0

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
.bank 1

cycle:
;ld c, player
;jnz step

ld c, connect

ldi d, KEY_SPACE
sub d, c
jnz move_selection

step:
ldi c, BANK_LOGIC
ldi d, set_test
jmp change_bank
set_end:

ld c, player
test c
jz draw_X

draw_O:
ldi a, 0b00000010
st a, color
ldi a, O
ldi b, draw_end
ldi c, BANK_DRAW
ldi d, draw
jmp change_bank

draw_X:
ldi a, 0b00000001
st a, color
ldi a, X
ldi b, draw_end
ldi c, BANK_DRAW
ldi d, draw
jmp change_bank

draw_end:

ld c, player
not c
st c, player

ldi c, BANK_WIN
ldi d, test_win
jmp change_bank

skip_set:
jmp cycle

move_selection:
ldi d, 0x11
sub c, d

ldi d, 3
sub d, c
jc cycle

ldi a, select_x
ldi d, 0b00000001
and d, c
add a, d
ld b, a

ldi d, rotate_position
add c, d

ld d, c
add b, d
js cycle
ldi d, 3
sub d, b
jz cycle

st a, buffer + 1
st b, buffer + 2
ldi b, $ + 4
jmp draw_selection

ld a, buffer + 1
ld b, buffer + 2
st b, a

start:
ldi b, cycle

draw_selection:
ldi a, 0b00000011
st a, color
ldi a, selection
ldi c, BANK_DRAW
ldi d, draw
jmp change_bank


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2

set_test:
ld a, select_x
ld b, select_y
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

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;проверка победы и ничьи, вывод сообщений
.bank 3

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


ldi a, field
ldi b, 9
test_tie_cycle:

ld c, a
test c
jz not_tie

inc a
dec b
jnz test_tie_cycle


tie:
ldi a, tie_text
ldi b, tie_text_len
jmp text_cycle
red_win:
ldi a, red_text
ldi b, red_text_len
jmp text_cycle
blue_win:
ldi a, blue_text
ldi b, blue_text_len
text_cycle:
ld c, a
st c, terminal_input

inc a
dec b
jnz text_cycle

hlt

not_tie:
ldi c, BANK_MAIN
ldi d, skip_set
jmp change_bank


blue_text db "  Blue win!\n"
blue_text_len equ $ - blue_text

red_text db "  Red win!\n"
red_text_len equ $ - red_text

tie_text db "\t\bA tie\n"
tie_text_len equ $ - tie_text

lines db field,   field+1, field+2,
		 field+3, field+4, field+5,
		 field+6, field+7, field+8,
		 field,   field+3, field+6,
		 field+1, field+4, field+7,
		 field+2, field+5, field+8,
		 field,   field+4, field+8,
		 field+2, field+4, field+6


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 4                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;рисование
.bank 4

draw:;а - адрес изображения, b - адрес возврата

st b, fn_output_index
ldi c, 6
ldi d, render_buffer
load_image_cycle:

ld b, a
st b, d

ldi b, 4
sub b, c
jz dec_end
jnc dec_a
inc a
jmp dec_end
dec_a:
dec a
dec_end:

inc d
clr b
st b, d
inc d
dec c
jnz load_image_cycle


ld a, select_x
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
ld b, select_y
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


X db		 0b00000000,
			 0b01001000,
			 0b00110000

O db		 0b00000000,
			 0b00110000,
			 0b01001000

selection db 0b11111100,
			 0b10000100,
			 0b10000100

.bank 5
