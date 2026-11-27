; 3DGraphics: cylinder; приложение wireframe.
MODEL_BASE               equ 36
MODEL_ADDR               equ 232
APP_BANK                 equ 39
MAX_VERTICES             equ 18
MAX_TRIANGLES            equ 32
DEMO_PROJECTION          equ 0
DEMO_RENDER              equ 1
DEMO_COLOR_MODE          equ 1
DEMO_CULL                equ 0
TRI_BUFFER_BASE          equ 35
TRI_BUFFER_ADDR          equ 200
FRAME_ADVANCE_BANK       equ 41

; Начало общего модуля 3DGraphics.
; 3DGraphics — единый ASM API для одного активного объекта.
; Параметры проекции, примитивов, цвета и преобразований хранятся в памяти.
; Приложение задаёт APP_BANK и метку main, выделяет рабочие массивы и размещает модели.

ret0_bank                equ 25
ret0_addr                equ 26
ret1_bank                equ 27
ret1_addr                equ 28
ret2_bank                equ 29
ret2_addr                equ 30
ret3_bank                equ 31
ret3_addr                equ 32
io_ret_bank              equ 33
ptr_bank                 equ 34
ptr_addr                 equ 35
vertex_count             equ 36
edge_count               equ 37
yaw                      equ 38
pitch                    equ 39
roll                     equ 40
out_bank                 equ 41
out_addr                 equ 42
wx                       equ 43
wy                       equ 44
wz                       equ 45
ru                       equ 46
rv                       equ 47
angle                    equ 48
t0                       equ 49
t1                       equ 50
x0                       equ 51
y0                       equ 52
x1                       equ 53
y1                       equ 54
dx                       equ 55
dy                       equ 56
sx                       equ 57
sy                       equ 58
err                      equ 59
mask                     equ 60
color                    equ 61
signs                    equ 60
mul_sign                 equ 59
depth                    equ 48
TRI_STATE_BANK           equ 34
VERTEX_BASE              equ 35
STATE_BANK               equ 33
LUT_BASE                 equ 33
LUT_ADDR                 equ 151
CAMERA_DISTANCE          equ 32
EDGE_STRIDE              equ 3
PROJECTION_PERSPECTIVE   equ 0
PROJECTION_PARALLEL      equ 1
RENDER_WIREFRAME         equ 1
RENDER_POLYGONS          equ 2
RENDER_BOTH              equ 3
COLOR_MODEL              equ 0
COLOR_ALTERNATING        equ 1
COLOR_SOLID              equ 2
STATE_PHASE              equ 128
STATE_SCALE              equ 129
STATE_TRI_TOTAL          equ 130
STATE_CACHE_BANK         equ 131
STATE_CACHE_ADDR         equ 132
STATE_BEST_BANK          equ 133
STATE_BEST_ADDR          equ 134
STATE_CULL               equ 135
STATE_PROJECTION         equ 136
STATE_RENDER             equ 137
STATE_COLOR_MODE         equ 138
STATE_COLOR              equ 139
STATE_TX                 equ 140
STATE_TY                 equ 141
STATE_TZ                 equ 142
STATE_ACTIVE             equ 143
STATE_MODEL_BANK         equ 144
STATE_MODEL_ADDR         equ 145
STATE_COLOR_PHASE        equ 146
STATE_TRI_BASE_BANK      equ 147
STATE_TRI_BASE_ADDR      equ 148
STATE_WORK_END_BANK      equ 149
STATE_WORK_END_ADDR      equ 150
TRI_STATE0               equ 128
TRI_STATE1               equ 129
TRI_STATE2               equ 130
TRI_STATE3               equ 131
TRI_STATE4               equ 132
TRI_STATE5               equ 133
TRI_STATE6               equ 134
TRI_STATE7               equ 135
TRI_STATE8               equ 136
TRI_STATE9               equ 137
TRI_STATE10              equ 138
TRI_STATE11              equ 139
TRI_STATE_END            equ 140
GFX_READ_NEXT_BANK       equ 1
GFX_ADVANCE_POINTER_BANK equ 1
GFX_LOAD_MODEL_BANK      equ 1
GFX_WRITE_NEXT_BANK      equ 2
GFX_READ_OUTPUT_BANK     equ 3
GFX_SINE_PRODUCT_BANK    equ 4
GFX_MUL16_BANK           equ 4
GFX_DRAW_MESH_BANK       equ 6
GFX_DRAW_OBJECT_BANK     equ 6
GFX_ROTATE_PAIR_BANK     equ 7
GFX_PROJECT_VERTEX_BANK  equ 8
GFX_RESOLVE_COLOR_BANK   equ 11
GFX_DIVIDE_PROJECTION_BANK equ 12
GFX_GET_VERTEX_BANK      equ 15
GFX_ROTATE_BANK          equ 15
GFX_PIXEL_BANK           equ 16
GFX_LINE_PIXEL_BANK      equ 16
GFX_LINE_BANK            equ 17
GFX_TRIANGLE_BANK        equ 19
GFX_SCALE_VERTEX_BANK    equ 26
GFX_SET_ROTATION_BANK    equ 30
GFX_SET_WORKSPACE_BANK   equ 31
GFX_MOVE_BANK            equ 32
GFX_SET_SCALE_BANK       equ 33
GFX_SET_PROJECTION_BANK  equ 33
GFX_SET_RENDER_MODE_BANK equ 33
GFX_SET_COLOR_MODE_BANK  equ 33
GFX_SET_COLOR_BANK       equ 33
GFX_SET_CULL_BANK        equ 33
GFX_SET_POSITION_BANK    equ 33
GFX_BEGIN_BANK           equ 34
GFX_PRESENT_BANK         equ 34

; Общая область CPU.
start:              ldi c, APP_BANK
                    st c, 0x3F
                    jmp main
set_bank:           st c, 0x3F
                    jmp d
read_byte:          st c, 0x3F
                    ld a, b
                    ld c, io_ret_bank
                    st c, 0x3F
                    jmp d
write_byte:         st c, 0x3F
                    st a, b
                    ld c, io_ret_bank
                    st c, 0x3F
                    jmp d
globals db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ports db 0,0
screen db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #1
;===================================================================================================

; Прочитать следующий байт модели; переходить через границы банков.
gfx_read_next:
                    ldi d, 1
                    st d, io_ret_bank
                    ld c, ptr_bank
                    ld b, ptr_addr
                    ldi d, io_gfx_read_next_0
                    jmp read_byte
io_gfx_read_next_0:
                    ldi b, ptr_addr
                    jmp gfx_advance_pointer

; B — адрес поля указателя в COMMON; банк лежит предыдущим байтом. A сохраняется.
gfx_advance_pointer:
                    ld c, b
                    inc c
                    st c, b
                    jnz pointer_advanced
                    ldi c, 128
                    st c, b
                    dec b
                    ld c, b
                    inc c
                    st c, b
pointer_advanced:
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Привязать одну модель; проверить 4V+5T байт рабочего буфера. A=1 — готово, A=0 — ошибка.
gfx_load_model:
                    ld a, ptr_bank
                    ldi d, 1
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_BANK
                    ldi d, io_gfx_load_model_1
                    jmp write_byte
io_gfx_load_model_1:
                    ld a, ptr_addr
                    ldi d, 1
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_ADDR
                    ldi d, io_gfx_load_model_3
                    jmp write_byte
io_gfx_load_model_3:
                    clr a
                    ldi d, 1
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_gfx_load_model_5
                    jmp write_byte
io_gfx_load_model_5:
                    ldi c, 1
                    st c, ret2_bank
                    ldi d, resume_gfx_load_model_6
                    st d, ret2_addr
                    jmp gfx_read_next
resume_gfx_load_model_6:
                    st a, vertex_count
                    test a
                    jnz bridge_gfx_load_model_9
                    ldi c, 25
                    ldi d, object_failed
                    jmp set_bank
bridge_gfx_load_model_9:
                    ldi c, 1
                    st c, ret2_bank
                    ldi d, resume_gfx_load_model_10
                    st d, ret2_addr
                    jmp gfx_read_next
resume_gfx_load_model_10:
                    ldi c, 1
                    st c, ret2_bank
                    ldi d, resume_gfx_load_model_11
                    st d, ret2_addr
                    jmp gfx_read_next
resume_gfx_load_model_11:
                    st a, edge_count
                    ldi c, 32
                    ldi d, object_workspace
                    jmp set_bank
padding1 db 0,0,0,0

;===================================================================================================
; Банк памяти #2
;===================================================================================================

; Записать следующий байт в буфер экранных вершин.
gfx_write_next:
                    ldi d, 2
                    st d, io_ret_bank
                    ld c, out_bank
                    ld b, out_addr
                    ldi d, io_gfx_write_next_0
                    jmp write_byte
io_gfx_write_next_0:
                    ldi b, out_addr
                    ldi c, 1
                    ldi d, gfx_advance_pointer
                    jmp set_bank

; CPU вычисляет каждую экранную вершину один раз; результат — x/y/видимость/глубина.
mesh_store_vertex:
                    ld a, wx
                    ldi c, 2
                    st c, ret2_bank
                    ldi d, resume_mesh_store_vertex_1
                    st d, ret2_addr
                    jmp gfx_write_next
