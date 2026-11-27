; 3DGraphics 1K — общий движок цветных каркасных моделей.
; XYZ₂ в половинах единицы и рёбра находятся в последнем банке; CPU вычисляет все кадры.
; При сборке кадра дисплей отключён; буфер — 64 байта LCD RAM; готовый кадр выводится целиком.
; Для другой модели заменяются только данные model; код движка одинаков.

phase equ 21
cx equ 22
sz equ 23
ep equ 24
ec equ 25
color equ 26
active equ 27
base equ 28
wx equ 29
wy equ 30
wz equ 31
rx equ 32
product equ 33
x0 equ 34
y0 equ 35
x1 equ 36
y1 equ 37
dx equ 38
dy equ 39
sx equ 40
sy equ 41
err equ 42
e2 equ 43
first equ 44
second equ 45
ret0_bank equ 46
ret0_addr equ 47
ret1_bank equ 48
ret1_addr equ 49
io_bank equ 50
pulse_phase equ 51
scale equ 52
scale_sign equ 53
masks equ 54

start: ldi a, 0
st a, 62
ldi c, 1
ldi d, frame_start
jmp set_bank
set_bank: st c, 63
jmp d
read_byte: st c, 63
ld a, b
ld c, io_bank
st c, 63
jmp d
globals db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,128,0
pixel_masks db 128,64,32,16,8,4,2,1
ports db 0,0
screen db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Банк 1 — общий код, одинаковый для всех моделей.
; Отключить чтение дисплея, очистить буфер LCD RAM и начать красный слой.
frame_start:
clr a
st a, 62
ldi b, 64
ldi c, 64
clear_loop:
st a, b
inc b
dec c
jnz clear_loop
ld a, phase
ldi b, 31
and a, b
st a, phase
mov b, a
ldi c, sine
add b, c
ld a, b
st a, sz
ld a, phase
ldi b, 8
add a, b
ldi b, 31
and a, b
mov b, a
ldi c, sine
add b, c
ld a, b
st a, cx
ldi a, 1
st a, active
ldi a, 64
st a, base
ldi c, 6
ldi d, mesh_start
jmp set_bank
; После красного слоя выполнить синий; общие рёбра дают фиолетовый.
plane_done:
ld a, active
shl a
st a, active
ldi b, 4
xor a, b
jz frame_ready
ldi a, 96
st a, base
ldi c, 6
ldi d, mesh_start
jmp set_bank
; Буфер собран; включить цветной дисплей и начать короткий вывод 64 байт.
frame_ready:
ldi a, 48
st a, 62
ldi b, 64
ldi c, 4
ldi d, frame_publish
jmp set_bank
; 32 коэффициента Q3: sin/cos; XYZ₂ в половинах единицы.
sine db 0,2,3,4,6,7,7,8,8,8,7,7,6,4,3,2,0,254,253,252,250,249,249,248,248,248,249,249,250,252,253,254
padding1 db 0,0,0,0,0,0,0,0,0

; Банк 2 — общий код, одинаковый для всех моделей.
; Получить XYZ по индексу и вычислить первое произведение X*cos.
vertex_begin:
mov b, a
shl a
add b, a
ldi a, 130
add b, a
ldi a, 2
st a, io_bank
ldi c, 7
ldi d, resume_vertex_begin_5
jmp read_byte
resume_vertex_begin_5:
st a, wx
inc b
ldi a, 2
st a, io_bank
ldi c, 7
ldi d, resume_vertex_begin_8
jmp read_byte
resume_vertex_begin_8:
st a, wy
inc b
ldi a, 2
st a, io_bank
ldi c, 7
ldi d, resume_vertex_begin_11
jmp read_byte
resume_vertex_begin_11:
st a, wz
ld a, wx
ld b, cx
ldi c, 2
st c, ret1_bank
ldi d, resume_vertex_begin_15
st d, ret1_addr
ldi c, 6
ldi d, multiply
jmp set_bank
resume_vertex_begin_15:
st a, product
ldi c, 3
ldi d, vertex_rotate
jmp set_bank
; Тонкий Брезенхэм: направление X всегда одинаковое, без двойных линий при A↔B.
line_start:
ld a, x1
ld b, x0
sub a, b
ldi b, 1
jnc x_forward
neg a
ld c, x0
ld d, x1
st d, x0
st c, x1
ld c, y0
ld d, y1
st d, y0
st c, y1
x_forward:
st a, dx
st b, sx
ld a, y1
ld b, y0
sub a, b
ldi b, 1
jnc y_forward
neg a
neg b
y_forward:
st a, dy
st b, sy
ld a, dx
ld b, dy
sub a, b
st a, err
ldi c, 4
ldi d, line_loop
jmp set_bank

