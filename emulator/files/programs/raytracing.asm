COLORED equ 0b00110001

BANK_MAIN equ 1

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

void db 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0
;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0

fn_out_index db 0,0

reg1 db 0,0
reg2 db 0,0

rotate db 0
player_x db 0,0
player_y db 0,0

indicator1 db 0;0x3A
indicator2 db 0;0x3B
terminal_input db 0;0x3C
terminal_graphics db 0;0x3D
connect db COLORED;0x3E
bank db 1;0x3F

display db      0b11000100, 0b10100000,
                0b10101010, 0b10100000,
                0b11001110, 0b01100000,
                0b10101010, 0b00100000,
                0b10101010, 0b11000000,
                0b00011101, 0b10001000,
                0b00001001, 0b01010100,
                0b00001001, 0b10011100,
                0b00001001, 0b01010100,
                0b00001001, 0b01010100,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000

display_blue db 0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00011101, 0b10001000,
                0b00001001, 0b01010100,
                0b00001001, 0b10011100,
                0b00001001, 0b01010100,
                0b00001001, 0b01010100,
                0b00000011, 0b00110110,
                0b00000100, 0b01000101,
                0b00000100, 0b01110110,
                0b00000100, 0b01000101,
                0b00000011, 0b01110101,
                0b00000000, 0b00000000


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 1                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 1
start:
hlt

.bank 2