resume_mesh_store_vertex_1:
                    ld a, wy
                    ldi c, 2
                    st c, ret2_bank
                    ldi d, resume_mesh_store_vertex_3
                    st d, ret2_addr
                    jmp gfx_write_next
resume_mesh_store_vertex_3:
                    ld a, wz
                    ldi c, 2
                    st c, ret2_bank
                    ldi d, resume_mesh_store_vertex_5
                    st d, ret2_addr
                    jmp gfx_write_next
resume_mesh_store_vertex_5:
                    ld a, depth
                    ldi c, 2
                    st c, ret2_bank
                    ldi d, resume_mesh_store_vertex_7
                    st d, ret2_addr
                    jmp gfx_write_next
resume_mesh_store_vertex_7:
                    ld a, vertex_count
                    dec a
                    st a, vertex_count
                    jz bridge_mesh_store_vertex_11
                    ldi c, 21
                    ldi d, mesh_vertex
                    jmp set_bank
bridge_mesh_store_vertex_11:
                    ld a, out_bank
                    ldi d, 2
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_BANK
                    ldi d, io_mesh_store_vertex_13
                    jmp write_byte
io_mesh_store_vertex_13:
                    ld a, out_addr
                    ldi d, 2
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_ADDR
                    ldi d, io_mesh_store_vertex_15
                    jmp write_byte
io_mesh_store_vertex_15:
                    ld a, edge_count
                    test a
                    jnz bridge_mesh_store_vertex_18
                    ldi c, 27
                    ldi d, mesh_faces_begin
                    jmp set_bank
bridge_mesh_store_vertex_18:
                    ldi c, 22
                    ldi d, mesh_edge
                    jmp set_bank
padding2 db 0,0

;===================================================================================================
; Банк памяти #3
;===================================================================================================

; Прочитать следующий байт экранной вершины.
gfx_read_output:
                    ldi d, 3
                    st d, io_ret_bank
                    ld c, out_bank
                    ld b, out_addr
                    ldi d, io_gfx_read_output_0
                    jmp read_byte
io_gfx_read_output_0:
                    ldi b, out_addr
                    ldi c, 1
                    ldi d, gfx_advance_pointer
                    jmp set_bank

; Первый индекс преобразовать в экранную вершину после чтения всей записи.
mesh_selected_indices:
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_indices_0
                    st d, ret2_addr
                    jmp gfx_read_output
resume_mesh_selected_indices_0:
                    st a, dy
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_indices_2
                    st d, ret2_addr
                    jmp gfx_read_output
resume_mesh_selected_indices_2:
                    st a, sx
                    ld a, dx
                    ldi c, 3
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_indices_5
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_indices_5:
                    ld a, wx
                    st a, x0
                    ld a, wy
                    st a, y0
                    jmp mesh_selected_vertex1

; Получить три экранные вершины выбранного треугольника.
mesh_selected_vertex1:
                    ld a, dy
                    ldi c, 3
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_vertex1_1
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_vertex1_1:
                    ld a, wx
                    st a, x1
                    ld a, wy
                    st a, y1
                    ld a, sx
                    ldi c, 3
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_vertex1_7
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_vertex1_7:
                    ld a, wx
                    st a, dx
                    ld a, wy
                    st a, dy
                    ldi c, 31
                    ldi d, mesh_selected_cull
                    jmp set_bank
padding3 db 0,0,0,0

;===================================================================================================
; Банк памяти #4
;===================================================================================================

; A — знаковая шестибитная координата, B — фаза 0…31; вернуть round(A*sin(B)).
gfx_sine_product:
                    shl a
                    shl a
                    sar a
                    sar a
                    mov c, b
                    shl c
                    shl c
                    shl c
                    xor c, a
                    st c, sx
                    test a
                    jns sine_positive
                    neg a
sine_positive:
                    test a
                    jz sine_zero
                    st a, sy
                    mov a, b
                    ldi c, 15
                    and a, c
                    ldi c, 8
                    sub c, a
                    jnc sine_folded
                    ldi c, 16
                    sub c, a
                    mov a, c
sine_folded:
                    test a
                    jz sine_zero
                    ldi c, 8
                    xor c, a
                    jz bridge_gfx_sine_product_31
                    ldi c, 5
                    ldi d, sine_fetch
                    jmp set_bank
bridge_gfx_sine_product_31:
                    ld a, sy
                    ldi c, 7
                    ldi d, sine_return
                    jmp set_bank
sine_zero:
                    clr a
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

; Знаковое умножение ru*rv: t1:t0 — 16-битный результат, без аппаратного MUL.
gfx_mul16:
                    ld a, ru
                    ld b, rv
                    xor a, b
                    st a, mul_sign
                    ld c, ru
                    test c
                    jns mul_u_positive
                    neg c
mul_u_positive:
                    ld b, rv
                    test b
                    jns mul_v_positive
                    neg b
mul_v_positive:
                    clr d
                    clr a
                    st a, t0
                    st a, t1
mul_loop:
                    shr b
                    jnc mul_skip
                    ld a, t0
                    add a, c
                    st a, t0
                    ld a, t1
                    adc a, d
                    st a, t1
mul_skip:
                    shl c
                    rcl d
                    test b
                    jnz mul_loop
                    ld a, mul_sign
                    test a
                    jns mul_done
                    ld a, t0
                    neg a
                    st a, t0
                    ld a, t1
                    ldi b, 0
                    sbb b, a
                    st b, t1
mul_done:
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

;===================================================================================================
; Банк памяти #5
;===================================================================================================

; Выбрать четырёхбайтовую маску приращений для фазы первой четверти.
sine_fetch:
                    dec a
                    shl a
                    shl a
                    mov b, a
                    ldi c, LUT_BASE
                    ldi a, LUT_ADDR
                    add b, a
                    jnc sine_address_ready
                    ldi a, 128
                    add b, a
                    inc c
sine_address_ready:
                    st c, dx
                    st b, dy
                    clr a
                    st a, x1
                    ldi c, 6
                    ldi d, sine_mask
                    jmp set_bank

; X — главная ось; ошибка сохраняет правило выбора пикселя исходного растеризатора.
line_pixel:
                    ld a, x0
                    st a, wx
                    ld a, y0
                    st a, wy
                    ldi c, 5
                    st c, ret2_bank
                    ldi d, resume_line_pixel_4
                    st d, ret2_addr
                    ldi c, 16
                    ldi d, gfx_line_pixel
                    jmp set_bank
resume_line_pixel_4:
                    ld a, x1
                    dec a
                    st a, x1
                    jz line_done
                    ld a, angle
                    test a
                    jnz line_step_y
                    ld a, x0
                    ld b, sx
                    add a, b
                    st a, x0
                    ld a, err
                    ld b, dy
                    sub a, b
                    st a, err
                    jns line_pixel
                    ld b, dx
                    add a, b
                    st a, err
                    ld a, y0
                    ld b, sy
                    add a, b
                    st a, y0
                    jmp line_pixel

; Y — главная ось; координаты -54...70 допустимы при разности не более 127.
line_step_y:
                    ld a, y0
                    ld b, sy
                    add a, b
                    st a, y0
                    ld a, err
                    ld b, dx
                    sub a, b
                    st a, err
                    jns line_pixel
                    ld b, dy
                    add a, b
                    st a, err
                    ld a, x0
                    ld b, sx
                    add a, b
                    st a, x0
                    jmp line_pixel
line_done:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

;===================================================================================================
; Банк памяти #6
;===================================================================================================

; Просуммировать первые |координата| битов; сумма совпадает с округлённым произведением.
sine_mask:
                    ldi d, 6
                    st d, io_ret_bank
                    ld c, dx
                    ld b, dy
                    ldi d, io_sine_mask_0
                    jmp read_byte
io_sine_mask_0:
                    st a, x0
                    ldi a, 8
                    st a, y0
sine_bit:
                    ld a, x0
                    shr a
                    st a, x0
                    jnc sine_bit_zero
                    ld a, x1
                    inc a
                    st a, x1
sine_bit_zero:
                    ld a, sy
                    dec a
                    st a, sy
                    jz sine_value
                    ld a, y0
                    dec a
                    st a, y0
                    jnz sine_bit
                    ld a, dy
                    inc a
                    st a, dy
                    jnz sine_mask
                    ldi a, 128
                    st a, dy
                    ld a, dx
                    inc a
                    st a, dx
                    jmp sine_mask
sine_value:
                    ld a, x1
                    ldi c, 7
                    ldi d, sine_return
                    jmp set_bank

; Нарисовать единственный активный объект с сохранёнными параметрами.
gfx_draw_mesh:
gfx_draw_object:
                    ldi d, 6
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_gfx_draw_mesh_1
                    jmp read_byte
io_gfx_draw_mesh_1:
                    test a
                    jnz bridge_gfx_draw_mesh_3
                    ldi c, 27
                    ldi d, mesh_done
                    jmp set_bank
bridge_gfx_draw_mesh_3:
                    ldi d, 6
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_BANK
                    ldi d, io_gfx_draw_mesh_4
                    jmp read_byte
io_gfx_draw_mesh_4:
                    st a, ptr_bank
                    ldi d, 6
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_ADDR
                    ldi d, io_gfx_draw_mesh_6
                    jmp read_byte
io_gfx_draw_mesh_6:
                    st a, ptr_addr
                    ldi c, 14
                    ldi d, mesh_begin
                    jmp set_bank
