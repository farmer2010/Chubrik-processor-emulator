; ##################################################################################################
; ##                          Cube16 — вращающийся каркасный куб                                  ##
; ##                  Computer v2, дисплей 16x16, монохромный режим                               ##
; ##################################################################################################
; CPU вычисляет проекцию вершин и растеризует 12 рёбер Брезенхэмом.
; Вращение вокруг вертикальной оси, ортографическая проекция с фиксированным наклоном.
; Без перспективы, заливки граней и удаления скрытых рёбер. Частота в игре не измерена.
; Таблица синуса содержит только коэффициенты; готовых кадров анимации нет.

; После сдвига влево границу байта определяет флаг переноса C.
; x1 после подготовки — счётчик пикселей; e2 — начальная маска; y1 — начало пробега.
; Константы и переменные
VERTICES equ 38
phase           equ 19
vi              equ 20
vp              equ 21
ep              equ 22
ec              equ 23
cx              equ 24
sz              equ 25
vx              equ 26
vz              equ 27
x0              equ 28
y0              equ 29
x1              equ 30
y1              equ 31
dx              equ 32
dy              equ 33
sx              equ 34
sy              equ 35
err             equ 36
e2              equ 37

;===================================================================================================
; Общая память COMMON
;===================================================================================================
; Включить только монохромный дисплей; входная точка — 0x00.
start:              ldi a, 16
                    st a, 0x3E
                    ldi c, 1
                    ldi d, frame_start
                    jmp set_bank
; Общий переход: C = банк, D = адрес.
set_bank:           st c, 0x3F
                    jmp d
common_code_spare db 0,0,0,0,0,0
; 19 байт рабочих переменных, 16 байт экранных координат восьми вершин.
variables db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
vertices db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
masks db 128,64,32,16,8,4,2,1
; Порты: режим/клавиатура 0x3E и переключение банка 0x3F.
ports db 0,0
; Экран 0x40...0x5F: 16 строк, по два байта на строку.
screen db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; Задний буфер 0x60...0x7F: собирается без промежуточных изменений экрана.
backbuffer db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #1
;===================================================================================================

; Очистить задний буфер и получить базис вращения из таблицы синуса.
frame_start:
                    clr a
                    ldi b, 0x60
                    ldi c, 8
clear_loop:
                    st a, b
                    inc b
                    st a, b
                    inc b
                    st a, b
                    inc b
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
                    neg a
                    sar a
                    st a, vx
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
                    sar a
                    st a, vz
                    clr a
                    st a, vi
                    ldi a, VERTICES
                    st a, vp
                    ldi c, 2
                    ldi d, vertex_calc
                    jmp set_bank

; Завершить копирование кадра и перейти к следующему углу.
frame_ready:
                    ld a, 126
                    st a, 94
                    ld a, 127
                    st a, 95
frame_complete:
                    ld a, phase
                    inc a
                    st a, phase
                    jmp frame_start

; 32 значения синуса, амплитуда 4; cos(t) = sin(t+8). Это не готовые кадры.
sine            db 0,1,2,2,3,3,4,4,4,4,4,3,3,2,2,1,0,255,254,254,253,253,252,252,252,252,252,253,253,254,254,255
; Заполнение до следующего банка.
bank1_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #2
;===================================================================================================

; Вычислить 8 пар экранных координат; биты vi задают знаки X, Z и Y.
vertex_calc:
                    ld a, vi
                    ldi b, 1
                    and a, b
                    ld a, cx
                    jz x_positive
                    neg a
x_positive:
                    mov b, a
                    ld a, vi
                    ldi c, 2
                    and a, c
                    ld a, sz
                    jz z_positive
                    neg a
z_positive:
                    add a, b
                    ldi b, 8
                    add a, b
                    ld b, vp
                    st a, b
                    inc b
                    st b, vp
                    ld a, vi
                    ldi b, 1
                    and a, b
                    ld a, vx
                    jz vx_positive
                    neg a
vx_positive:
                    mov b, a
                    ld a, vi
                    ldi c, 2
                    and a, c
                    ld a, vz
                    jz vz_positive
                    neg a
vz_positive:
                    add a, b
                    mov b, a
                    ld a, vi
                    ldi c, 4
                    and a, c
                    ldi a, 3
                    jz y_positive
                    neg a
y_positive:
                    add a, b
                    ldi b, 8
                    add a, b
                    ld b, vp
                    st a, b
                    inc b
                    st b, vp
                    ld a, vi
                    inc a
                    st a, vi
                    ldi b, 8
                    xor a, b
                    jnz vertex_calc
                    ldi a, edges
                    st a, ep
                    ldi a, 12
                    st a, ec
                    ldi c, 3
                    ldi d, edge_begin
                    jmp set_bank