; Банк 3 — общий код, одинаковый для всех моделей.
; Повернуть X/Z на CPU; ортографическая проекция с постоянным наклоном.
vertex_rotate:
ld a, wz
ld b, sz
ldi c, 3
st c, ret1_bank
ldi d, resume_vertex_rotate_2
st d, ret1_addr
ldi c, 6
ldi d, multiply
jmp set_bank
resume_vertex_rotate_2:
ld b, product
add a, b
ldi c, 3
st c, ret1_bank
ldi d, resume_vertex_rotate_5
st d, ret1_addr
ldi c, 6
ldi d, scale_coordinate
jmp set_bank
resume_vertex_rotate_5:
sar a
sar a
sar a
sar a
ldi b, 8
add a, b
st a, rx
ld a, wz
ld b, cx
ldi c, 3
st c, ret1_bank
ldi d, resume_vertex_rotate_15
st d, ret1_addr
ldi c, 6
ldi d, multiply
jmp set_bank
resume_vertex_rotate_15:
st a, product
ld a, wx
ld b, sz
ldi c, 3
st c, ret1_bank
ldi d, resume_vertex_rotate_19
st d, ret1_addr
ldi c, 6
ldi d, multiply
jmp set_bank
resume_vertex_rotate_19:
ld b, product
sub b, a
mov a, b
sar a
sar a
sar a
sar a
sar a
ld b, wy
sub a, b
ldi c, 3
st c, ret1_bank
ldi d, resume_vertex_rotate_30
st d, ret1_addr
ldi c, 6
ldi d, scale_coordinate
jmp set_bank
resume_vertex_rotate_30:
sar a
ldi b, 8
add a, b
st a, wy
ld a, rx
st a, wx
ld c, ret0_bank
ld d, ret0_addr
jmp set_bank
padding3 db 0,0,0,0

; Банк 4 — общий код, одинаковый для всех моделей.
; Повторно записать готовую LCD RAM: эмулятор обновляет дисплей только при записи.
frame_publish:
ldi c, 64
publish_loop:
ld a, b
st a, b
inc b
dec c
jnz publish_loop
ldi c, 5
ldi d, frame_presented
jmp set_bank
; Линейная пульсация 1…2: 256 кадров, коэффициент Q7 64…128.
pulse_update:
ld a, pulse_phase
inc a
st a, pulse_phase
test a
jns pulse_positive
neg a
pulse_positive:
shr a
ldi b, 64
add a, b
st a, scale
ldi c, 1
ldi d, frame_start
jmp set_bank
; Добавить пиксель текущего слоя; цвет пересечения складывается из двух битов.
line_loop:
ld a, x0
mov b, a
shr a
shr a
shr a
ld c, y0
shl c
add c, a
ld a, base
add c, a
mov a, b
ldi d, 7
and a, d
ldi d, masks
add a, d
ld a, a
ld b, c
or a, b
st a, c
ld a, x0
ld b, x1
xor a, b
jnz line_step
ld a, y0
ld b, y1
xor a, b
jnz resume_line_loop_26
ldi c, 5
ldi d, edge_done
jmp set_bank
resume_line_loop_26:
line_step:
ld a, err
shl a
st a, e2
ld b, dy
neg b
sub a, b
js skip_x
ld a, err
ld b, dy
sub a, b
st a, err
ld a, x0
ld b, sx
add a, b
st a, x0
skip_x:
ld a, dx
ld b, e2
sub a, b
js line_loop
ld a, err
ld b, dx
add a, b
st a, err
ld a, y0
ld b, sy
add a, b
st a, y0
jmp line_loop
padding4 db 0