padding6 db 0,0,0

;===================================================================================================
; Банк памяти #7
;===================================================================================================

; Восстановить знак координаты и полуволны; точки 0 и π/2 вычисляются точно.
sine_return:
                    ld b, sx
                    test b
                    jns sine_done
                    neg a
sine_done:
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

; Повернуть пару ru/rv на angle: u=cos*u+sin*v, v=cos*v-sin*u.
gfx_rotate_pair:
                    ld a, ru
                    ld b, angle
                    ldi c, 8
                    add b, c
                    ldi c, 31
                    and b, c
                    ldi c, 7
                    st c, ret3_bank
                    ldi d, resume_gfx_rotate_pair_6
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_sine_product
                    jmp set_bank
resume_gfx_rotate_pair_6:
                    st a, t0
                    ld a, rv
                    ld b, angle
                    ldi c, 7
                    st c, ret3_bank
                    ldi d, resume_gfx_rotate_pair_10
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_sine_product
                    jmp set_bank
resume_gfx_rotate_pair_10:
                    st a, t1
                    ld a, rv
                    ld b, angle
                    ldi c, 8
                    add b, c
                    ldi c, 31
                    and b, c
                    ldi c, 7
                    st c, ret3_bank
                    ldi d, resume_gfx_rotate_pair_18
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_sine_product
                    jmp set_bank
resume_gfx_rotate_pair_18:
                    st a, rv
                    ld a, ru
                    ld b, angle
                    ldi c, 7
                    st c, ret3_bank
                    ldi d, resume_gfx_rotate_pair_22
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_sine_product
                    jmp set_bank
resume_gfx_rotate_pair_22:
                    st a, ru
                    ld a, t0
                    ld b, t1
                    add a, b
                    st a, t0
                    ld a, rv
                    ld b, ru
                    sub a, b
                    st a, rv
                    ld a, t0
                    st a, ru
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

;===================================================================================================
; Банк памяти #8
;===================================================================================================

; Вращение вокруг Y, затем X. Координаты модели имеют радиус не более 20.
gfx_project_vertex:
                    ld a, wx
                    st a, ru
                    ld a, wz
                    st a, rv
                    ld a, yaw
                    st a, angle
                    ldi c, 8
                    st c, ret2_bank
                    ldi d, resume_gfx_project_vertex_6
                    st d, ret2_addr
                    ldi c, 7
                    ldi d, gfx_rotate_pair
                    jmp set_bank
resume_gfx_project_vertex_6:
                    ld a, ru
                    st a, wx
                    ld a, rv
                    st a, wz
                    ld a, wy
                    st a, ru
                    ld a, wz
                    st a, rv
                    ld a, pitch
                    st a, angle
                    ldi c, 8
                    st c, ret2_bank
                    ldi d, resume_gfx_project_vertex_17
                    st d, ret2_addr
                    ldi c, 7
                    ldi d, gfx_rotate_pair
                    jmp set_bank
resume_gfx_project_vertex_17:
                    ld a, ru
                    st a, wy
                    ld a, rv
                    st a, wz
                    ldi c, 9
                    ldi d, project_roll
                    jmp set_bank

; Сохранить ключ глубины, цвет и первый индекс в рабочем буфере.
mesh_cache_write0:
                    ld a, dx
                    ldi c, 8
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_1
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_1:
                    ld a, color
                    ldi c, 8
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_3
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_3:
                    ld a, x0
                    ldi c, 8
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_5
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_5:
                    ldi c, 28
                    ldi d, mesh_cache_write1
                    jmp set_bank

;===================================================================================================
; Банк памяти #9
;===================================================================================================

; Вращение вокруг Z; затем смещение объекта и выбор проекции.
project_roll:
                    ld a, wx
                    st a, ru
                    ld a, wy
                    st a, rv
                    ld a, roll
                    st a, angle
                    ldi c, 9
                    st c, ret2_bank
                    ldi d, resume_project_roll_6
                    st d, ret2_addr
                    ldi c, 7
                    ldi d, gfx_rotate_pair
                    jmp set_bank
resume_project_roll_6:
                    ld a, ru
                    st a, wx
                    ld a, rv
                    st a, wy
                    jmp project_translate

; Сместить XYZ после вращения; глубина камеры должна лежать в 8…63.
project_translate:
                    ldi d, 9
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_project_translate_0
                    jmp read_byte
io_project_translate_0:
                    ld b, wx
                    add a, b
                    st a, wx
                    ldi d, 9
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_project_translate_4
                    jmp read_byte
io_project_translate_4:
                    ld b, wy
                    add a, b
                    st a, wy
                    ldi d, 9
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TZ
                    ldi d, io_project_translate_8
                    jmp read_byte
io_project_translate_8:
                    ld b, wz
                    add a, b
                    st a, wz
                    ldi b, CAMERA_DISTANCE
                    add a, b
                    st a, wz
                    st a, depth
                    ldi b, 8
                    sub a, b
                    jc project_invisible
                    ldi b, 56
                    sub a, b
                    jnc project_invisible
                    ldi c, 10
                    ldi d, project_choose
                    jmp set_bank

; Пометить вершину вне диапазона глубины; инцидентные примитивы пропускаются.
project_invisible:
                    clr a
                    st a, wz
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding9 db 0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #10
;===================================================================================================

; Проверить диапазон XY −32…31 и выбрать перспективную или параллельную проекцию.
project_choose:
                    ld a, wx
                    ldi b, 32
                    add a, b
                    ldi b, 64
                    sub a, b
                    jc bridge_project_choose_5
                    ldi c, 9
                    ldi d, project_invisible
                    jmp set_bank
bridge_project_choose_5:
                    ld a, wy
                    ldi b, 32
                    add a, b
                    ldi b, 64
                    sub a, b
                    jc bridge_project_choose_11
                    ldi c, 9
                    ldi d, project_invisible
                    jmp set_bank
bridge_project_choose_11:
                    ldi d, 10
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PROJECTION
                    ldi d, io_project_choose_12
                    jmp read_byte
io_project_choose_12:
                    test a
                    jnz project_parallel
                    ldi c, 11
                    ldi d, project_perspective
                    jmp set_bank

; Параллельная проекция: x=8+floor(X/2), y=8+floor(-Y/2).
project_parallel:
                    ld a, wx
                    sar a
                    ldi b, 8
                    add a, b
                    st a, wx
                    ld a, wy
                    neg a
                    sar a
                    add a, b
                    st a, wy
                    ldi a, 1
                    st a, wz
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; Прочитать индекс и добавить глубину камеры; сохранить общую видимость.
mesh_cache_face2:
                    ldi c, 10
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face2_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face2_0:
                    st a, x1
                    ldi c, 10
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face2_2
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_cache_face2_2:
                    ld a, wz
                    ld b, signs
                    and a, b
                    st a, signs
                    ld a, depth
                    ld b, dx
                    add a, b
                    st a, dx
                    ldi c, 29
                    ldi d, mesh_cache_color
                    jmp set_bank

;===================================================================================================
; Банк памяти #11
;===================================================================================================

; Перспектива x=8+round(16*x/z), y=8+round(-16*y/z); целочисленное деление.
project_perspective:
                    ld a, wx
                    ld b, wz
                    ldi c, 11
                    st c, ret3_bank
                    ldi d, resume_project_perspective_2
                    st d, ret3_addr
                    ldi c, 12
                    ldi d, gfx_divide_projection
                    jmp set_bank
resume_project_perspective_2:
                    st a, wx
                    ld a, wy
                    neg a
                    ld b, wz
                    ldi c, 11
                    st c, ret3_bank
                    ldi d, resume_project_perspective_7
                    st d, ret3_addr
                    ldi c, 12
                    ldi d, gfx_divide_projection
                    jmp set_bank
resume_project_perspective_7:
                    st a, wy
                    ldi a, 1
                    st a, wz
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; Цвет примитива: из модели, чередование синий/красный или единый заданный цвет.
gfx_resolve_color:
                    st a, color
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_MODE
                    ldi d, io_gfx_resolve_color_1
                    jmp read_byte
io_gfx_resolve_color_1:
                    test a
                    jz color_ready
                    dec a
                    jnz color_solid
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_PHASE
                    ldi d, io_gfx_resolve_color_6
                    jmp read_byte
io_gfx_resolve_color_6:
                    ldi b, 3
                    xor a, b
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_PHASE
                    ldi d, io_gfx_resolve_color_9
                    jmp write_byte
io_gfx_resolve_color_9:
                    st a, color
                    jmp color_ready
color_solid:
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR
                    ldi d, io_gfx_resolve_color_13
                    jmp read_byte
io_gfx_resolve_color_13:
                    st a, color
color_ready:
                    ld a, color
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank
padding11 db 0,0,0,0

;===================================================================================================
; Банк памяти #12
;===================================================================================================

; A — координата, B — глубина 8…63; вернуть 8+round(16*A/B), сохраняя глубину камеры.
gfx_divide_projection:
                    st b, dy
                    shl a
                    shl a
                    sar a
                    sar a
                    st a, sx
                    test a
                    jns division_positive
                    neg a
division_positive:
                    mov b, a
                    shr b
                    shr b
                    shr b
                    shr b
                    st b, t1
                    shl a
                    shl a
                    shl a
                    shl a
                    st a, t0
                    clr a
                    st a, ru
                    ldi c, 13
                    ldi d, projection_division_loop
                    jmp set_bank

