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
.bank 0


ldi a, display
ldi b, 64

clear:
st d, a

inc a
dec b
jnz clear

jmp start

void db 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,1,2,0

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

start:

ld c, connect


ldi d, 0x11
sub c, d

ldi d, 3
sub d, c
jc move_skip

ldi a, select_x
ldi d, 0b00000001
and d, c
add a, d
ld b, a

ldi d, rotate_position
add c, d

ld d, c
add b, d
js move_skip
ldi d, 3
sub d, b
jz move_skip
st b, a

ld a, select_x
ld b, select_y

move_skip:
jmp start

rotate_position db 255,;left
				   255,;up
				   1,  ;right
				   1   ;down

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2