; Банк 5 — общий код, одинаковый для всех моделей.
; Весь готовый кадр выведен; перейти к следующему углу и масштабу.
frame_presented:
frame_complete:
ld a, phase
inc a
st a, phase
ldi c, 4
ldi d, pulse_update
jmp set_bank
; Два индекса A, B; движок чередует синий и красный независимо от модели.
edge_begin:
ld b, ep
ldi a, 5
st a, io_bank
ldi c, 7
ldi d, resume_edge_begin_1
jmp read_byte
resume_edge_begin_1:
st a, first
inc b
ldi a, 5
st a, io_bank
ldi c, 7
ldi d, resume_edge_begin_4
jmp read_byte
resume_edge_begin_4:
st a, second
inc b
st b, ep
ld a, color
ldi b, 3
xor a, b
st a, color
ld b, active
and a, b
jz edge_done
ld a, first
ldi c, 5
st c, ret0_bank
ldi d, resume_edge_begin_16
st d, ret0_addr
ldi c, 2
ldi d, vertex_begin
jmp set_bank
resume_edge_begin_16:
ld a, wx
st a, x0
ld a, wy
st a, y0
ld a, second
ldi c, 5
st c, ret0_bank
ldi d, resume_edge_begin_22
st d, ret0_addr
ldi c, 2
ldi d, vertex_begin
jmp set_bank
resume_edge_begin_22:
ld a, wx
st a, x1
ld a, wy
st a, y1
ldi c, 2
ldi d, line_start
jmp set_bank
; Следующее ребро или следующий экранный слой.
edge_done:
ld a, ec
dec a
st a, ec
jnz edge_begin
ldi c, 1
ldi d, plane_done
jmp set_bank
padding5 db 0,0,0,0,0,0,0,0

; Банк 6 — общий код, одинаковый для всех моделей.
; Прочитать число вершин и рёбер; найти таблицу рёбер после XYZ.
mesh_start:
ldi a, 1
st a, color
ldi b, 128
ldi a, 6
st a, io_bank
ldi c, 7
ldi d, resume_mesh_start_3
jmp read_byte
resume_mesh_start_3:
mov c, a
shl a
add a, c
ldi c, 130
add a, c
st a, ep
inc b
ldi a, 6
st a, io_bank
ldi c, 7
ldi d, resume_mesh_start_11
jmp read_byte
resume_mesh_start_11:
st a, ec
test a
jnz resume_mesh_start_14
ldi c, 1
ldi d, plane_done
jmp set_bank
resume_mesh_start_14:
ldi c, 5
ldi d, edge_begin
jmp set_bank
; Знаковое умножение малой координаты на коэффициент sin/cos, без таблиц кадров.
multiply:
mov d, a
clr a
test d
jz multiply_done
jns multiply_loop
neg d
neg b
multiply_loop:
add a, b
dec d
jnz multiply_loop
multiply_done:
ld c, ret1_bank
ld d, ret1_addr
jmp set_bank
; 16-битное произведение и деление на 128 сохраняют дробный масштаб до проекции.
scale_coordinate:
st a, scale_sign
mov d, a
test d
jns scale_absolute
neg d
scale_absolute:
ld b, scale
clr a
clr c
test d
jz scale_product
scale_loop:
add a, b
jnc scale_no_carry
inc c
scale_no_carry:
dec d
jnz scale_loop
scale_product:
ld b, scale_sign
test b
jns scale_shift
not c
neg a
jc scale_shift
inc c
scale_shift:
sar c
rcr a
sar c
rcr a
sar c
rcr a
sar c
rcr a
sar c
rcr a
sar c
rcr a
sar c
rcr a
ld c, ret1_bank
ld d, ret1_addr
jmp set_bank
padding6 db 0,0,0,0,0,0

; Банк 7 — заменяемая модель crystal, 44 из 128 байт.
; Два счётчика, XYZ₂ по 3 байта, рёбра по 2 байта: A, B; цвета выбирает движок.
model db 6,12,246,0,246,10,0,246,10,0,10,246,0,10,0,15,0,0,241,0,0,1,1,4,4,0,0,5,5,1,1,2,2,4,5,2,2,3,3,4,5,3,3,0