; Заполнение до следующего банка.
bank2_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #3
;===================================================================================================

; Прочитать два индекса вершины и передать концы ребра растеризатору.
edge_begin:
                    ld b, ep
                    ld a, b
                    shl a
                    ldi c, VERTICES
                    add a, c
                    mov c, a
                    ld a, c
                    st a, x0
                    inc c
                    ld a, c
                    st a, y0
                    inc b
                    ld a, b
                    shl a
                    ldi c, VERTICES
                    add a, c
                    mov c, a
                    ld a, c
                    st a, x1
                    inc c
                    ld a, c
                    st a, y1
                    inc b
                    st b, ep
                    ldi c, 4
                    ldi d, line_start
                    jmp set_bank

; После двенадцатого ребра показать готовый кадр.
edge_done:
                    ld a, ec
                    dec a
                    st a, ec
                    jnz edge_begin
                    ldi c, 7
                    ldi d, present
                    jmp set_bank

; Вертикаль: постоянная маска, адрес следующей строки отличается на +/-2.
vertical:
                    ld c, e2
                    ld d, dy
                    inc d
vertical_loop:
                    ld a, b
                    or a, c
                    st a, b
                    dec d
                    jz edge_done
                    ld a, sy
                    add b, a
                    jmp vertical_loop

; 12 рёбер куба: пары индексов восьми вершин, 24 байта.
edges           db 0,1,2,3,4,5,6,7,0,2,1,3,4,6,5,7,0,4,1,5,2,6,3,7
; Заполнение до следующего банка.
bank3_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #4
;===================================================================================================

; Один расчёт адреса/маски; sx = +/-1, sy = +/-2; err = (major-1)//2.
line_start:
                    ld a, x1
                    ld b, x0
                    sub a, b
                    ldi b, 1
                    jnc x_forward
                    neg a
                    neg b
x_forward:
                    st a, dx
                    st b, sx
                    ld a, y1
                    ld b, y0
                    sub a, b
                    ldi b, 2
                    jnc y_forward
                    neg a
                    neg b
y_forward:
                    st a, dy
                    st b, sy
                    ld a, x0
                    shr a
                    shr a
                    shr a
                    ld b, y0
                    shl b
                    add b, a
                    ldi a, 0x60
                    add b, a
                    ld a, x0
                    ldi c, 7
                    and a, c
                    ldi c, masks
                    add a, c
                    ld a, a
                    st a, e2
                    ld a, dy
                    test a
                    jnz _bridge_3_38
                    ldi c, 6
                    ldi d, horizontal
                    jmp set_bank
_bridge_3_38:
                    ld a, dx
                    test a
                    jnz _bridge_3_41
                    ldi c, 3
                    ldi d, vertical
                    jmp set_bank
_bridge_3_41:
                    ld a, dx
                    ld c, dy
                    sub a, c
                    jc steep_start
                    ld a, dx
                    inc a
                    st a, x1
                    dec a
                    dec a
                    sar a
                    st a, err
                    ld a, sx
                    test a
                    jns _bridge_3_55
                    ldi c, 5
                    ldi d, shallow_left
                    jmp set_bank
_bridge_3_55:
                    ldi c, 5
                    ldi d, shallow_right
                    jmp set_bank

; Крутая линия: каждый шаг меняет строку, ошибка задаёт редкие шаги X.
steep_start:
                    ld a, dy
                    inc a
                    st a, x1
                    dec a
                    dec a
                    sar a
                    st a, err
                    ldi c, 5
                    ldi d, steep_loop_start
                    jmp set_bank
; Заполнение до следующего банка.
bank4_padding db 0,0,0

;===================================================================================================
; Банк памяти #5
;===================================================================================================

; Пологая линия: адрес, маска и ошибка остаются в регистрах; шаг X right.
shallow_right:
                    ld c, e2
                    ld d, err
shallow_right_loop:
                    ld a, b
                    or a, c
                    st a, b
                    ld a, x1
                    dec a
                    st a, x1
                    jz edge_return
                    ld a, dy
                    sub d, a
                    jns shallow_right_x
                    ld a, dx
                    add d, a
                    ld a, sy
                    add b, a
shallow_right_x:
                    shr c
                    jnz shallow_right_loop
                    inc b
                    ldi c, 128
                    jmp shallow_right_loop