; Вернуть определители к началу строки и сдвинуть их на следующую строку.
triangle_row:
                    ld a, wy
                    inc a
                    st a, wy
                    ldi b, 16
                    xor a, b
                    jz triangle_done
                    clr a
                    st a, wx
                    ld a, sx
                    neg a
                    st a, sx
                    ld a, sy
                    neg a
                    st a, sy
                    ld a, err
                    neg a
                    st a, err
                    ldi a, 15
                    st a, mask
triangle_rewind:
                    ldi c, 12
                    st c, ret2_bank
                    ldi d, resume_triangle_row_20
                    st d, ret2_addr
                    ldi c, 17
                    ldi d, triangle_advance_x
                    jmp set_bank
resume_triangle_row_20:
                    ld a, mask
                    dec a
                    st a, mask
                    jnz triangle_rewind
                    ld a, sx
                    neg a
                    st a, sx
                    ld a, sy
                    neg a
                    st a, sy
                    ld a, err
                    neg a
                    st a, err
                    ldi c, 12
                    st c, ret2_bank
                    ldi d, resume_triangle_row_34
                    st d, ret2_addr
                    ldi c, 20
                    ldi d, triangle_advance_y
                    jmp set_bank
resume_triangle_row_34:
                    ldi c, 20
                    ldi d, triangle_pixel
                    jmp set_bank
triangle_done:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

;===================================================================================================
; Банк памяти #13
;===================================================================================================

; Делить 16-битный числитель вычитанием; частное ограничено 64.
projection_division_loop:
                    ld a, t1
                    test a
                    jnz projection_subtract
                    ld a, t0
                    ld b, dy
                    sub a, b
                    jnc bridge_projection_division_loop_6
                    ldi c, 14
                    ldi d, projection_division_round
                    jmp set_bank
bridge_projection_division_loop_6:
projection_subtract:
                    ld a, t0
                    ld b, dy
                    sub a, b
                    st a, t0
                    ld a, t1
                    ldi b, 0
                    sbb a, b
                    st a, t1
                    ld a, ru
                    inc a
                    st a, ru
                    jmp projection_division_loop

; Выбрать цвет и рисовать ребро при включённом каркасе и видимых концах.
mesh_edge_color:
                    ldi c, 13
                    st c, ret2_bank
                    ldi d, resume_mesh_edge_color_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_edge_color_0:
                    ldi c, 13
                    st c, ret2_bank
                    ldi d, resume_mesh_edge_color_1
                    st d, ret2_addr
                    ldi c, 11
                    ldi d, gfx_resolve_color
                    jmp set_bank
resume_mesh_edge_color_1:
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_RENDER
                    ldi d, io_mesh_edge_color_2
                    jmp read_byte
io_mesh_edge_color_2:
                    ldi b, 1
                    and a, b
                    jz mesh_edge_next
                    ld a, signs
                    ld b, wz
                    and a, b
                    jz mesh_edge_next
                    ldi c, 13
                    st c, ret1_bank
                    ldi d, resume_mesh_edge_color_10
                    st d, ret1_addr
                    ldi c, 17
                    ldi d, gfx_line
                    jmp set_bank
resume_mesh_edge_color_10:
mesh_edge_next:
                    ld a, edge_count
                    dec a
                    st a, edge_count
                    jz bridge_mesh_edge_color_15
                    ldi c, 22
                    ldi d, mesh_edge
                    jmp set_bank
bridge_mesh_edge_color_15:
                    ldi c, 27
                    ldi d, mesh_faces_begin
                    jmp set_bank
padding13 db 0,0,0,0

;===================================================================================================
; Банк памяти #14
;===================================================================================================

; Округлить к ближайшему целому; при половине выбрать чётное частное, затем вернуть знак.
projection_division_round:
                    ld a, t0
                    shl a
                    ld b, dy
                    sub a, b
                    jc projection_rounded
                    jnz projection_increment
                    ld a, ru
                    ldi b, 1
                    and a, b
                    jz projection_rounded
projection_increment:
                    ld a, ru
                    inc a
                    st a, ru
projection_rounded:
                    ld a, sx
                    test a
                    ld a, ru
                    jns projection_positive
                    neg a
projection_positive:
                    ldi b, 8
                    add a, b
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

; Прочитать V,E,T и начать преобразование вершин; цвета выбираются режимом в памяти.
mesh_begin:
                    ldi c, 14
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_0:
                    st a, vertex_count
                    ldi c, 14
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_2
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_2:
                    st a, edge_count
                    ldi c, 14
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_4
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_4:
                    ldi d, 14
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_begin_5
                    jmp write_byte
io_mesh_begin_5:
                    ldi a, 1
                    ldi d, 14
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_PHASE
                    ldi d, io_mesh_begin_7
                    jmp write_byte
io_mesh_begin_7:
                    ldi a, VERTEX_BASE
                    st a, out_bank
                    ldi a, 128
                    st a, out_addr
                    ldi c, 21
                    ldi d, mesh_vertex
                    jmp set_bank
padding14 db 0,0,0

;===================================================================================================
; Банк памяти #15
;===================================================================================================

; A — индекс; вернуть x/y/видимость и глубину из четырёхбайтовой экранной вершины.
gfx_get_vertex:
                    mov b, a
                    ldi c, 31
                    and b, c
                    shl b
                    shl b
                    ldi c, 128
                    add b, c
                    st b, out_addr
                    shr a
                    shr a
                    shr a
                    shr a
                    shr a
                    ldi c, VERTEX_BASE
                    add a, c
                    st a, out_bank
                    ldi c, 15
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_16
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_gfx_get_vertex_16:
                    st a, wx
                    ldi c, 15
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_18
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_gfx_get_vertex_18:
                    st a, wy
                    ldi c, 15
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_20
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_gfx_get_vertex_20:
                    st a, wz
                    ldi c, 15
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_22
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_gfx_get_vertex_22:
                    st a, depth
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; Добавить знаковые приращения wx/wy/wz к углам Y/X/Z по модулю 32.
gfx_rotate:
                    ld a, yaw
                    ld b, wx
                    add a, b
                    ldi b, 31
                    and a, b
                    st a, yaw
                    ld a, pitch
                    ld b, wy
                    add a, b
                    ldi b, 31
                    and a, b
                    st a, pitch
                    ld a, roll
                    ld b, wz
                    add a, b
                    ldi b, 31
                    and a, b
                    st a, roll
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding15 db 0

;===================================================================================================
; Банк памяти #16
;===================================================================================================

; gfx_pixel заменяет цвет; gfx_line_pixel складывает цветовые биты. wz — рабочий флаг.
gfx_pixel:
                    clr a
                    st a, wz
                    jmp pixel_prepare
gfx_line_pixel:
                    ldi a, 1
                    st a, wz
pixel_prepare:
                    ld a, wx
                    ld b, wy
                    or a, b
                    ldi b, 240
                    and a, b
                    jnz pixel_done
                    ld b, wy
                    shl b
                    ld a, wx
                    mov c, a
                    shr a
                    shr a
                    shr a
                    add b, a
                    ldi a, 64
                    add b, a
                    st b, ru
                    mov a, c
                    ldi b, 7
                    and a, b
                    ldi b, pixel_masks
                    add a, b
                    ld a, a
                    st a, mask
                    ld b, ru
                    ld a, b
                    st a, t0
                    ld a, color
                    ldi b, 1
                    and a, b
                    ld a, t0
                    ld b, mask
                    jnz pixel_red_set
                    ld c, wz
                    test c
                    jnz pixel_red_write
                    not b
                    and a, b
                    jmp pixel_red_write
pixel_red_set:
                    or a, b
pixel_red_write:
                    ld b, ru
                    st a, b
                    ld a, ru
                    ldi b, 32
                    add a, b
                    st a, ru
                    jmp pixel_blue

; Маски пикселей; старший бит слева.
pixel_masks db 128,64,32,16,8,4,2,1

; Синий слой: линии сохраняют красный бит, пиксели и треугольники заменяют цвет.
pixel_blue:
                    ld b, ru
                    ld a, b
                    st a, t0
                    ld a, color
                    ldi b, 2
                    and a, b
                    ld a, t0
                    ld b, mask
                    jnz pixel_blue_set
                    ld c, wz
                    test c
                    jnz pixel_blue_write
                    not b
                    and a, b
                    jmp pixel_blue_write
pixel_blue_set:
                    or a, b
pixel_blue_write:
                    ld b, ru
                    st a, b
pixel_done:
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank
padding16 db 0,0,0

;===================================================================================================
; Банк памяти #17
;===================================================================================================

; Цветная линия Брезенхэма; экран отсекается проверкой координат каждого пикселя.
gfx_line:
                    ld a, x1
                    ld b, x0
                    sub a, b
                    ldi b, 1
                    jns full_x_positive
                    neg a
                    neg b
full_x_positive:
                    st a, dx
                    st b, sx
                    ld a, y1
                    ld b, y0
                    sub a, b
                    ldi b, 1
                    jns full_y_positive
                    neg a
                    neg b
full_y_positive:
                    st a, dy
                    st b, sy
                    ld a, dx
                    ld b, dy
                    sub a, b
                    ldi b, 0
                    jnc line_x_major
                    inc b
                    ld a, dy
                    jmp line_major_ready
