; COMPLETE target-side QR Version 1-L, fixed mask 0, Byte/CP1251 ECI22 <=16.
; FIXED PROFILE ONLY: no version/ECC selection, no mask search or penalty scoring.
; Data and ECC are computed by CPU; RS coefficients and function-pattern template are precomputed.
; Physical terminal raster 21x21, no added border, no frame RAM.
; Enter generates; unsupported keys ignored; Backspace=8; clear buffers and accept NEW input after QR.
STREAM equ 0x40
INPUT equ 0x60
length equ 35
key equ 36
txt equ 37
left equ 38
lo equ 39
hi equ 40
n equ 41
dest equ 42
ret equ 43
emitbank equ 44
accum equ 45
used equ 46
i equ 47
j equ 48
factor equ 49
X equ 50
Y equ 51
pixeldata equ 52
physicalx equ 53
physicaly equ 54
rowbase equ 55
pack equ 56
bitmask equ 57
offset equ 39
tail equ 40
scan equ 41
count equ 43
input_start:
ldi a, 1
st a, 0x3E
ldi a, 62
st a, 0x3C
ldi c, 1
ldi d, key_loop
jmp set_bank
set_bank:
st c, 0x3F
jmp d
pixel_done:
ldi c, 3
ldi d, render_return
jmp set_bank
common_workspace db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ports db 0,0,0,0,0,0
stream_and_input db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
preserved_input db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
coefficients db 127,122,154,164,11,68,117
common_spare db 0
; Bank 1: key_loop
key_loop:
ld a, 0x3E
test a
jz key_loop
st a, key
ldi b, 10
xor b, a
jz enter
ldi b, 8
xor b, a
jz backspace
ld b, length
ldi c, 16
xor b, c
jz key_loop
ldi b, 32
sub a, b
jc key_loop
ldi b, 95
xor b, a
jz key_loop
ldi b, 120
xor b, a
jz key_loop
ld a, key
jmp accepted
; Bank 1: accepted
accepted:
ld b, length
ldi c, INPUT
add b, c
ld a, key
st a, b
st a, 0x3C
ld a, length
inc a
st a, length
jmp key_loop
; Bank 1: backspace
backspace:
ld a, length
test a
jz key_loop
dec a
st a, length
ldi a, 8
st a, 0x3C
jmp key_loop
; Bank 1: enter
enter:
ld a, length
test a
jz key_loop
ldi a, 10
st a, 0x3C
ldi c, 2
ldi d, encode_start
jmp set_bank
; Bank 1: next_input
next_input:
clr a
st a, length
st a, key
ldi b, STREAM
ldi c, 56
clear_input_loop:
st a, b
inc b
dec c
jnz clear_input_loop
ldi a, 62
st a, 0x3C
jmp key_loop
bank1_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; Bank 2: encode_start
encode_start:
ldi a, 113
st a, STREAM
ldi a, 100
st a, STREAM+1
ld a, length
st a, STREAM+2
ldi b, INPUT
ldi c, STREAM+3
mov d, a
copy_input:
ld a, b
st a, c
inc b
inc c
dec d
jnz copy_input
ldi b, STREAM+19
xor b, c
jz copy_done
clr a
st a, c
inc c
copy_done:
st c, dest
ldi c, 4
ldi d, pad_bytes
jmp set_bank
; Bank 2: render_start
render_start:
clr a
st a, rowbase
jmp render_row
; Bank 2: render_row
render_row:
clr a
st a, physicalx
jmp render_column
; Bank 2: render_column
render_column:
ld b, physicalx
ldi a, coordinates
add b, a
ld a, b
st a, X
clr a
st a, pack
ldi a, 1
st a, bitmask
ld a, rowbase
st a, physicaly
jmp render_bit
; Bank 2: render_bit
render_bit:
ld b, physicaly
ldi a, coordinates
add b, a
ld a, b
st a, Y
ldi c, 5
ldi d, pixel
jmp set_bank
coordinates db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,255,255,255
bank2_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; Bank 3: render_return
render_return:
test a
jz skip_black
ld a, pack
ld b, bitmask
or a, b
st a, pack
skip_black:
ld a, physicaly
inc a
st a, physicaly
ld a, bitmask
shl a
st a, bitmask
jz _return_21_13
ldi c, 2
ldi d, render_bit
jmp set_bank
_return_21_13:
ld a, pack
st a, 0x3D
ld a, physicalx
inc a
st a, physicalx
ldi b, 24
xor b, a
jz _return_21_21
ldi c, 2
ldi d, render_column
jmp set_bank
_return_21_21:
ldi a, 10
st a, 0x3C
ld a, rowbase
ldi b, 8
add a, b
st a, rowbase
ldi b, 24
xor b, a
jz _return_21_30
ldi c, 2
ldi d, render_row
jmp set_bank
_return_21_30:
ldi c, 1
ldi d, next_input
jmp set_bank
bank3_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; Bank 4: pad_bytes
pad_bytes:
ld b, dest
ldi a, 236
pad_loop:
ldi c, STREAM+19
xor c, b
jz clear_ecc
st a, b
inc b
ldi c, 253
xor a, c
jmp pad_loop
clear_ecc:
clr a
ldi c, 8
clear_ecc_loop:
st a, b
inc b
dec c
jnz clear_ecc_loop
st a, i
jmp rs_outer
; Bank 4: rs_outer
rs_outer:
ld b, i
ldi a, STREAM
add b, a
ld a, b
ld b, STREAM+19
xor a, b
st a, factor
clr a
st a, j
jmp rs_inner
; Bank 4: rs_inner
rs_inner:
ld b, j
ldi a, coefficients
add b, a
ld a, b
ld b, factor
clr c
gf_loop:
shr b
jnc gf_skip
xor c, a
gf_skip:
shl a
jnc gf_no_reduce
ldi d, 29
xor a, d
gf_no_reduce:
test b
jnz gf_loop
ld b, j
ldi a, STREAM+20
add b, a
ld a, b
xor a, c
dec b
st a, b
ld a, j
inc a
st a, j
ldi b, 7
xor b, a
jnz rs_inner
ld a, i
inc a
st a, i
ldi b, 19
xor b, a
jnz rs_outer
ldi c, 2
ldi d, render_start
jmp set_bank
; Bank 4: data_bit
data_bit:
mov a, b
ldi c, 7
and a, c
inc a
shr b
shr b
shr b
ldi c, STREAM
add b, c
ld b, b
extract_data:
shl b
dec a
jnz extract_data
clr a
rcl a
st a, pixeldata
ldi c, 6
ldi d, fixed_bit
jmp set_bank
bank4_padding db 0
; Bank 5: pixel
pixel:
ld a, X
ld b, Y
inc a
jz blank_pixel
inc b
jz blank_pixel
dec a
dec b
ldi c, 6
xor c, a
jz fixed_pixel
ldi c, 6
xor c, b
jz fixed_pixel
ldi c, 12
sub c, a
jc high_pixel
ldi c, 8
sub c, a
jc middle_pixel
ldi c, 8
sub c, b
jnc fixed_pixel
ldi c, 12
sub c, b
jc fixed_pixel
jmp data_index
; Bank 5: high_pixel
high_pixel:
ldi c, 9
sub b, c
jc fixed_pixel
ld b, Y
jmp data_index
; Bank 5: middle_pixel
middle_pixel:
ldi c, 6
sub c, b
jnc data_index
dec b
jmp data_index
; Bank 5: data_index
data_index:
mov c, a
ldi d, columnmap
add c, d
ld d, c
ldi c, 6
sub c, a
jc direction_ready
inc a
direction_ready:
inc a
ldi c, 2
and a, c
jnz index_down
neg b
index_down:
shl b
add b, d
ldi c, 4
ldi d, data_bit
jmp set_bank
; Bank 5: fixed_pixel
fixed_pixel:
clr a
st a, pixeldata
ldi c, 6
ldi d, fixed_bit
jmp set_bank
; Bank 5: blank_pixel
blank_pixel:
clr a
jmp pixel_done
columnmap db 183,182,217,216,167,166,0,201,200,137,136,135,134,55,54,89,88,7,6,41,40
bank5_padding db 0,0,0,0,0,0,0,0
; Bank 6: fixed_bit
fixed_bit:
ld a, Y
mov b, a
shl a
add b, a
ld a, X
mov c, a
shr c
shr c
shr c
add b, c
ldi c, template
add b, c
ld a, b
ld b, X
ldi c, 7
and b, c
inc b
extract_fixed:
shl a
dec b
jnz extract_fixed
clr a
rcl a
ld b, pixeldata
xor a, b
jmp pixel_done
template db 254,43,248,130,82,8,186,170,232,186,82,232,186,42,232,130,82,8,254,171,248,0,208,0,239,174,32,85,85,80,170,170,168,85,85,80,170,170,168,0,213,80,254,170,168,130,213,80,186,170,168,186,85,80,186,170,168,130,213,80,254,170,168