; Пологая линия: адрес, маска и ошибка остаются в регистрах; шаг X left.
shallow_left:
                    ld c, e2
                    ld d, err
shallow_left_loop:
                    ld a, b
                    or a, c
                    st a, b
                    ld a, x1
                    dec a
                    st a, x1
                    jz edge_return
                    ld a, dy
                    sub d, a
                    jns shallow_left_x
                    ld a, dx
                    add d, a
                    ld a, sy
                    add b, a
shallow_left_x:
                    shl c
                    jnc shallow_left_loop
                    dec b
                    ldi c, 1
                    jmp shallow_left_loop

; Крутая линия: прибавить +/-2 к адресу строки; сдвигать маску только при шаге X.
steep_loop_start:
                    ld c, e2
                    ld d, err
steep_loop:
                    ld a, b
                    or a, c
                    st a, b
                    ld a, x1
                    dec a
                    st a, x1
                    jz edge_return
                    ld a, sy
                    add b, a
                    ld a, dx
                    sub d, a
                    jns steep_loop
                    ld a, dy
                    add d, a
                    ld a, sx
                    test a
                    js steep_left
                    shr c
                    jnz steep_loop
                    inc b
                    ldi c, 128
                    jmp steep_loop
steep_left:
                    shl c
                    jnc steep_loop
                    dec b
                    ldi c, 1
                    jmp steep_loop

; Общий выход из регистровых циклов растеризации.
edge_return:
                    ldi c, 3
                    ldi d, edge_done
                    jmp set_bank
; Заполнение до следующего банка.
bank5_padding db 0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #6
;===================================================================================================

; Горизонталь: собрать маску диапазона и обновить только один или два байта строки.
horizontal:
                    ld a, x0
                    ld c, x1
                    ld d, sx
                    test d
                    jns horizontal_ordered
                    mov d, a
                    mov a, c
                    mov c, d
horizontal_ordered:
                    st a, x0
                    st c, x1
                    shr a
                    shr a
                    shr a
                    ld b, y0
                    shl b
                    add b, a
                    ldi a, 96
                    add b, a
                    ld a, x0
                    ldi c, 7
                    and a, c
                    ldi c, right_masks
                    add a, c
                    ld d, a
                    ld a, x1
                    ldi c, 7
                    and a, c
                    ldi c, left_masks
                    add a, c
                    ld c, a
                    ld a, x1
                    shr a
                    shr a
                    shr a
                    xor a, b
                    shr a
                    jc horizontal_cross
                    and d, c
                    ld a, b
                    or a, d
                    st a, b
                    ldi c, 3
                    ldi d, edge_done
                    jmp set_bank
horizontal_cross:
                    ld a, b
                    or a, d
                    st a, b
                    inc b
                    ld a, b
                    or a, c
                    st a, b
                    ldi c, 3
                    ldi d, edge_done
                    jmp set_bank

; Маски от левой границы до конца байта.
right_masks     db 255,127,63,31,15,7,3,1

; Маски от начала байта до правой границы.
left_masks      db 128,192,224,240,248,252,254,255
; Заполнение до следующего банка.
bank6_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #7
;===================================================================================================

; Развёрнуто скопировать первые 30 байт кадра; последние два — в банке #1.
present:
                    ld a, 96
                    st a, 64
                    ld a, 97
                    st a, 65
                    ld a, 98
                    st a, 66
                    ld a, 99
                    st a, 67
                    ld a, 100
                    st a, 68
                    ld a, 101
                    st a, 69
                    ld a, 102
                    st a, 70
                    ld a, 103
                    st a, 71
                    ld a, 104
                    st a, 72
                    ld a, 105
                    st a, 73
                    ld a, 106
                    st a, 74
                    ld a, 107
                    st a, 75
                    ld a, 108
                    st a, 76
                    ld a, 109
                    st a, 77
                    ld a, 110
                    st a, 78
                    ld a, 111
                    st a, 79
                    ld a, 112
                    st a, 80
                    ld a, 113
                    st a, 81
                    ld a, 114
                    st a, 82
                    ld a, 115
                    st a, 83
                    ld a, 116
                    st a, 84
                    ld a, 117
                    st a, 85
                    ld a, 118
                    st a, 86
                    ld a, 119
                    st a, 87
                    ld a, 120
                    st a, 88
                    ld a, 121
                    st a, 89
                    ld a, 122
                    st a, 90
                    ld a, 123
                    st a, 91
                    ld a, 124
                    st a, 92
                    ld a, 125
                    st a, 93
                    ldi c, 1
                    ldi d, frame_ready
                    jmp set_bank