line_x_major:
                    ld a, dx
line_major_ready:
                    st b, angle
                    inc a
                    st a, x1
                    dec a
                    dec a
                    sar a
                    st a, err
                    ldi c, 5
                    ldi d, line_pixel
                    jmp set_bank

; Прибавить три знаковых приращения к 16-битным определителям.
triangle_advance_x:
                    ld a, x0
                    ld b, sx
                    ldi c, 0
                    test b
                    jns advance_x_0
                    dec c
advance_x_0:
                    add a, b
                    st a, x0
                    ld a, y0
                    adc a, c
                    st a, y0
                    ld a, x1
                    ld b, sy
                    ldi c, 0
                    test b
                    jns advance_x_1
                    dec c
advance_x_1:
                    add a, b
                    st a, x1
                    ld a, y1
                    adc a, c
                    st a, y1
                    ld a, dx
                    ld b, err
                    ldi c, 0
                    test b
                    jns advance_x_2
                    dec c
advance_x_2:
                    add a, b
                    st a, dx
                    ld a, dy
                    adc a, c
                    st a, dy
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank
padding17 db 0,0,0,0,0,0

;===================================================================================================
; Банк памяти #18
;===================================================================================================

; Общий 16-битный определитель: A/B — адреса X концов ребра в COMMON; Y лежит следующим байтом.
triangle_determinant:
                    st a, angle
                    st b, mask
                    ld b, mask
                    ld a, b
                    ld b, angle
                    ld b, b
                    sub a, b
                    st a, ru
                    ld a, wy
                    ld b, angle
                    inc b
                    ld b, b
                    sub a, b
                    st a, rv
                    ldi c, 18
                    st c, ret3_bank
                    ldi d, resume_triangle_determinant_14
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_mul16
                    jmp set_bank
resume_triangle_determinant_14:
                    ld a, t0
                    st a, sx
                    ld a, t1
                    st a, sy
                    ld b, mask
                    inc b
                    ld a, b
                    ld b, angle
                    inc b
                    ld b, b
                    sub a, b
                    st a, ru
                    ld a, wx
                    ld b, angle
                    ld b, b
                    sub a, b
                    st a, rv
                    ldi c, 18
                    st c, ret3_bank
                    ldi d, resume_triangle_determinant_32
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_mul16
                    jmp set_bank
resume_triangle_determinant_32:
                    ld a, sx
                    ld b, t0
                    sub a, b
                    st a, sx
                    ld a, sy
                    ld b, t1
                    sbb a, b
                    st a, sy
                    ld a, out_addr
                    test a
                    jz bridge_triangle_determinant_43
                    ldi c, 24
                    ldi d, triangle_save
                    jmp set_bank
bridge_triangle_determinant_43:
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Выбрать ребро и место начального определителя; общая часть вычисляет также приращения.
triangle_init0:
                    ldi a, TRI_STATE0
                    st a, out_addr
                    ldi a, x0
                    ldi b, x1
                    jmp triangle_determinant

; Выбрать ребро и место начального определителя; общая часть вычисляет также приращения.
triangle_init2:
                    ldi a, TRI_STATE4
                    st a, out_addr
                    ldi a, dx
                    ldi b, x0
                    jmp triangle_determinant

;===================================================================================================
; Банк памяти #19
;===================================================================================================

; Определитель первого ребра и третьей вершины; нулевая площадь не заполняется.
triangle_area:
                    clr a
                    st a, out_addr
                    ldi a, x0
                    ldi b, x1
                    ldi c, 18
                    ldi d, triangle_determinant
                    jmp set_bank

; Выбрать ребро и место начального определителя; общая часть вычисляет также приращения.
triangle_init1:
                    ldi a, TRI_STATE2
                    st a, out_addr
                    ldi a, x1
                    ldi b, dx
                    ldi c, 18
                    ldi d, triangle_determinant
                    jmp set_bank

; Подготовить рёбра треугольника x0/y0, x1/y1, dx/dy; нулевая площадь пропускается.
gfx_triangle:
                    ld a, dx
                    st a, wx
                    ld a, dy
                    st a, wy
                    ldi c, 19
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_4
                    st d, ret2_addr
                    jmp triangle_area
resume_gfx_triangle_4:
                    ld a, sx
                    ld b, sy
                    or a, b
                    jnz bridge_gfx_triangle_8
                    ldi c, 12
                    ldi d, triangle_done
                    jmp set_bank
bridge_gfx_triangle_8:
                    clr a
                    st a, wx
                    st a, wy
                    ldi c, 19
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_12
                    st d, ret2_addr
                    ldi c, 18
                    ldi d, triangle_init0
                    jmp set_bank
resume_gfx_triangle_12:
                    ldi c, 19
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_13
                    st d, ret2_addr
                    jmp triangle_init1
resume_gfx_triangle_13:
                    ldi c, 19
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_14
                    st d, ret2_addr
                    ldi c, 18
                    ldi d, triangle_init2
                    jmp set_bank
resume_gfx_triangle_14:
                    ldi c, 19
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_15
                    st d, ret2_addr
                    ldi c, 25
                    ldi d, triangle_load0
                    jmp set_bank
resume_gfx_triangle_15:
                    ldi c, 20
                    ldi d, triangle_scan
                    jmp set_bank
padding19 db 0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #20
;===================================================================================================

; Проверить текущие 16-битные значения рёбер; умножения в цикле нет.
triangle_inside:
                    clr a
                    st a, signs
                    ldi c, 21
                    ldi d, triangle_sign0
                    jmp set_bank

; Прибавить три знаковых приращения к 16-битным определителям.
triangle_advance_y:
                    ld a, x0
                    ld b, ret3_bank
                    ldi c, 0
                    test b
                    jns advance_y_0
                    dec c
advance_y_0:
                    add a, b
                    st a, x0
                    ld a, y0
                    adc a, c
                    st a, y0
                    ld a, x1
                    ld b, ret3_addr
                    ldi c, 0
                    test b
                    jns advance_y_1
                    dec c
advance_y_1:
                    add a, b
                    st a, x1
                    ld a, y1
                    adc a, c
                    st a, y1
                    ld a, dx
                    ld b, angle
                    ldi c, 0
                    test b
                    jns advance_y_2
                    dec c
advance_y_2:
                    add a, b
                    st a, dx
                    ld a, dy
                    adc a, c
                    st a, dy
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Заполнять треугольник; во внутреннем цикле только сложения, проверки и запись цвета.
triangle_scan:
triangle_pixel:
                    ldi c, 20
                    st c, ret2_bank
                    ldi d, resume_triangle_scan_1
                    st d, ret2_addr
                    jmp triangle_inside
resume_triangle_scan_1:
                    test a
                    jz triangle_advance
                    ldi c, 20
                    st c, ret2_bank
                    ldi d, resume_triangle_scan_4
                    st d, ret2_addr
                    ldi c, 16
                    ldi d, gfx_pixel
                    jmp set_bank
resume_triangle_scan_4:
triangle_advance:
                    ld a, wx
                    inc a
                    st a, wx
                    ldi b, 16
                    xor a, b
                    jnz bridge_triangle_scan_11
                    ldi c, 12
                    ldi d, triangle_row
                    jmp set_bank
bridge_triangle_scan_11:
                    ldi c, 20
                    st c, ret2_bank
                    ldi d, resume_triangle_scan_12
                    st d, ret2_addr
                    ldi c, 17
                    ldi d, triangle_advance_x
                    jmp set_bank
resume_triangle_scan_12:
                    jmp triangle_pixel

;===================================================================================================
; Банк памяти #21
;===================================================================================================

; Оба ненулевых знака одновременно означают точку вне треугольника.
triangle_sign0:
                    ld a, y0
                    test a
                    js triangle_negative0
                    ld b, x0
                    or a, b
                    jnz bridge_triangle_sign0_5
                    ldi c, 22
                    ldi d, triangle_sign1
                    jmp set_bank
bridge_triangle_sign0_5:
                    ld a, signs
                    ldi b, 2
                    jmp triangle_sign_record0
triangle_negative0:
                    ld a, signs
                    ldi b, 1
triangle_sign_record0:
                    or a, b
                    st a, signs
                    ldi b, 3
                    xor a, b
                    jnz bridge_triangle_sign0_17
                    ldi c, 23
                    ldi d, triangle_inside_no
                    jmp set_bank
bridge_triangle_sign0_17:
                    ldi c, 22
                    ldi d, triangle_sign1
                    jmp set_bank

; Масштаб, вращение Y/X/Z, смещение и выбранная проекция.
mesh_vertex:
                    ldi c, 21
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_0:
                    st a, wx
                    ldi c, 21
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_2
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_2:
                    st a, wy
                    ldi c, 21
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_4
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_4:
                    st a, wz
                    ldi c, 21
                    st c, ret1_bank
                    ldi d, resume_mesh_vertex_6
                    st d, ret1_addr
                    ldi c, 26
                    ldi d, gfx_scale_vertex
                    jmp set_bank
resume_mesh_vertex_6:
                    ldi c, 21
                    st c, ret1_bank
                    ldi d, resume_mesh_vertex_7
                    st d, ret1_addr
                    ldi c, 8
                    ldi d, gfx_project_vertex
                    jmp set_bank
resume_mesh_vertex_7:
                    ldi c, 2
                    ldi d, mesh_store_vertex
                    jmp set_bank

;===================================================================================================
; Банк памяти #22
;===================================================================================================

; Оба ненулевых знака одновременно означают точку вне треугольника.
triangle_sign1:
                    ld a, y1
                    test a
                    js triangle_negative1
                    ld b, x1
                    or a, b
                    jnz bridge_triangle_sign1_5
                    ldi c, 23
                    ldi d, triangle_sign2
                    jmp set_bank
bridge_triangle_sign1_5:
                    ld a, signs
                    ldi b, 2
                    jmp triangle_sign_record1
triangle_negative1:
                    ld a, signs
                    ldi b, 1
triangle_sign_record1:
                    or a, b
                    st a, signs
                    ldi b, 3
                    xor a, b
                    jnz bridge_triangle_sign1_17
                    ldi c, 23
                    ldi d, triangle_inside_no
                    jmp set_bank
bridge_triangle_sign1_17:
                    ldi c, 23
                    ldi d, triangle_sign2
                    jmp set_bank

; Прочитать два индекса ребра и получить экранные координаты его концов.
mesh_edge:
                    ldi c, 22
                    st c, ret2_bank
                    ldi d, resume_mesh_edge_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_edge_0:
                    ldi c, 22
                    st c, ret1_bank
                    ldi d, resume_mesh_edge_1
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_edge_1:
                    ld a, wx
                    st a, x0
                    ld a, wy
                    st a, y0
                    ld a, wz
                    st a, signs
                    ldi c, 22
                    st c, ret2_bank
                    ldi d, resume_mesh_edge_8
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_edge_8:
                    ldi c, 22
                    st c, ret1_bank
                    ldi d, resume_mesh_edge_9
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_edge_9:
                    ld a, wx
                    st a, x1
                    ld a, wy
                    st a, y1
                    ldi c, 13
                    ldi d, mesh_edge_color
                    jmp set_bank

;===================================================================================================
; Банк памяти #23
;===================================================================================================

; Оба ненулевых знака одновременно означают точку вне треугольника.
triangle_sign2:
                    ld a, dy
                    test a
                    js triangle_negative2
                    ld b, dx
                    or a, b
                    jz triangle_inside_yes
                    ld a, signs
                    ldi b, 2
                    jmp triangle_sign_record2
triangle_negative2:
                    ld a, signs
                    ldi b, 1
triangle_sign_record2:
                    or a, b
                    st a, signs
                    ldi b, 3
                    xor a, b
                    jz triangle_inside_no
                    jmp triangle_inside_yes

; Точка внутри или на границе треугольника.
triangle_inside_yes:
                    ldi a, 1
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Точка вне треугольника.
triangle_inside_no:
                    clr a
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Пометить выбранную запись как нарисованную и прочитать её цвет и индексы.
mesh_selected:
                    ldi d, 23
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_BANK
                    ldi d, io_mesh_selected_0
                    jmp read_byte
io_mesh_selected_0:
                    st a, out_bank
                    ldi d, 23
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_ADDR
                    ldi d, io_mesh_selected_2
                    jmp read_byte
io_mesh_selected_2:
                    st a, out_addr
                    clr a
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_5
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_selected_5:
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_6
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_6:
                    st a, color
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_8
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_8:
                    st a, dx
                    ldi c, 3
                    ldi d, mesh_selected_indices
                    jmp set_bank
padding23 db 0,0

;===================================================================================================
; Банк памяти #24
;===================================================================================================

; Сохранить определитель и шаги по X/Y; адреса COMMON позволяют использовать один вычислитель.
triangle_save:
                    ld a, sx
                    ldi d, 24
                    st d, io_ret_bank
                    ldi c, TRI_STATE_BANK
                    ld b, out_addr
                    ldi d, io_triangle_save_1
                    jmp write_byte
io_triangle_save_1:
                    ld a, out_addr
                    inc a
                    st a, out_addr
                    ld a, sy
                    ldi d, 24
                    st d, io_ret_bank
                    ldi c, TRI_STATE_BANK
                    ld b, out_addr
                    ldi d, io_triangle_save_6
                    jmp write_byte
io_triangle_save_6:
                    ld a, out_addr
                    ldi b, TRI_STATE1
                    sub a, b
                    shr a
                    ldi b, TRI_STATE6
                    add a, b
                    st a, out_addr
                    ld b, angle
                    inc b
                    ld a, b
                    ld b, mask
                    inc b
                    ld b, b
                    sub a, b
                    ldi d, 24
                    st d, io_ret_bank
                    ldi c, TRI_STATE_BANK
                    ld b, out_addr
                    ldi d, io_triangle_save_21
                    jmp write_byte
io_triangle_save_21:
                    ld a, out_addr
                    ldi b, 3
                    add a, b
                    st a, out_addr
                    ld b, mask
                    ld a, b
                    ld b, angle
                    ld b, b
                    sub a, b
                    ldi d, 24
                    st d, io_ret_bank
                    ldi c, TRI_STATE_BANK
                    ld b, out_addr
                    ldi d, io_triangle_save_31
                    jmp write_byte
io_triangle_save_31:
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Добавить пять байтов каждой записи треугольника с переносом через границы банков.
object_workspace_triangle:
                    ld a, out_addr
                    ldi b, 5
                    add a, b
                    jnc object_workspace_saved
                    ldi b, 128
                    add a, b
                    ld b, out_bank
                    inc b
                    st b, out_bank
object_workspace_saved:
                    st a, out_addr
                    ld a, edge_count
                    dec a
                    st a, edge_count
                    jnz object_workspace_triangle
                    ldi c, 25
                    ldi d, object_workspace_compare
                    jmp set_bank
padding24 db 0

;===================================================================================================
; Банк памяти #25
;===================================================================================================

; Загрузить двенадцать значений одним циклом по таблице адресов COMMON.
triangle_load0:
                    ldi a, TRI_STATE0
                    st a, ru
                    ldi a, triangle_registers
                    st a, rv
triangle_load_loop:
                    ldi d, 25
                    st d, io_ret_bank
                    ldi c, TRI_STATE_BANK
                    ld b, ru
                    ldi d, io_triangle_load0_5
                    jmp read_byte
io_triangle_load0_5:
                    ld b, rv
                    ld b, b
                    st a, b
                    ld a, ru
                    inc a
                    st a, ru
                    ld b, rv
                    inc b
                    st b, rv
                    ldi b, TRI_STATE_END
                    xor a, b
                    jnz triangle_load_loop
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; Адреса переменных для значений и приращений трёх рёбер.
triangle_registers db x0,y0,x1,y1,dx,dy,sx,sy,err,ret3_bank,ret3_addr,angle

; Разрешить рисование при достаточном буфере; сохранить геометрию модели.
object_workspace_compare:
                    ldi d, 25
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_BANK
                    ldi d, io_object_workspace_compare_0
                    jmp read_byte
io_object_workspace_compare_0:
                    ld b, out_bank
                    sub b, a
                    jc object_ready
                    jnz object_failed
                    ldi d, 25
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_ADDR
                    ldi d, io_object_workspace_compare_5
                    jmp read_byte
io_object_workspace_compare_5:
                    ld b, out_addr
                    sub b, a
                    jc object_ready
                    jz object_ready
object_failed:
                    clr a
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank
object_ready:
                    ldi a, 1
                    ldi d, 25
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_object_workspace_compare_15
                    jmp write_byte
io_object_workspace_compare_15:
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank
padding25 db 0,0,0,0,0,0

;===================================================================================================
; Банк памяти #26
;===================================================================================================

; Масштабировать три соседних координаты одним циклом: знаковое произведение и деление на 32.
gfx_scale_vertex:
                    ldi a, wx
                    st a, dx
scale_coordinate:
                    ld b, dx
                    ld a, b
                    st a, ru
                    ldi d, 26
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_SCALE
                    ldi d, io_gfx_scale_vertex_6
                    jmp read_byte
io_gfx_scale_vertex_6:
                    st a, rv
                    ldi c, 26
                    st c, ret3_bank
                    ldi d, resume_gfx_scale_vertex_8
                    st d, ret3_addr
                    ldi c, 4
                    ldi d, gfx_mul16
                    jmp set_bank
resume_gfx_scale_vertex_8:
                    ld a, t0
                    ld b, t1
                    sar b
                    rcr a
                    sar b
                    rcr a
                    sar b
                    rcr a
                    sar b
                    rcr a
                    sar b
                    rcr a
                    ld b, dx
                    st a, b
                    inc b
                    st b, dx
                    ldi a, ru
                    xor a, b
                    jnz scale_coordinate
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; Найти максимальную сумму глубин среди ещё не нарисованных треугольников.
mesh_select:
                    clr a
                    st a, dx
                    ldi d, 26
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_select_2
                    jmp read_byte
io_mesh_select_2:
                    st a, edge_count
                    ldi d, 26
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_BANK
                    ldi d, io_mesh_select_4
                    jmp read_byte
io_mesh_select_4:
                    st a, out_bank
                    ldi d, 26
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_ADDR
                    ldi d, io_mesh_select_6
                    jmp read_byte
io_mesh_select_6:
                    st a, out_addr
                    ldi c, 30
                    ldi d, mesh_scan
                    jmp set_bank
padding26 db 0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #27
;===================================================================================================

; Подготовить пятибайтовые записи треугольников: сумма глубин, цвет, три индекса.
mesh_faces_begin:
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_RENDER
                    ldi d, io_mesh_faces_begin_0
                    jmp read_byte
io_mesh_faces_begin_0:
                    ldi b, 2
                    and a, b
                    jz mesh_done
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_faces_begin_4
                    jmp read_byte
io_mesh_faces_begin_4:
                    test a
                    jz mesh_done
                    st a, vertex_count
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_BANK
                    ldi d, io_mesh_faces_begin_8
                    jmp read_byte
io_mesh_faces_begin_8:
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_faces_begin_9
                    jmp write_byte
io_mesh_faces_begin_9:
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_ADDR
                    ldi d, io_mesh_faces_begin_10
                    jmp read_byte
io_mesh_faces_begin_10:
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_faces_begin_11
                    jmp write_byte
io_mesh_faces_begin_11:
                    ldi c, 28
                    ldi d, mesh_cache_face0
                    jmp set_bank

; Каждый кадр сортируется заново по текущим координатам камеры.
mesh_sort_start:
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_sort_start_0
                    jmp read_byte
io_mesh_sort_start_0:
                    st a, vertex_count
                    ldi c, 26
                    ldi d, mesh_select
                    jmp set_bank

; Завершить модель после всех видимых треугольников.
mesh_selected_next:
                    ld a, vertex_count
                    dec a
                    st a, vertex_count
                    jz bridge_mesh_selected_next_3
                    ldi c, 26
                    ldi d, mesh_select
                    jmp set_bank
bridge_mesh_selected_next_3:
mesh_done:
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank
padding27 db 0

;===================================================================================================
; Банк памяти #28
;===================================================================================================

; Прочитать индекс и добавить глубину камеры; сохранить общую видимость.
mesh_cache_face0:
                    ldi c, 28
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face0_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face0_0:
                    st a, x0
                    ldi c, 28
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face0_2
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_cache_face0_2:
                    ld a, wz
                    st a, signs
                    ld a, depth
                    st a, dx
                    ldi c, 29
                    ldi d, mesh_cache_face1
                    jmp set_bank

; Продолжить буфер через границу банка и обработать следующий треугольник.
mesh_cache_write1:
                    ld a, y0
                    ldi c, 28
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write1_1
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write1_1:
                    ld a, x1
                    ldi c, 28
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write1_3
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write1_3:
                    ld a, out_bank
                    ldi d, 28
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_cache_write1_5
                    jmp write_byte
io_mesh_cache_write1_5:
                    ld a, out_addr
                    ldi d, 28
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_cache_write1_7
                    jmp write_byte
io_mesh_cache_write1_7:
                    ld a, vertex_count
                    dec a
                    st a, vertex_count
                    jnz mesh_cache_face0
                    ldi c, 27
                    ldi d, mesh_sort_start
                    jmp set_bank
padding28 db 0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #29
;===================================================================================================

; Прочитать индекс и добавить глубину камеры; сохранить общую видимость.
mesh_cache_face1:
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face1_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face1_0:
                    st a, y0
                    ldi c, 29
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face1_2
                    st d, ret1_addr
                    ldi c, 15
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_cache_face1_2:
                    ld a, wz
                    ld b, signs
                    and a, b
                    st a, signs
                    ld a, depth
                    ld b, dx
                    add a, b
                    st a, dx
                    ldi c, 10
                    ldi d, mesh_cache_face2
                    jmp set_bank

; Нулевая глубина записи означает невидимый или уже нарисованный треугольник.
mesh_cache_color:
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_color_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_color_0:
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_color_1
                    st d, ret2_addr
                    ldi c, 11
                    ldi d, gfx_resolve_color
                    jmp set_bank
resume_mesh_cache_color_1:
                    ld a, signs
                    test a
                    jnz mesh_cache_visible
                    clr a
                    st a, dx
mesh_cache_visible:
                    ldi d, 29
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_cache_color_8
                    jmp read_byte
io_mesh_cache_color_8:
                    st a, out_bank
                    ldi d, 29
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_cache_color_10
                    jmp read_byte
io_mesh_cache_color_10:
                    st a, out_addr
                    ldi c, 8
                    ldi d, mesh_cache_write0
                    jmp set_bank
padding29 db 0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #30
;===================================================================================================

; При равной глубине сохранять исходный порядок; ближние записи не заменяют дальнюю.
mesh_scan:
                    ld a, out_bank
                    st a, x0
                    ld a, out_addr
                    st a, y0
                    ldi c, 30
                    st c, ret2_bank
                    ldi d, resume_mesh_scan_4
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_scan_4:
                    ld b, dx
                    sub b, a
                    jnc mesh_scan_next
                    st a, dx
                    ld a, x0
                    ldi d, 30
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_BANK
                    ldi d, io_mesh_scan_10
                    jmp write_byte
io_mesh_scan_10:
                    ld a, y0
                    ldi d, 30
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_ADDR
                    ldi d, io_mesh_scan_12
                    jmp write_byte
io_mesh_scan_12:
                    jmp mesh_scan_next

; Пропустить четыре поля записи; указатель корректно пересекает границы 128-байтовых банков.
mesh_scan_next:
                    ld a, out_addr
                    ldi b, 4
                    add a, b
                    jnc mesh_scan_no_wrap
                    ldi b, 128
                    add a, b
                    ld b, out_bank
                    inc b
                    st b, out_bank
mesh_scan_no_wrap:
                    st a, out_addr
                    ld a, edge_count
                    dec a
                    st a, edge_count
                    jnz mesh_scan
                    ld a, dx
                    test a
                    jnz bridge_mesh_scan_next_17
                    ldi c, 27
                    ldi d, mesh_done
                    jmp set_bank
bridge_mesh_scan_next_17:
                    ldi c, 23
                    ldi d, mesh_selected
                    jmp set_bank

; wx/wy/wz — абсолютные углы Y/X/Z в шагах 11,25°.
gfx_set_rotation:
                    ldi b, 31
                    ld a, wx
                    and a, b
                    st a, yaw
                    ld a, wy
                    and a, b
                    st a, pitch
                    ld a, wz
                    and a, b
                    st a, roll
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding30 db 0,0,0,0,0

;===================================================================================================
; Банк памяти #31
;===================================================================================================

; При включённом отсечении пропустить обратные и вырожденные грани; затем рисовать от дальних к ближним.
mesh_selected_cull:
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CULL
                    ldi d, io_mesh_selected_cull_0
                    jmp read_byte
io_mesh_selected_cull_0:
                    test a
                    jz mesh_selected_draw
                    ld a, dx
                    st a, wx
                    ld a, dy
                    st a, wy
                    ldi c, 31
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_cull_7
                    st d, ret2_addr
                    ldi c, 19
                    ldi d, triangle_area
                    jmp set_bank
resume_mesh_selected_cull_7:
                    ld a, sy
                    test a
                    jns bridge_mesh_selected_cull_10
                    ldi c, 27
                    ldi d, mesh_selected_next
                    jmp set_bank
bridge_mesh_selected_cull_10:
                    ld b, sx
                    or a, b
                    jnz bridge_mesh_selected_cull_13
                    ldi c, 27
                    ldi d, mesh_selected_next
                    jmp set_bank
bridge_mesh_selected_cull_13:
mesh_selected_draw:
                    ldi c, 31
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_cull_15
                    st d, ret1_addr
                    ldi c, 19
                    ldi d, gfx_triangle
                    jmp set_bank
resume_mesh_selected_cull_15:
                    ldi c, 27
                    ldi d, mesh_selected_next
                    jmp set_bank

; out_bank/out_addr — конец рабочего буфера, исключающий последний адрес; затем привязать модель.
gfx_set_workspace:
                    ld a, out_bank
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_BANK
                    ldi d, io_gfx_set_workspace_1
                    jmp write_byte
io_gfx_set_workspace_1:
                    ld a, out_addr
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_ADDR
                    ldi d, io_gfx_set_workspace_3
                    jmp write_byte
io_gfx_set_workspace_3:
                    clr a
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_gfx_set_workspace_5
                    jmp write_byte
io_gfx_set_workspace_5:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding31 db 0,0

;===================================================================================================
; Банк памяти #32
;===================================================================================================

; Начало рабочих треугольников после 4V байт экранных вершин.
object_workspace:
                    ld a, vertex_count
                    mov b, a
                    ldi c, 31
                    and b, c
                    shl b
                    shl b
                    ldi c, 128
                    add b, c
                    st b, out_addr
                    shr a
                    shr a
                    shr a
                    shr a
                    shr a
                    ldi b, VERTEX_BASE
                    add a, b
                    st a, out_bank
                    ld a, edge_count
                    test a
                    jnz bridge_object_workspace_19
                    ldi c, 25
                    ldi d, object_workspace_compare
                    jmp set_bank
bridge_object_workspace_19:
                    ldi c, 24
                    ldi d, object_workspace_triangle
                    jmp set_bank

; Добавить знаковые wx/wy/wz к положению объекта.
gfx_move:
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_gfx_move_0
                    jmp read_byte
io_gfx_move_0:
                    ld b, wx
                    add a, b
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_gfx_move_3
                    jmp write_byte
io_gfx_move_3:
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_gfx_move_4
                    jmp read_byte
io_gfx_move_4:
                    ld b, wy
                    add a, b
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_gfx_move_7
                    jmp write_byte
io_gfx_move_7:
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TZ
                    ldi d, io_gfx_move_8
                    jmp read_byte
io_gfx_move_8:
                    ld b, wz
                    add a, b
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TZ
                    ldi d, io_gfx_move_11
                    jmp write_byte
io_gfx_move_11:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding32 db 0

;===================================================================================================
; Банк памяти #33
;===================================================================================================

; Параметры одного объекта и указатели рабочего буфера.
graphics_state db 0,32,0,0,128,0,128,1,0,3,0,1,0,0,0,0,0,128,1,35,128,35,128

; Четверть синуса: семь 32-битных масок приращений.
rotation_lut db 132,16,130,16,74,74,73,73,85,171,86,173,221,118,187,221,251,190,239,251,191,255,247,255,255,255,255,251

; A — новое значение STATE_SCALE.
gfx_set_scale:
                    st a, STATE_SCALE
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A — новое значение STATE_PROJECTION.
gfx_set_projection:
                    st a, STATE_PROJECTION
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A — новое значение STATE_RENDER.
gfx_set_render_mode:
                    ldi b, 3
                    and a, b
                    st a, STATE_RENDER
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A — новое значение STATE_COLOR_MODE.
gfx_set_color_mode:
                    st a, STATE_COLOR_MODE
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A — новое значение STATE_COLOR.
gfx_set_color:
                    ldi b, 3
                    and a, b
                    st a, STATE_COLOR
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A — новое значение STATE_CULL.
gfx_set_cull:
                    st a, STATE_CULL
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; wx/wy/wz — абсолютное положение объекта.
gfx_set_position:
                    ld a, wx
                    st a, STATE_TX
                    ld a, wy
                    st a, STATE_TY
                    ld a, wz
                    st a, STATE_TZ
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding33 db 0,0,0,0,0

;===================================================================================================
; Банк памяти #34
;===================================================================================================

; Определители трёх рёбер и их приращения.
triangle_state db 0,0,0,0,0,0,0,0,0,0,0,0

; Отключить обновление дисплея и очистить оба слоя LCD RAM.
gfx_begin:
                    clr a
                    st a, 0x3E
                    ldi b, 64
                    ldi c, 64
begin_loop:
                    st a, b
                    inc b
                    dec c
                    jnz begin_loop
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank

; Включить цветной дисплей и повторно записать 64 готовых байта LCD RAM.
gfx_present:
                    ldi a, 48
                    st a, 0x3E
                    ldi b, 64
                    ldi d, 64
present_loop:
                    ld a, b
                    st a, b
                    inc b
                    dec d
                    jnz present_loop
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank
padding34 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; Конец общего модуля 3DGraphics.

; Банк памяти #35: Экранные вершины x,y,visible,depth.
projected_vertices db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Банк памяти #35: Рабочие треугольники: глубина,цвет,a,b,c.
triangle_cache db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Банк памяти #36: Рабочие треугольники: глубина,цвет,a,b,c.
triangle_cache_56 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Банк памяти #36: Одна модель: V,E,T; XYZ; a,b,color; a,b,c,color.
model_data db 18,27,32,5,252,0,4,252,3,1,252,5,253,252,5,251,252,2,251,252,254,253,252,251

; Банк памяти #37: Одна модель: V,E,T; XYZ; a,b,color; a,b,c,color.
model_data_24 db 1,252,251,4,252,253,5,4,0,4,4,3,1,4,5,253,4,5,251,4,2,251,4,254,253,4,251,1,4,251,4,4,253,0,1,1,1,10,1,10,9,1,9,0,1,1,2,2,2,11,2,11,10,2,2,3,1,3,12,1,12,11,1,3,4,2,4,13,2,13,12,2,4,5,1,5,14,1,14,13,1,5,6,2,6,15,2,15,14,2,6,7,1,7,16,1,16,15,1,7,8,2,8,17,2,17,16,2,8,0,1,9,17,1,0,10,1,1,0,9,10,1,1,11,2,2,1,10

; Банк памяти #38: Одна модель: V,E,T; XYZ; a,b,color; a,b,c,color.
model_data_152 db 11,2,2,12,3,1,2,11,12,1,3,13,4,2,3,12,13,2,4,14,5,1,4,13,14,1,5,15,6,2,5,14,15,2,6,16,7,1,6,15,16,1,7,17,8,2,7,16,17,2,8,9,0,1,8,17,9,1,0,1,2,3,0,2,3,3,0,3,4,3,0,4,5,3,0,5,6,3,0,6,7,3,0,7,8,3,9,11,10,3,9,12,11,3,9,13,12,3,9,14,13,3,9,15,14,3,9,16,15,3,9,17,16,3
data_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #39
;===================================================================================================

; Привязать одну модель и выделить её рабочий буфер.
main:
                    ldi a, 48
                    st a, 0x3E
                    ldi a, MODEL_BASE
                    st a, out_bank
                    ldi a, MODEL_ADDR
                    st a, out_addr
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_main_6
                    st d, ret1_addr
                    ldi c, 31
                    ldi d, gfx_set_workspace
                    jmp set_bank
resume_main_6:
                    ldi a, MODEL_BASE
                    st a, ptr_bank
                    ldi a, MODEL_ADDR
                    st a, ptr_addr
                    ldi c, 39
                    st c, ret0_bank
                    ldi d, resume_main_11
                    st d, ret0_addr
                    ldi c, 1
                    ldi d, gfx_load_model
                    jmp set_bank
resume_main_11:
                    jmp main_modes

; Задать проекцию, примитивы, цвета и отсечение вызовами общего API.
main_modes:
                    ldi a, DEMO_PROJECTION
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_main_modes_1
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_projection
                    jmp set_bank
resume_main_modes_1:
                    ldi a, DEMO_RENDER
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_main_modes_3
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_render_mode
                    jmp set_bank
resume_main_modes_3:
                    ldi a, DEMO_COLOR_MODE
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_main_modes_5
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_color_mode
                    jmp set_bank
resume_main_modes_5:
                    ldi a, DEMO_CULL
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_main_modes_7
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_cull
                    jmp set_bank
resume_main_modes_7:
                    ldi c, 40
                    ldi d, frame_start
                    jmp set_bank
padding39 db 0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #40
;===================================================================================================

; Все оси меняются постепенно: Y=n/4, X=n/2, Z=3n/4, по модулю 32.
frame_start:
                    ldi d, 40
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_start_0
                    jmp read_byte
io_frame_start_0:
                    shr a
                    shr a
                    ldi b, 31
                    and a, b
                    st a, wx
                    ldi d, 40
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_start_6
                    jmp read_byte
io_frame_start_6:
                    shr a
                    ldi b, 31
                    and a, b
                    st a, wy
                    ldi d, 40
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_start_11
                    jmp read_byte
io_frame_start_11:
                    mov b, a
                    shl a
                    add a, b
                    shr a
                    shr a
                    ldi b, 31
                    and a, b
                    st a, wz
                    ldi c, 40
                    st c, ret1_bank
                    ldi d, resume_frame_start_20
                    st d, ret1_addr
                    ldi c, 30
                    ldi d, gfx_set_rotation
                    jmp set_bank
resume_frame_start_20:
                    ldi c, 41
                    ldi d, frame_scale
                    jmp set_bank
padding40 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Банк памяти #41
;===================================================================================================

; Полный цикл ×2 → ×1 → ×2 за 256 кадров, как у демонстрации 1K.
frame_scale:
                    ldi d, 41
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_scale_0
                    jmp read_byte
io_frame_scale_0:
                    ldi b, 128
                    sub a, b
                    jns scale_phase_positive
                    neg a
scale_phase_positive:
                    shr a
                    shr a
                    ldi b, 32
                    add a, b
                    ldi c, 41
                    st c, ret1_bank
                    ldi d, resume_frame_scale_10
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_scale
                    jmp set_bank
resume_frame_scale_10:
                    jmp frame_draw

; Построить модель в LCD RAM при отключённом выводе и опубликовать 64 готовых байта.
frame_draw:
                    ldi c, 41
                    st c, ret0_bank
                    ldi d, resume_frame_draw_0
                    st d, ret0_addr
                    ldi c, 34
                    ldi d, gfx_begin
                    jmp set_bank
resume_frame_draw_0:
                    ldi c, 41
                    st c, ret0_bank
                    ldi d, resume_frame_draw_1
                    st d, ret0_addr
                    ldi c, 6
                    ldi d, gfx_draw_object
                    jmp set_bank
resume_frame_draw_1:
                    ldi c, 41
                    st c, ret0_bank
                    ldi d, resume_frame_draw_2
                    st d, ret0_addr
                    ldi c, 34
                    ldi d, gfx_present
                    jmp set_bank
resume_frame_draw_2:
                    jmp frame_advance

; Следующая фаза 0…255; кадры 0 и 128 имеют одинаковый ракурс и вдвое разные XYZ.
frame_advance:
frame_complete:
                    ldi d, 41
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_advance_1
                    jmp read_byte
io_frame_advance_1:
                    inc a
                    ldi d, 41
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_advance_3
                    jmp write_byte
io_frame_advance_3:
                    ldi c, 40
                    ldi d, frame_start
                    jmp set_bank
