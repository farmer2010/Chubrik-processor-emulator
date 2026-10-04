; 3DGraphics: cube; РїСЂРёР»РѕР¶РµРЅРёРµ polygons.
MODEL_BASE               equ 35
MODEL_ADDR               equ 220
APP_BANK                 equ 37
MAX_VERTICES             equ 8
MAX_TRIANGLES            equ 12
DEMO_PROJECTION          equ 0
DEMO_RENDER              equ 2
DEMO_COLOR_MODE          equ 1
DEMO_CULL                equ 1
TRI_BUFFER_BASE          equ 35
TRI_BUFFER_ADDR          equ 160
FRAME_ADVANCE_BANK       equ 39

; РќР°С‡Р°Р»Рѕ РѕР±С‰РµРіРѕ РјРѕРґСѓР»СЏ 3DGraphics.
; 3DGraphics вЂ” РµРґРёРЅС‹Р№ ASM API РґР»СЏ РѕРґРЅРѕРіРѕ Р°РєС‚РёРІРЅРѕРіРѕ РѕР±СЉРµРєС‚Р°.
; РџР°СЂР°РјРµС‚СЂС‹ РїСЂРѕРµРєС†РёРё, РїСЂРёРјРёС‚РёРІРѕРІ, С†РІРµС‚Р° Рё РїСЂРµРѕР±СЂР°Р·РѕРІР°РЅРёР№ С…СЂР°РЅСЏС‚СЃСЏ РІ РїР°РјСЏС‚Рё.
; РџСЂРёР»РѕР¶РµРЅРёРµ Р·Р°РґР°С‘С‚ APP_BANK Рё РјРµС‚РєСѓ main, РІС‹РґРµР»СЏРµС‚ СЂР°Р±РѕС‡РёРµ РјР°СЃСЃРёРІС‹ Рё СЂР°Р·РјРµС‰Р°РµС‚ РјРѕРґРµР»Рё.

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
EDGE_STRIDE              equ 2
PROJECTION_PERSPECTIVE   equ 0
PROJECTION_PARALLEL      equ 1
RENDER_WIREFRAME         equ 1
RENDER_POLYGONS          equ 2
RENDER_BOTH              equ 3
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
GFX_GET_VERTEX_BANK      equ 3
GFX_SET_ROTATION_BANK    equ 3
GFX_SINE_PRODUCT_BANK    equ 4
GFX_MUL16_BANK           equ 4
GFX_ROTATE_PAIR_BANK     equ 7
GFX_PROJECT_VERTEX_BANK  equ 8
GFX_DIVIDE_PROJECTION_BANK equ 12
GFX_MOVE_BANK            equ 13
GFX_ROTATE_BANK          equ 14
GFX_PIXEL_BANK           equ 15
GFX_LINE_PIXEL_BANK      equ 15
GFX_LINE_BANK            equ 16
GFX_TRIANGLE_BANK        equ 23
GFX_SCALE_VERTEX_BANK    equ 27
GFX_DRAW_MESH_BANK       equ 29
GFX_DRAW_OBJECT_BANK     equ 29
GFX_RESOLVE_COLOR_BANK   equ 31
GFX_SET_WORKSPACE_BANK   equ 32
GFX_SET_SCALE_BANK       equ 33
GFX_SET_PROJECTION_BANK  equ 33
GFX_SET_RENDER_MODE_BANK equ 33
GFX_SET_COLOR_MODE_BANK  equ 33
GFX_SET_COLOR_BANK       equ 33
GFX_SET_CULL_BANK        equ 33
GFX_SET_POSITION_BANK    equ 33
GFX_BEGIN_BANK           equ 34
GFX_PRESENT_BANK         equ 34

; РћР±С‰Р°СЏ РѕР±Р»Р°СЃС‚СЊ CPU.
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
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #1
;===================================================================================================

; РџСЂРѕС‡РёС‚Р°С‚СЊ СЃР»РµРґСѓСЋС‰РёР№ Р±Р°Р№С‚ РјРѕРґРµР»Рё; РїРµСЂРµС…РѕРґРёС‚СЊ С‡РµСЂРµР· РіСЂР°РЅРёС†С‹ Р±Р°РЅРєРѕРІ.
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

; B вЂ” Р°РґСЂРµСЃ РїРѕР»СЏ СѓРєР°Р·Р°С‚РµР»СЏ РІ COMMON; Р±Р°РЅРє Р»РµР¶РёС‚ РїСЂРµРґС‹РґСѓС‰РёРј Р±Р°Р№С‚РѕРј. A СЃРѕС…СЂР°РЅСЏРµС‚СЃСЏ.
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

; РџСЂРёРІСЏР·Р°С‚СЊ РѕРґРЅСѓ РјРѕРґРµР»СЊ; РїСЂРѕРІРµСЂРёС‚СЊ 4V+5T Р±Р°Р№С‚ СЂР°Р±РѕС‡РµРіРѕ Р±СѓС„РµСЂР°. A=1 вЂ” РіРѕС‚РѕРІРѕ, A=0 вЂ” РѕС€РёР±РєР°.
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
                    ldi c, 26
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
                    ldi c, 14
                    ldi d, object_workspace
                    jmp set_bank
padding1 db 0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #2
;===================================================================================================

; Р—Р°РїРёСЃР°С‚СЊ СЃР»РµРґСѓСЋС‰РёР№ Р±Р°Р№С‚ РІ Р±СѓС„РµСЂ СЌРєСЂР°РЅРЅС‹С… РІРµСЂС€РёРЅ.
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

; CPU РІС‹С‡РёСЃР»СЏРµС‚ РєР°Р¶РґСѓСЋ СЌРєСЂР°РЅРЅСѓСЋ РІРµСЂС€РёРЅСѓ РѕРґРёРЅ СЂР°Р·; СЂРµР·СѓР»СЊС‚Р°С‚ вЂ” x/y/РІРёРґРёРјРѕСЃС‚СЊ/РіР»СѓР±РёРЅР°.
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
                    ldi c, 30
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
                    ldi c, 5
                    ldi d, mesh_faces_begin
                    jmp set_bank
bridge_mesh_store_vertex_18:
                    ldi c, 22
                    ldi d, mesh_edge
                    jmp set_bank
padding2 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #3
;===================================================================================================

; РџСЂРѕС‡РёС‚Р°С‚СЊ СЃР»РµРґСѓСЋС‰РёР№ Р±Р°Р№С‚ СЌРєСЂР°РЅРЅРѕР№ РІРµСЂС€РёРЅС‹.
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

; A вЂ” РёРЅРґРµРєСЃ; РІРµСЂРЅСѓС‚СЊ x/y/РІРёРґРёРјРѕСЃС‚СЊ Рё РіР»СѓР±РёРЅСѓ РёР· С‡РµС‚С‹СЂС‘С…Р±Р°Р№С‚РѕРІРѕР№ СЌРєСЂР°РЅРЅРѕР№ РІРµСЂС€РёРЅС‹.
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
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_16
                    st d, ret2_addr
                    jmp gfx_read_output
resume_gfx_get_vertex_16:
                    st a, wx
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_18
                    st d, ret2_addr
                    jmp gfx_read_output
resume_gfx_get_vertex_18:
                    st a, wy
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_20
                    st d, ret2_addr
                    jmp gfx_read_output
resume_gfx_get_vertex_20:
                    st a, wz
                    ldi c, 3
                    st c, ret2_bank
                    ldi d, resume_gfx_get_vertex_22
                    st d, ret2_addr
                    jmp gfx_read_output
resume_gfx_get_vertex_22:
                    st a, depth
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; wx/wy/wz вЂ” Р°Р±СЃРѕР»СЋС‚РЅС‹Рµ СѓРіР»С‹ Y/X/Z РІ С€Р°РіР°С… 11,25В°.
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
padding3 db 0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #4
;===================================================================================================

; A вЂ” Р·РЅР°РєРѕРІР°СЏ С€РµСЃС‚РёР±РёС‚РЅР°СЏ РєРѕРѕСЂРґРёРЅР°С‚Р°, B вЂ” С„Р°Р·Р° 0вЂ¦31; РІРµСЂРЅСѓС‚СЊ round(A*sin(B)).
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
                    ldi c, 6
                    ldi d, sine_return
                    jmp set_bank
sine_zero:
                    clr a
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

; Р—РЅР°РєРѕРІРѕРµ СѓРјРЅРѕР¶РµРЅРёРµ ru*rv: t1:t0 вЂ” 16-Р±РёС‚РЅС‹Р№ СЂРµР·СѓР»СЊС‚Р°С‚, Р±РµР· Р°РїРїР°СЂР°С‚РЅРѕРіРѕ MUL.
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
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #5
;===================================================================================================

; Р’С‹Р±СЂР°С‚СЊ С‡РµС‚С‹СЂС‘С…Р±Р°Р№С‚РѕРІСѓСЋ РјР°СЃРєСѓ РїСЂРёСЂР°С‰РµРЅРёР№ РґР»СЏ С„Р°Р·С‹ РїРµСЂРІРѕР№ С‡РµС‚РІРµСЂС‚Рё.
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

; РџРѕРґРіРѕС‚РѕРІРёС‚СЊ РїСЏС‚РёР±Р°Р№С‚РѕРІС‹Рµ Р·Р°РїРёСЃРё С‚СЂРµСѓРіРѕР»СЊРЅРёРєРѕРІ: СЃСѓРјРјР° РіР»СѓР±РёРЅ, С†РІРµС‚, С‚СЂРё РёРЅРґРµРєСЃР°.
mesh_faces_begin:
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_RENDER
                    ldi d, io_mesh_faces_begin_0
                    jmp read_byte
io_mesh_faces_begin_0:
                    ldi b, 2
                    and a, b
                    jnz bridge_mesh_faces_begin_3
                    ldi c, 18
                    ldi d, mesh_done
                    jmp set_bank
bridge_mesh_faces_begin_3:
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_faces_begin_4
                    jmp read_byte
io_mesh_faces_begin_4:
                    test a
                    jnz bridge_mesh_faces_begin_6
                    ldi c, 18
                    ldi d, mesh_done
                    jmp set_bank
bridge_mesh_faces_begin_6:
                    st a, vertex_count
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_BANK
                    ldi d, io_mesh_faces_begin_8
                    jmp read_byte
io_mesh_faces_begin_8:
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_faces_begin_9
                    jmp write_byte
io_mesh_faces_begin_9:
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_ADDR
                    ldi d, io_mesh_faces_begin_10
                    jmp read_byte
io_mesh_faces_begin_10:
                    ldi d, 5
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_faces_begin_11
                    jmp write_byte
io_mesh_faces_begin_11:
                    ldi c, 30
                    ldi d, mesh_cache_face0
                    jmp set_bank

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #6
;===================================================================================================

; РџСЂРѕСЃСѓРјРјРёСЂРѕРІР°С‚СЊ РїРµСЂРІС‹Рµ |РєРѕРѕСЂРґРёРЅР°С‚Р°| Р±РёС‚РѕРІ; СЃСѓРјРјР° СЃРѕРІРїР°РґР°РµС‚ СЃ РѕРєСЂСѓРіР»С‘РЅРЅС‹Рј РїСЂРѕРёР·РІРµРґРµРЅРёРµРј.
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
                    jmp sine_return

; Р’РѕСЃСЃС‚Р°РЅРѕРІРёС‚СЊ Р·РЅР°Рє РєРѕРѕСЂРґРёРЅР°С‚С‹ Рё РїРѕР»СѓРІРѕР»РЅС‹; С‚РѕС‡РєРё 0 Рё ПЂ/2 РІС‹С‡РёСЃР»СЏСЋС‚СЃСЏ С‚РѕС‡РЅРѕ.
sine_return:
                    ld b, sx
                    test b
                    jns sine_done
                    neg a
sine_done:
                    ld c, ret3_bank
                    ld d, ret3_addr
                    jmp set_bank

; РћР±Р° РЅРµРЅСѓР»РµРІС‹С… Р·РЅР°РєР° РѕРґРЅРѕРІСЂРµРјРµРЅРЅРѕ РѕР·РЅР°С‡Р°СЋС‚ С‚РѕС‡РєСѓ РІРЅРµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
triangle_sign0:
                    ld a, y0
                    test a
                    js triangle_negative0
                    ld b, x0
                    or a, b
                    jnz bridge_triangle_sign0_5
                    ldi c, 21
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
                    ldi c, 21
                    ldi d, triangle_inside_no
                    jmp set_bank
bridge_triangle_sign0_17:
                    ldi c, 21
                    ldi d, triangle_sign1
                    jmp set_bank
padding6 db 0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #7
;===================================================================================================

; РџРѕРІРµСЂРЅСѓС‚СЊ РїР°СЂСѓ ru/rv РЅР° angle: u=cos*u+sin*v, v=cos*v-sin*u.
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
padding7 db 0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #8
;===================================================================================================

; Р’СЂР°С‰РµРЅРёРµ РІРѕРєСЂСѓРі Y, Р·Р°С‚РµРј X. РљРѕРѕСЂРґРёРЅР°С‚С‹ РјРѕРґРµР»Рё РёРјРµСЋС‚ СЂР°РґРёСѓСЃ РЅРµ Р±РѕР»РµРµ 20.
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

; РџРѕР»СѓС‡РёС‚СЊ С‚СЂРё СЌРєСЂР°РЅРЅС‹Рµ РІРµСЂС€РёРЅС‹ РІС‹Р±СЂР°РЅРЅРѕРіРѕ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
mesh_selected_vertex1:
                    ld a, dy
                    ldi c, 8
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_vertex1_1
                    st d, ret1_addr
                    ldi c, 3
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_vertex1_1:
                    ld a, wx
                    st a, x1
                    ld a, wy
                    st a, y1
                    ld a, sx
                    ldi c, 8
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_vertex1_7
                    st d, ret1_addr
                    ldi c, 3
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_vertex1_7:
                    ld a, wx
                    st a, dx
                    ld a, wy
                    st a, dy
                    ldi c, 18
                    ldi d, mesh_selected_cull
                    jmp set_bank

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #9
;===================================================================================================

; Р’СЂР°С‰РµРЅРёРµ РІРѕРєСЂСѓРі Z; Р·Р°С‚РµРј СЃРјРµС‰РµРЅРёРµ РѕР±СЉРµРєС‚Р° Рё РІС‹Р±РѕСЂ РїСЂРѕРµРєС†РёРё.
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
                    ldi c, 10
                    ldi d, project_translate
                    jmp set_bank

; РџСЂРѕС‡РёС‚Р°С‚СЊ V,E,T Рё РЅР°С‡Р°С‚СЊ РїСЂРµРѕР±СЂР°Р·РѕРІР°РЅРёРµ РІРµСЂС€РёРЅ; С†РІРµС‚Р° РІС‹Р±РёСЂР°СЋС‚СЃСЏ СЂРµР¶РёРјРѕРј РІ РїР°РјСЏС‚Рё.
mesh_begin:
                    ldi c, 9
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_0:
                    st a, vertex_count
                    ldi c, 9
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_2
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_2:
                    st a, edge_count
                    ldi c, 9
                    st c, ret2_bank
                    ldi d, resume_mesh_begin_4
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_begin_4:
                    ldi d, 9
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_begin_5
                    jmp write_byte
io_mesh_begin_5:
                    ldi a, 1
                    ldi d, 9
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
                    ldi c, 30
                    ldi d, mesh_vertex
                    jmp set_bank
padding9 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #10
;===================================================================================================

; РЎРјРµСЃС‚РёС‚СЊ XYZ РїРѕСЃР»Рµ РІСЂР°С‰РµРЅРёСЏ; РіР»СѓР±РёРЅР° РєР°РјРµСЂС‹ РґРѕР»Р¶РЅР° Р»РµР¶Р°С‚СЊ РІ 8вЂ¦63.
project_translate:
                    ldi d, 10
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_project_translate_0
                    jmp read_byte
io_project_translate_0:
                    ld b, wx
                    add a, b
                    st a, wx
                    ldi d, 10
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_project_translate_4
                    jmp read_byte
io_project_translate_4:
                    ld b, wy
                    add a, b
                    st a, wy
                    ldi d, 10
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
                    jmp project_choose

; РџСЂРѕРІРµСЂРёС‚СЊ РґРёР°РїР°Р·РѕРЅ XY в€’32вЂ¦31 Рё РІС‹Р±СЂР°С‚СЊ РїРµСЂСЃРїРµРєС‚РёРІРЅСѓСЋ РёР»Рё РїР°СЂР°Р»Р»РµР»СЊРЅСѓСЋ РїСЂРѕРµРєС†РёСЋ.
project_choose:
                    ld a, wx
                    ldi b, 32
                    add a, b
                    ldi b, 64
                    sub a, b
                    jnc project_invisible
                    ld a, wy
                    ldi b, 32
                    add a, b
                    ldi b, 64
                    sub a, b
                    jnc project_invisible
                    ldi d, 10
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PROJECTION
                    ldi d, io_project_choose_12
                    jmp read_byte
io_project_choose_12:
                    test a
                    jz bridge_project_choose_14
                    ldi c, 11
                    ldi d, project_parallel
                    jmp set_bank
bridge_project_choose_14:
                    ldi c, 12
                    ldi d, project_perspective
                    jmp set_bank

; РџРѕРјРµС‚РёС‚СЊ РІРµСЂС€РёРЅСѓ РІРЅРµ РґРёР°РїР°Р·РѕРЅР° РіР»СѓР±РёРЅС‹; РёРЅС†РёРґРµРЅС‚РЅС‹Рµ РїСЂРёРјРёС‚РёРІС‹ РїСЂРѕРїСѓСЃРєР°СЋС‚СЃСЏ.
project_invisible:
                    clr a
                    st a, wz
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding10 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #11
;===================================================================================================

; РџР°СЂР°Р»Р»РµР»СЊРЅР°СЏ РїСЂРѕРµРєС†РёСЏ: x=8+floor(X/2), y=8+floor(-Y/2).
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

; РџСЂРё СЂР°РІРЅРѕР№ РіР»СѓР±РёРЅРµ СЃРѕС…СЂР°РЅСЏС‚СЊ РёСЃС…РѕРґРЅС‹Р№ РїРѕСЂСЏРґРѕРє; Р±Р»РёР¶РЅРёРµ Р·Р°РїРёСЃРё РЅРµ Р·Р°РјРµРЅСЏСЋС‚ РґР°Р»СЊРЅСЋСЋ.
mesh_scan:
                    ld a, out_bank
                    st a, x0
                    ld a, out_addr
                    st a, y0
                    ldi c, 11
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
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_BANK
                    ldi d, io_mesh_scan_10
                    jmp write_byte
io_mesh_scan_10:
                    ld a, y0
                    ldi d, 11
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_ADDR
                    ldi d, io_mesh_scan_12
                    jmp write_byte
io_mesh_scan_12:
                    jmp mesh_scan_next

; РџСЂРѕРїСѓСЃС‚РёС‚СЊ С‡РµС‚С‹СЂРµ РїРѕР»СЏ Р·Р°РїРёСЃРё; СѓРєР°Р·Р°С‚РµР»СЊ РєРѕСЂСЂРµРєС‚РЅРѕ РїРµСЂРµСЃРµРєР°РµС‚ РіСЂР°РЅРёС†С‹ 128-Р±Р°Р№С‚РѕРІС‹С… Р±Р°РЅРєРѕРІ.
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
                    ldi c, 18
                    ldi d, mesh_done
                    jmp set_bank
bridge_mesh_scan_next_17:
                    ldi c, 32
                    ldi d, mesh_selected
                    jmp set_bank
padding11 db 0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #12
;===================================================================================================

; РџРµСЂСЃРїРµРєС‚РёРІР° x=8+round(16*x/z), y=8+round(-16*y/z); С†РµР»РѕС‡РёСЃР»РµРЅРЅРѕРµ РґРµР»РµРЅРёРµ.
project_perspective:
                    ld a, wx
                    ld b, wz
                    ldi c, 12
                    st c, ret3_bank
                    ldi d, resume_project_perspective_2
                    st d, ret3_addr
                    jmp gfx_divide_projection
resume_project_perspective_2:
                    st a, wx
                    ld a, wy
                    neg a
                    ld b, wz
                    ldi c, 12
                    st c, ret3_bank
                    ldi d, resume_project_perspective_7
                    st d, ret3_addr
                    jmp gfx_divide_projection
resume_project_perspective_7:
                    st a, wy
                    ldi a, 1
                    st a, wz
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РєРѕРѕСЂРґРёРЅР°С‚Р°, B вЂ” РіР»СѓР±РёРЅР° 8вЂ¦63; РІРµСЂРЅСѓС‚СЊ 8+round(16*A/B), СЃРѕС…СЂР°РЅСЏСЏ РіР»СѓР±РёРЅСѓ РєР°РјРµСЂС‹.
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

; РџСЂРѕС‡РёС‚Р°С‚СЊ РёРЅРґРµРєСЃ Рё РґРѕР±Р°РІРёС‚СЊ РіР»СѓР±РёРЅСѓ РєР°РјРµСЂС‹; СЃРѕС…СЂР°РЅРёС‚СЊ РѕР±С‰СѓСЋ РІРёРґРёРјРѕСЃС‚СЊ.
mesh_cache_face1:
                    ldi c, 12
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face1_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face1_0:
                    st a, y0
                    ldi c, 12
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face1_2
                    st d, ret1_addr
                    ldi c, 3
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
                    ldi c, 17
                    ldi d, mesh_cache_face2
                    jmp set_bank
padding12 db 0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #13
;===================================================================================================

; Р”РµР»РёС‚СЊ 16-Р±РёС‚РЅС‹Р№ С‡РёСЃР»РёС‚РµР»СЊ РІС‹С‡РёС‚Р°РЅРёРµРј; С‡Р°СЃС‚РЅРѕРµ РѕРіСЂР°РЅРёС‡РµРЅРѕ 64.
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

; Р”РѕР±Р°РІРёС‚СЊ Р·РЅР°РєРѕРІС‹Рµ wx/wy/wz Рє РїРѕР»РѕР¶РµРЅРёСЋ РѕР±СЉРµРєС‚Р°.
gfx_move:
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_gfx_move_0
                    jmp read_byte
io_gfx_move_0:
                    ld b, wx
                    add a, b
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TX
                    ldi d, io_gfx_move_3
                    jmp write_byte
io_gfx_move_3:
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_gfx_move_4
                    jmp read_byte
io_gfx_move_4:
                    ld b, wy
                    add a, b
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TY
                    ldi d, io_gfx_move_7
                    jmp write_byte
io_gfx_move_7:
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TZ
                    ldi d, io_gfx_move_8
                    jmp read_byte
io_gfx_move_8:
                    ld b, wz
                    add a, b
                    ldi d, 13
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TZ
                    ldi d, io_gfx_move_11
                    jmp write_byte
io_gfx_move_11:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank
padding13 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #14
;===================================================================================================

; РћРєСЂСѓРіР»РёС‚СЊ Рє Р±Р»РёР¶Р°Р№С€РµРјСѓ С†РµР»РѕРјСѓ; РїСЂРё РїРѕР»РѕРІРёРЅРµ РІС‹Р±СЂР°С‚СЊ С‡С‘С‚РЅРѕРµ С‡Р°СЃС‚РЅРѕРµ, Р·Р°С‚РµРј РІРµСЂРЅСѓС‚СЊ Р·РЅР°Рє.
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

; РќР°С‡Р°Р»Рѕ СЂР°Р±РѕС‡РёС… С‚СЂРµСѓРіРѕР»СЊРЅРёРєРѕРІ РїРѕСЃР»Рµ 4V Р±Р°Р№С‚ СЌРєСЂР°РЅРЅС‹С… РІРµСЂС€РёРЅ.
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
                    ldi c, 26
                    ldi d, object_workspace_compare
                    jmp set_bank
bridge_object_workspace_19:
                    ldi c, 24
                    ldi d, object_workspace_triangle
                    jmp set_bank

; Р”РѕР±Р°РІРёС‚СЊ Р·РЅР°РєРѕРІС‹Рµ РїСЂРёСЂР°С‰РµРЅРёСЏ wx/wy/wz Рє СѓРіР»Р°Рј Y/X/Z РїРѕ РјРѕРґСѓР»СЋ 32.
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
padding14 db 0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #15
;===================================================================================================

; gfx_pixel Р·Р°РјРµРЅСЏРµС‚ С†РІРµС‚; gfx_line_pixel СЃРєР»Р°РґС‹РІР°РµС‚ С†РІРµС‚РѕРІС‹Рµ Р±РёС‚С‹. wz вЂ” СЂР°Р±РѕС‡РёР№ С„Р»Р°Рі.
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

; РњР°СЃРєРё РїРёРєСЃРµР»РµР№; СЃС‚Р°СЂС€РёР№ Р±РёС‚ СЃР»РµРІР°.
pixel_masks db 128,64,32,16,8,4,2,1

; РЎРёРЅРёР№ СЃР»РѕР№: Р»РёРЅРёРё СЃРѕС…СЂР°РЅСЏСЋС‚ РєСЂР°СЃРЅС‹Р№ Р±РёС‚, РїРёРєСЃРµР»Рё Рё С‚СЂРµСѓРіРѕР»СЊРЅРёРєРё Р·Р°РјРµРЅСЏСЋС‚ С†РІРµС‚.
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
padding15 db 0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #16
;===================================================================================================

; Р¦РІРµС‚РЅР°СЏ Р»РёРЅРёСЏ Р‘СЂРµР·РµРЅС…СЌРјР°; СЌРєСЂР°РЅ РѕС‚СЃРµРєР°РµС‚СЃСЏ РїСЂРѕРІРµСЂРєРѕР№ РєРѕРѕСЂРґРёРЅР°С‚ РєР°Р¶РґРѕРіРѕ РїРёРєСЃРµР»СЏ.
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
                    ldi c, 17
                    ldi d, line_pixel
                    jmp set_bank

; РџРµСЂРІС‹Р№ РёРЅРґРµРєСЃ РїСЂРµРѕР±СЂР°Р·РѕРІР°С‚СЊ РІ СЌРєСЂР°РЅРЅСѓСЋ РІРµСЂС€РёРЅСѓ РїРѕСЃР»Рµ С‡С‚РµРЅРёСЏ РІСЃРµР№ Р·Р°РїРёСЃРё.
mesh_selected_indices:
                    ldi c, 16
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_indices_0
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_indices_0:
                    st a, dy
                    ldi c, 16
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_indices_2
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_indices_2:
                    st a, sx
                    ld a, dx
                    ldi c, 16
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_indices_5
                    st d, ret1_addr
                    ldi c, 3
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_selected_indices_5:
                    ld a, wx
                    st a, x0
                    ld a, wy
                    st a, y0
                    ldi c, 8
                    ldi d, mesh_selected_vertex1
                    jmp set_bank
padding16 db 0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #17
;===================================================================================================

; X вЂ” РіР»Р°РІРЅР°СЏ РѕСЃСЊ; РѕС€РёР±РєР° СЃРѕС…СЂР°РЅСЏРµС‚ РїСЂР°РІРёР»Рѕ РІС‹Р±РѕСЂР° РїРёРєСЃРµР»СЏ РёСЃС…РѕРґРЅРѕРіРѕ СЂР°СЃС‚РµСЂРёР·Р°С‚РѕСЂР°.
line_pixel:
                    ld a, x0
                    st a, wx
                    ld a, y0
                    st a, wy
                    ldi c, 17
                    st c, ret2_bank
                    ldi d, resume_line_pixel_4
                    st d, ret2_addr
                    ldi c, 15
                    ldi d, gfx_line_pixel
                    jmp set_bank
resume_line_pixel_4:
                    ld a, x1
                    dec a
                    st a, x1
                    jnz bridge_line_pixel_8
                    ldi c, 18
                    ldi d, line_done
                    jmp set_bank
bridge_line_pixel_8:
                    ld a, angle
                    test a
                    jz bridge_line_pixel_11
                    ldi c, 18
                    ldi d, line_step_y
                    jmp set_bank
bridge_line_pixel_11:
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

; РџСЂРѕС‡РёС‚Р°С‚СЊ РёРЅРґРµРєСЃ Рё РґРѕР±Р°РІРёС‚СЊ РіР»СѓР±РёРЅСѓ РєР°РјРµСЂС‹; СЃРѕС…СЂР°РЅРёС‚СЊ РѕР±С‰СѓСЋ РІРёРґРёРјРѕСЃС‚СЊ.
mesh_cache_face2:
                    ldi c, 17
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face2_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face2_0:
                    st a, x1
                    ldi c, 17
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face2_2
                    st d, ret1_addr
                    ldi c, 3
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
                    ldi c, 31
                    ldi d, mesh_cache_color
                    jmp set_bank
padding17 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #18
;===================================================================================================

; Y вЂ” РіР»Р°РІРЅР°СЏ РѕСЃСЊ; РєРѕРѕСЂРґРёРЅР°С‚С‹ -54...70 РґРѕРїСѓСЃС‚РёРјС‹ РїСЂРё СЂР°Р·РЅРѕСЃС‚Рё РЅРµ Р±РѕР»РµРµ 127.
line_step_y:
                    ld a, y0
                    ld b, sy
                    add a, b
                    st a, y0
                    ld a, err
                    ld b, dx
                    sub a, b
                    st a, err
                    js bridge_line_step_y_8
                    ldi c, 17
                    ldi d, line_pixel
                    jmp set_bank
bridge_line_step_y_8:
                    ld b, dy
                    add a, b
                    st a, err
                    ld a, x0
                    ld b, sx
                    add a, b
                    st a, x0
                    ldi c, 17
                    ldi d, line_pixel
                    jmp set_bank
line_done:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; РџСЂРё РІРєР»СЋС‡С‘РЅРЅРѕРј РѕС‚СЃРµС‡РµРЅРёРё РїСЂРѕРїСѓСЃС‚РёС‚СЊ РѕР±СЂР°С‚РЅС‹Рµ Рё РІС‹СЂРѕР¶РґРµРЅРЅС‹Рµ РіСЂР°РЅРё; Р·Р°С‚РµРј СЂРёСЃРѕРІР°С‚СЊ РѕС‚ РґР°Р»СЊРЅРёС… Рє Р±Р»РёР¶РЅРёРј.
mesh_selected_cull:
                    ldi d, 18
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
                    ldi c, 18
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_cull_7
                    st d, ret2_addr
                    ldi c, 19
                    ldi d, triangle_area
                    jmp set_bank
resume_mesh_selected_cull_7:
                    ld a, sy
                    test a
                    js mesh_selected_next
                    ld b, sx
                    or a, b
                    jz mesh_selected_next
mesh_selected_draw:
                    ldi c, 18
                    st c, ret1_bank
                    ldi d, resume_mesh_selected_cull_15
                    st d, ret1_addr
                    ldi c, 23
                    ldi d, gfx_triangle
                    jmp set_bank
resume_mesh_selected_cull_15:
                    jmp mesh_selected_next

; Р—Р°РІРµСЂС€РёС‚СЊ РјРѕРґРµР»СЊ РїРѕСЃР»Рµ РІСЃРµС… РІРёРґРёРјС‹С… С‚СЂРµСѓРіРѕР»СЊРЅРёРєРѕРІ.
mesh_selected_next:
                    ld a, vertex_count
                    dec a
                    st a, vertex_count
                    jz bridge_mesh_selected_next_3
                    ldi c, 20
                    ldi d, mesh_select
                    jmp set_bank
bridge_mesh_selected_next_3:
mesh_done:
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #19
;===================================================================================================

; РћР±С‰РёР№ 16-Р±РёС‚РЅС‹Р№ РѕРїСЂРµРґРµР»РёС‚РµР»СЊ: A/B вЂ” Р°РґСЂРµСЃР° X РєРѕРЅС†РѕРІ СЂРµР±СЂР° РІ COMMON; Y Р»РµР¶РёС‚ СЃР»РµРґСѓСЋС‰РёРј Р±Р°Р№С‚РѕРј.
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
                    ldi c, 19
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
                    ldi c, 19
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

; РћРїСЂРµРґРµР»РёС‚РµР»СЊ РїРµСЂРІРѕРіРѕ СЂРµР±СЂР° Рё С‚СЂРµС‚СЊРµР№ РІРµСЂС€РёРЅС‹; РЅСѓР»РµРІР°СЏ РїР»РѕС‰Р°РґСЊ РЅРµ Р·Р°РїРѕР»РЅСЏРµС‚СЃСЏ.
triangle_area:
                    clr a
                    st a, out_addr
                    ldi a, x0
                    ldi b, x1
                    jmp triangle_determinant

; Р’С‹Р±СЂР°С‚СЊ СЂРµР±СЂРѕ Рё РјРµСЃС‚Рѕ РЅР°С‡Р°Р»СЊРЅРѕРіРѕ РѕРїСЂРµРґРµР»РёС‚РµР»СЏ; РѕР±С‰Р°СЏ С‡Р°СЃС‚СЊ РІС‹С‡РёСЃР»СЏРµС‚ С‚Р°РєР¶Рµ РїСЂРёСЂР°С‰РµРЅРёСЏ.
triangle_init1:
                    ldi a, TRI_STATE2
                    st a, out_addr
                    ldi a, x1
                    ldi b, dx
                    jmp triangle_determinant
padding19 db 0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #20
;===================================================================================================

; РџСЂРѕРІРµСЂРёС‚СЊ С‚РµРєСѓС‰РёРµ 16-Р±РёС‚РЅС‹Рµ Р·РЅР°С‡РµРЅРёСЏ СЂС‘Р±РµСЂ; СѓРјРЅРѕР¶РµРЅРёСЏ РІ С†РёРєР»Рµ РЅРµС‚.
triangle_inside:
                    clr a
                    st a, signs
                    ldi c, 6
                    ldi d, triangle_sign0
                    jmp set_bank

; Р—Р°РїРѕР»РЅСЏС‚СЊ С‚СЂРµСѓРіРѕР»СЊРЅРёРє; РІРѕ РІРЅСѓС‚СЂРµРЅРЅРµРј С†РёРєР»Рµ С‚РѕР»СЊРєРѕ СЃР»РѕР¶РµРЅРёСЏ, РїСЂРѕРІРµСЂРєРё Рё Р·Р°РїРёСЃСЊ С†РІРµС‚Р°.
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
                    ldi c, 15
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
                    ldi c, 28
                    ldi d, triangle_row
                    jmp set_bank
bridge_triangle_scan_11:
                    ldi c, 20
                    st c, ret2_bank
                    ldi d, resume_triangle_scan_12
                    st d, ret2_addr
                    ldi c, 26
                    ldi d, triangle_advance_x
                    jmp set_bank
resume_triangle_scan_12:
                    jmp triangle_pixel

; РќР°Р№С‚Рё РјР°РєСЃРёРјР°Р»СЊРЅСѓСЋ СЃСѓРјРјСѓ РіР»СѓР±РёРЅ СЃСЂРµРґРё РµС‰С‘ РЅРµ РЅР°СЂРёСЃРѕРІР°РЅРЅС‹С… С‚СЂРµСѓРіРѕР»СЊРЅРёРєРѕРІ.
mesh_select:
                    clr a
                    st a, dx
                    ldi d, 20
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_select_2
                    jmp read_byte
io_mesh_select_2:
                    st a, edge_count
                    ldi d, 20
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_BANK
                    ldi d, io_mesh_select_4
                    jmp read_byte
io_mesh_select_4:
                    st a, out_bank
                    ldi d, 20
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_BASE_ADDR
                    ldi d, io_mesh_select_6
                    jmp read_byte
io_mesh_select_6:
                    st a, out_addr
                    ldi c, 11
                    ldi d, mesh_scan
                    jmp set_bank
padding20 db 0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #21
;===================================================================================================

; РћР±Р° РЅРµРЅСѓР»РµРІС‹С… Р·РЅР°РєР° РѕРґРЅРѕРІСЂРµРјРµРЅРЅРѕ РѕР·РЅР°С‡Р°СЋС‚ С‚РѕС‡РєСѓ РІРЅРµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
triangle_sign1:
                    ld a, y1
                    test a
                    js triangle_negative1
                    ld b, x1
                    or a, b
                    jnz bridge_triangle_sign1_5
                    ldi c, 22
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
                    jz triangle_inside_no
                    ldi c, 22
                    ldi d, triangle_sign2
                    jmp set_bank

; РўРѕС‡РєР° РІРЅРµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
triangle_inside_no:
                    clr a
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; РџСЂРѕРґРѕР»Р¶РёС‚СЊ Р±СѓС„РµСЂ С‡РµСЂРµР· РіСЂР°РЅРёС†Сѓ Р±Р°РЅРєР° Рё РѕР±СЂР°Р±РѕС‚Р°С‚СЊ СЃР»РµРґСѓСЋС‰РёР№ С‚СЂРµСѓРіРѕР»СЊРЅРёРє.
mesh_cache_write1:
                    ld a, y0
                    ldi c, 21
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write1_1
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write1_1:
                    ld a, x1
                    ldi c, 21
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write1_3
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write1_3:
                    ld a, out_bank
                    ldi d, 21
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_cache_write1_5
                    jmp write_byte
io_mesh_cache_write1_5:
                    ld a, out_addr
                    ldi d, 21
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_cache_write1_7
                    jmp write_byte
io_mesh_cache_write1_7:
                    ld a, vertex_count
                    dec a
                    st a, vertex_count
                    jz bridge_mesh_cache_write1_11
                    ldi c, 30
                    ldi d, mesh_cache_face0
                    jmp set_bank
bridge_mesh_cache_write1_11:
                    ldi c, 28
                    ldi d, mesh_sort_start
                    jmp set_bank
padding21 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #22
;===================================================================================================

; РћР±Р° РЅРµРЅСѓР»РµРІС‹С… Р·РЅР°РєР° РѕРґРЅРѕРІСЂРµРјРµРЅРЅРѕ РѕР·РЅР°С‡Р°СЋС‚ С‚РѕС‡РєСѓ РІРЅРµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
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
                    jnz bridge_triangle_sign2_17
                    ldi c, 21
                    ldi d, triangle_inside_no
                    jmp set_bank
bridge_triangle_sign2_17:
                    jmp triangle_inside_yes

; РўРѕС‡РєР° РІРЅСѓС‚СЂРё РёР»Рё РЅР° РіСЂР°РЅРёС†Рµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєР°.
triangle_inside_yes:
                    ldi a, 1
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank

; РџСЂРѕС‡РёС‚Р°С‚СЊ РґРІР° РёРЅРґРµРєСЃР° СЂРµР±СЂР° Рё РїРѕР»СѓС‡РёС‚СЊ СЌРєСЂР°РЅРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ РµРіРѕ РєРѕРЅС†РѕРІ.
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
                    ldi c, 3
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
                    ldi c, 3
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_edge_9:
                    ld a, wx
                    st a, x1
                    ld a, wy
                    st a, y1
                    ldi c, 25
                    ldi d, mesh_edge_color
                    jmp set_bank
padding22 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #23
;===================================================================================================

; Р’С‹Р±СЂР°С‚СЊ СЂРµР±СЂРѕ Рё РјРµСЃС‚Рѕ РЅР°С‡Р°Р»СЊРЅРѕРіРѕ РѕРїСЂРµРґРµР»РёС‚РµР»СЏ; РѕР±С‰Р°СЏ С‡Р°СЃС‚СЊ РІС‹С‡РёСЃР»СЏРµС‚ С‚Р°РєР¶Рµ РїСЂРёСЂР°С‰РµРЅРёСЏ.
triangle_init0:
                    ldi a, TRI_STATE0
                    st a, out_addr
                    ldi a, x0
                    ldi b, x1
                    ldi c, 19
                    ldi d, triangle_determinant
                    jmp set_bank

; Р’С‹Р±СЂР°С‚СЊ СЂРµР±СЂРѕ Рё РјРµСЃС‚Рѕ РЅР°С‡Р°Р»СЊРЅРѕРіРѕ РѕРїСЂРµРґРµР»РёС‚РµР»СЏ; РѕР±С‰Р°СЏ С‡Р°СЃС‚СЊ РІС‹С‡РёСЃР»СЏРµС‚ С‚Р°РєР¶Рµ РїСЂРёСЂР°С‰РµРЅРёСЏ.
triangle_init2:
                    ldi a, TRI_STATE4
                    st a, out_addr
                    ldi a, dx
                    ldi b, x0
                    ldi c, 19
                    ldi d, triangle_determinant
                    jmp set_bank

; РџРѕРґРіРѕС‚РѕРІРёС‚СЊ СЂС‘Р±СЂР° С‚СЂРµСѓРіРѕР»СЊРЅРёРєР° x0/y0, x1/y1, dx/dy; РЅСѓР»РµРІР°СЏ РїР»РѕС‰Р°РґСЊ РїСЂРѕРїСѓСЃРєР°РµС‚СЃСЏ.
gfx_triangle:
                    ld a, dx
                    st a, wx
                    ld a, dy
                    st a, wy
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_4
                    st d, ret2_addr
                    ldi c, 19
                    ldi d, triangle_area
                    jmp set_bank
resume_gfx_triangle_4:
                    ld a, sx
                    ld b, sy
                    or a, b
                    jnz bridge_gfx_triangle_8
                    ldi c, 28
                    ldi d, triangle_done
                    jmp set_bank
bridge_gfx_triangle_8:
                    clr a
                    st a, wx
                    st a, wy
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_12
                    st d, ret2_addr
                    jmp triangle_init0
resume_gfx_triangle_12:
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_13
                    st d, ret2_addr
                    ldi c, 19
                    ldi d, triangle_init1
                    jmp set_bank
resume_gfx_triangle_13:
                    ldi c, 23
                    st c, ret2_bank
                    ldi d, resume_gfx_triangle_14
                    st d, ret2_addr
                    jmp triangle_init2
resume_gfx_triangle_14:
                    ldi c, 23
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
padding23 db 0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #24
;===================================================================================================

; РЎРѕС…СЂР°РЅРёС‚СЊ РѕРїСЂРµРґРµР»РёС‚РµР»СЊ Рё С€Р°РіРё РїРѕ X/Y; Р°РґСЂРµСЃР° COMMON РїРѕР·РІРѕР»СЏСЋС‚ РёСЃРїРѕР»СЊР·РѕРІР°С‚СЊ РѕРґРёРЅ РІС‹С‡РёСЃР»РёС‚РµР»СЊ.
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

; Р”РѕР±Р°РІРёС‚СЊ РїСЏС‚СЊ Р±Р°Р№С‚РѕРІ РєР°Р¶РґРѕР№ Р·Р°РїРёСЃРё С‚СЂРµСѓРіРѕР»СЊРЅРёРєР° СЃ РїРµСЂРµРЅРѕСЃРѕРј С‡РµСЂРµР· РіСЂР°РЅРёС†С‹ Р±Р°РЅРєРѕРІ.
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
                    ldi c, 26
                    ldi d, object_workspace_compare
                    jmp set_bank
padding24 db 0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #25
;===================================================================================================

; Р—Р°РіСЂСѓР·РёС‚СЊ РґРІРµРЅР°РґС†Р°С‚СЊ Р·РЅР°С‡РµРЅРёР№ РѕРґРЅРёРј С†РёРєР»РѕРј РїРѕ С‚Р°Р±Р»РёС†Рµ Р°РґСЂРµСЃРѕРІ COMMON.
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

; РђРґСЂРµСЃР° РїРµСЂРµРјРµРЅРЅС‹С… РґР»СЏ Р·РЅР°С‡РµРЅРёР№ Рё РїСЂРёСЂР°С‰РµРЅРёР№ С‚СЂС‘С… СЂС‘Р±РµСЂ.
triangle_registers db x0,y0,x1,y1,dx,dy,sx,sy,err,ret3_bank,ret3_addr,angle

; Р’С‹Р±СЂР°С‚СЊ С†РІРµС‚ Рё СЂРёСЃРѕРІР°С‚СЊ СЂРµР±СЂРѕ РїСЂРё РІРєР»СЋС‡С‘РЅРЅРѕРј РєР°СЂРєР°СЃРµ Рё РІРёРґРёРјС‹С… РєРѕРЅС†Р°С….
mesh_edge_color:
                    ldi c, 25
                    st c, ret2_bank
                    ldi d, resume_mesh_edge_color_0
                    st d, ret2_addr
                    ldi c, 31
                    ldi d, gfx_resolve_color
                    jmp set_bank
resume_mesh_edge_color_0:
                    ldi d, 25
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_RENDER
                    ldi d, io_mesh_edge_color_1
                    jmp read_byte
io_mesh_edge_color_1:
                    ldi b, 1
                    and a, b
                    jz mesh_edge_next
                    ld a, signs
                    ld b, wz
                    and a, b
                    jz mesh_edge_next
                    ldi c, 25
                    st c, ret1_bank
                    ldi d, resume_mesh_edge_color_9
                    st d, ret1_addr
                    ldi c, 16
                    ldi d, gfx_line
                    jmp set_bank
resume_mesh_edge_color_9:
mesh_edge_next:
                    ld a, edge_count
                    dec a
                    st a, edge_count
                    jz bridge_mesh_edge_color_14
                    ldi c, 22
                    ldi d, mesh_edge
                    jmp set_bank
bridge_mesh_edge_color_14:
                    ldi c, 5
                    ldi d, mesh_faces_begin
                    jmp set_bank

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #26
;===================================================================================================

; РџСЂРёР±Р°РІРёС‚СЊ С‚СЂРё Р·РЅР°РєРѕРІС‹С… РїСЂРёСЂР°С‰РµРЅРёСЏ Рє 16-Р±РёС‚РЅС‹Рј РѕРїСЂРµРґРµР»РёС‚РµР»СЏРј.
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

; Р Р°Р·СЂРµС€РёС‚СЊ СЂРёСЃРѕРІР°РЅРёРµ РїСЂРё РґРѕСЃС‚Р°С‚РѕС‡РЅРѕРј Р±СѓС„РµСЂРµ; СЃРѕС…СЂР°РЅРёС‚СЊ РіРµРѕРјРµС‚СЂРёСЋ РјРѕРґРµР»Рё.
object_workspace_compare:
                    ldi d, 26
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
                    ldi d, 26
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
                    ldi d, 26
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_object_workspace_compare_15
                    jmp write_byte
io_object_workspace_compare_15:
                    ld c, ret0_bank
                    ld d, ret0_addr
                    jmp set_bank
padding26 db 0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #27
;===================================================================================================

; РџСЂРёР±Р°РІРёС‚СЊ С‚СЂРё Р·РЅР°РєРѕРІС‹С… РїСЂРёСЂР°С‰РµРЅРёСЏ Рє 16-Р±РёС‚РЅС‹Рј РѕРїСЂРµРґРµР»РёС‚РµР»СЏРј.
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

; РњР°СЃС€С‚Р°Р±РёСЂРѕРІР°С‚СЊ С‚СЂРё СЃРѕСЃРµРґРЅРёС… РєРѕРѕСЂРґРёРЅР°С‚С‹ РѕРґРЅРёРј С†РёРєР»РѕРј: Р·РЅР°РєРѕРІРѕРµ РїСЂРѕРёР·РІРµРґРµРЅРёРµ Рё РґРµР»РµРЅРёРµ РЅР° 32.
gfx_scale_vertex:
                    ldi a, wx
                    st a, dx
scale_coordinate:
                    ld b, dx
                    ld a, b
                    st a, ru
                    ldi d, 27
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_SCALE
                    ldi d, io_gfx_scale_vertex_6
                    jmp read_byte
io_gfx_scale_vertex_6:
                    st a, rv
                    ldi c, 27
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

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #28
;===================================================================================================

; Р’РµСЂРЅСѓС‚СЊ РѕРїСЂРµРґРµР»РёС‚РµР»Рё Рє РЅР°С‡Р°Р»Сѓ СЃС‚СЂРѕРєРё Рё СЃРґРІРёРЅСѓС‚СЊ РёС… РЅР° СЃР»РµРґСѓСЋС‰СѓСЋ СЃС‚СЂРѕРєСѓ.
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
                    ldi c, 28
                    st c, ret2_bank
                    ldi d, resume_triangle_row_20
                    st d, ret2_addr
                    ldi c, 26
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
                    ldi c, 28
                    st c, ret2_bank
                    ldi d, resume_triangle_row_34
                    st d, ret2_addr
                    ldi c, 27
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

; РљР°Р¶РґС‹Р№ РєР°РґСЂ СЃРѕСЂС‚РёСЂСѓРµС‚СЃСЏ Р·Р°РЅРѕРІРѕ РїРѕ С‚РµРєСѓС‰РёРј РєРѕРѕСЂРґРёРЅР°С‚Р°Рј РєР°РјРµСЂС‹.
mesh_sort_start:
                    ldi d, 28
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_TRI_TOTAL
                    ldi d, io_mesh_sort_start_0
                    jmp read_byte
io_mesh_sort_start_0:
                    st a, vertex_count
                    ldi c, 20
                    ldi d, mesh_select
                    jmp set_bank
padding28 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #29
;===================================================================================================

; РќР°СЂРёСЃРѕРІР°С‚СЊ РµРґРёРЅСЃС‚РІРµРЅРЅС‹Р№ Р°РєС‚РёРІРЅС‹Р№ РѕР±СЉРµРєС‚ СЃ СЃРѕС…СЂР°РЅС‘РЅРЅС‹РјРё РїР°СЂР°РјРµС‚СЂР°РјРё.
gfx_draw_mesh:
gfx_draw_object:
                    ldi d, 29
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_gfx_draw_mesh_1
                    jmp read_byte
io_gfx_draw_mesh_1:
                    test a
                    jnz bridge_gfx_draw_mesh_3
                    ldi c, 18
                    ldi d, mesh_done
                    jmp set_bank
bridge_gfx_draw_mesh_3:
                    ldi d, 29
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_BANK
                    ldi d, io_gfx_draw_mesh_4
                    jmp read_byte
io_gfx_draw_mesh_4:
                    st a, ptr_bank
                    ldi d, 29
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_MODEL_ADDR
                    ldi d, io_gfx_draw_mesh_6
                    jmp read_byte
io_gfx_draw_mesh_6:
                    st a, ptr_addr
                    ldi c, 9
                    ldi d, mesh_begin
                    jmp set_bank

; РЎРѕС…СЂР°РЅРёС‚СЊ РєР»СЋС‡ РіР»СѓР±РёРЅС‹, С†РІРµС‚ Рё РїРµСЂРІС‹Р№ РёРЅРґРµРєСЃ РІ СЂР°Р±РѕС‡РµРј Р±СѓС„РµСЂРµ.
mesh_cache_write0:
                    ld a, dx
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_1
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_1:
                    ld a, color
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_3
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_3:
                    ld a, x0
                    ldi c, 29
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_write0_5
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_cache_write0_5:
                    ldi c, 21
                    ldi d, mesh_cache_write1
                    jmp set_bank
padding29 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #30
;===================================================================================================

; РњР°СЃС€С‚Р°Р±, РІСЂР°С‰РµРЅРёРµ Y/X/Z, СЃРјРµС‰РµРЅРёРµ Рё РІС‹Р±СЂР°РЅРЅР°СЏ РїСЂРѕРµРєС†РёСЏ.
mesh_vertex:
                    ldi c, 30
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_0:
                    st a, wx
                    ldi c, 30
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_2
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_2:
                    st a, wy
                    ldi c, 30
                    st c, ret2_bank
                    ldi d, resume_mesh_vertex_4
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_vertex_4:
                    st a, wz
                    ldi c, 30
                    st c, ret1_bank
                    ldi d, resume_mesh_vertex_6
                    st d, ret1_addr
                    ldi c, 27
                    ldi d, gfx_scale_vertex
                    jmp set_bank
resume_mesh_vertex_6:
                    ldi c, 30
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

; РџСЂРѕС‡РёС‚Р°С‚СЊ РёРЅРґРµРєСЃ Рё РґРѕР±Р°РІРёС‚СЊ РіР»СѓР±РёРЅСѓ РєР°РјРµСЂС‹; СЃРѕС…СЂР°РЅРёС‚СЊ РѕР±С‰СѓСЋ РІРёРґРёРјРѕСЃС‚СЊ.
mesh_cache_face0:
                    ldi c, 30
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_face0_0
                    st d, ret2_addr
                    ldi c, 1
                    ldi d, gfx_read_next
                    jmp set_bank
resume_mesh_cache_face0_0:
                    st a, x0
                    ldi c, 30
                    st c, ret1_bank
                    ldi d, resume_mesh_cache_face0_2
                    st d, ret1_addr
                    ldi c, 3
                    ldi d, gfx_get_vertex
                    jmp set_bank
resume_mesh_cache_face0_2:
                    ld a, wz
                    st a, signs
                    ld a, depth
                    st a, dx
                    ldi c, 12
                    ldi d, mesh_cache_face1
                    jmp set_bank
padding30 db 0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #31
;===================================================================================================

; РќСѓР»РµРІР°СЏ РіР»СѓР±РёРЅР° Р·Р°РїРёСЃРё РѕР·РЅР°С‡Р°РµС‚ РЅРµРІРёРґРёРјС‹Р№ РёР»Рё СѓР¶Рµ РЅР°СЂРёСЃРѕРІР°РЅРЅС‹Р№ С‚СЂРµСѓРіРѕР»СЊРЅРёРє.
mesh_cache_color:
                    ldi c, 31
                    st c, ret2_bank
                    ldi d, resume_mesh_cache_color_0
                    st d, ret2_addr
                    jmp gfx_resolve_color
resume_mesh_cache_color_0:
                    ld a, signs
                    test a
                    jnz mesh_cache_visible
                    clr a
                    st a, dx
mesh_cache_visible:
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_BANK
                    ldi d, io_mesh_cache_color_7
                    jmp read_byte
io_mesh_cache_color_7:
                    st a, out_bank
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_CACHE_ADDR
                    ldi d, io_mesh_cache_color_9
                    jmp read_byte
io_mesh_cache_color_9:
                    st a, out_addr
                    ldi c, 29
                    ldi d, mesh_cache_write0
                    jmp set_bank

; Р¦РІРµС‚ РїСЂРёРјРёС‚РёРІР°: РёР· РјРѕРґРµР»Рё, С‡РµСЂРµРґРѕРІР°РЅРёРµ СЃРёРЅРёР№/РєСЂР°СЃРЅС‹Р№ РёР»Рё РµРґРёРЅС‹Р№ Р·Р°РґР°РЅРЅС‹Р№ С†РІРµС‚.
gfx_resolve_color:
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_MODE
                    ldi d, io_gfx_resolve_color_0
                    jmp read_byte
io_gfx_resolve_color_0:
                    ldi b, 2
                    xor a, b
                    jz color_solid
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_PHASE
                    ldi d, io_gfx_resolve_color_4
                    jmp read_byte
io_gfx_resolve_color_4:
                    ldi b, 3
                    xor a, b
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR_PHASE
                    ldi d, io_gfx_resolve_color_7
                    jmp write_byte
io_gfx_resolve_color_7:
                    st a, color
                    jmp color_ready
color_solid:
                    ldi d, 31
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_COLOR
                    ldi d, io_gfx_resolve_color_11
                    jmp read_byte
io_gfx_resolve_color_11:
                    st a, color
color_ready:
                    ld a, color
                    ld c, ret2_bank
                    ld d, ret2_addr
                    jmp set_bank
padding31 db 0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #32
;===================================================================================================

; РџРѕРјРµС‚РёС‚СЊ РІС‹Р±СЂР°РЅРЅСѓСЋ Р·Р°РїРёСЃСЊ РєР°Рє РЅР°СЂРёСЃРѕРІР°РЅРЅСѓСЋ Рё РїСЂРѕС‡РёС‚Р°С‚СЊ РµС‘ С†РІРµС‚ Рё РёРЅРґРµРєСЃС‹.
mesh_selected:
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_BANK
                    ldi d, io_mesh_selected_0
                    jmp read_byte
io_mesh_selected_0:
                    st a, out_bank
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_BEST_ADDR
                    ldi d, io_mesh_selected_2
                    jmp read_byte
io_mesh_selected_2:
                    st a, out_addr
                    clr a
                    ldi c, 32
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_5
                    st d, ret2_addr
                    ldi c, 2
                    ldi d, gfx_write_next
                    jmp set_bank
resume_mesh_selected_5:
                    ldi c, 32
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_6
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_6:
                    st a, color
                    ldi c, 32
                    st c, ret2_bank
                    ldi d, resume_mesh_selected_8
                    st d, ret2_addr
                    ldi c, 3
                    ldi d, gfx_read_output
                    jmp set_bank
resume_mesh_selected_8:
                    st a, dx
                    ldi c, 16
                    ldi d, mesh_selected_indices
                    jmp set_bank

; out_bank/out_addr вЂ” РєРѕРЅРµС† СЂР°Р±РѕС‡РµРіРѕ Р±СѓС„РµСЂР°, РёСЃРєР»СЋС‡Р°СЋС‰РёР№ РїРѕСЃР»РµРґРЅРёР№ Р°РґСЂРµСЃ; Р·Р°С‚РµРј РїСЂРёРІСЏР·Р°С‚СЊ РјРѕРґРµР»СЊ.
gfx_set_workspace:
                    ld a, out_bank
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_BANK
                    ldi d, io_gfx_set_workspace_1
                    jmp write_byte
io_gfx_set_workspace_1:
                    ld a, out_addr
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_WORK_END_ADDR
                    ldi d, io_gfx_set_workspace_3
                    jmp write_byte
io_gfx_set_workspace_3:
                    clr a
                    ldi d, 32
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_ACTIVE
                    ldi d, io_gfx_set_workspace_5
                    jmp write_byte
io_gfx_set_workspace_5:
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #33
;===================================================================================================

; РџР°СЂР°РјРµС‚СЂС‹ РѕРґРЅРѕРіРѕ РѕР±СЉРµРєС‚Р° Рё СѓРєР°Р·Р°С‚РµР»Рё СЂР°Р±РѕС‡РµРіРѕ Р±СѓС„РµСЂР°.
graphics_state db 0,32,0,0,128,0,128,1,0,3,1,1,0,0,0,0,0,128,1,35,128,35,128

; Р§РµС‚РІРµСЂС‚СЊ СЃРёРЅСѓСЃР°: СЃРµРјСЊ 32-Р±РёС‚РЅС‹С… РјР°СЃРѕРє РїСЂРёСЂР°С‰РµРЅРёР№.
rotation_lut db 132,16,130,16,74,74,73,73,85,171,86,173,221,118,187,221,251,190,239,251,191,255,247,255,255,255,255,251

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_SCALE.
gfx_set_scale:
                    st a, STATE_SCALE
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_PROJECTION.
gfx_set_projection:
                    st a, STATE_PROJECTION
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_RENDER.
gfx_set_render_mode:
                    ldi b, 3
                    and a, b
                    st a, STATE_RENDER
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_COLOR_MODE.
gfx_set_color_mode:
                    st a, STATE_COLOR_MODE
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_COLOR.
gfx_set_color:
                    ldi b, 3
                    and a, b
                    st a, STATE_COLOR
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; A вЂ” РЅРѕРІРѕРµ Р·РЅР°С‡РµРЅРёРµ STATE_CULL.
gfx_set_cull:
                    st a, STATE_CULL
                    ld c, ret1_bank
                    ld d, ret1_addr
                    jmp set_bank

; wx/wy/wz вЂ” Р°Р±СЃРѕР»СЋС‚РЅРѕРµ РїРѕР»РѕР¶РµРЅРёРµ РѕР±СЉРµРєС‚Р°.
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
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #34
;===================================================================================================

; РћРїСЂРµРґРµР»РёС‚РµР»Рё С‚СЂС‘С… СЂС‘Р±РµСЂ Рё РёС… РїСЂРёСЂР°С‰РµРЅРёСЏ.
triangle_state db 0,0,0,0,0,0,0,0,0,0,0,0

; РћС‚РєР»СЋС‡РёС‚СЊ РѕР±РЅРѕРІР»РµРЅРёРµ РґРёСЃРїР»РµСЏ Рё РѕС‡РёСЃС‚РёС‚СЊ РѕР±Р° СЃР»РѕСЏ LCD RAM.
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

; Р’РєР»СЋС‡РёС‚СЊ С†РІРµС‚РЅРѕР№ РґРёСЃРїР»РµР№ Рё РїРѕРІС‚РѕСЂРЅРѕ Р·Р°РїРёСЃР°С‚СЊ 64 РіРѕС‚РѕРІС‹С… Р±Р°Р№С‚Р° LCD RAM.
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
; РљРѕРЅРµС† РѕР±С‰РµРіРѕ РјРѕРґСѓР»СЏ 3DGraphics.

; Р‘Р°РЅРє РїР°РјСЏС‚Рё #35: Р­РєСЂР°РЅРЅС‹Рµ РІРµСЂС€РёРЅС‹ x,y,visible,depth.
projected_vertices db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Р‘Р°РЅРє РїР°РјСЏС‚Рё #35: Р Р°Р±РѕС‡РёРµ С‚СЂРµСѓРіРѕР»СЊРЅРёРєРё: РіР»СѓР±РёРЅР°,С†РІРµС‚,a,b,c.
triangle_cache db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; Р‘Р°РЅРє РїР°РјСЏС‚Рё #35: РћРґРЅР° РјРѕРґРµР»СЊ: V,E,T; XYZ; a,b; a,b,c. Цвета назначает движок.
model_data db 8,12,12,252,252,252,4,252,252,4,4,252,252,4,252,252,252,4,4,252,4,4,4,4,252,4,4,0,1,1,2,2,3,3,0,0

; Р‘Р°РЅРє РїР°РјСЏС‚Рё #36: РћРґРЅР° РјРѕРґРµР»СЊ: V,E,T; XYZ; a,b; a,b,c. Цвета назначает движок.
model_data_36 db 4,4,5,5,1,3,7,7,4,7,6,6,5,2,6,0,2,1,0,3,2,0,5,4,0,1,5,0,7,3,0,4,7,4,6,7,4,5,6,3,6,2,3,7,6,1,6,5,1,2,6
data_padding db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #37
;===================================================================================================

; РџСЂРёРІСЏР·Р°С‚СЊ РѕРґРЅСѓ РјРѕРґРµР»СЊ Рё РІС‹РґРµР»РёС‚СЊ РµС‘ СЂР°Р±РѕС‡РёР№ Р±СѓС„РµСЂ.
main:
                    ldi a, 48
                    st a, 0x3E
                    ldi a, MODEL_BASE
                    st a, out_bank
                    ldi a, MODEL_ADDR
                    st a, out_addr
                    ldi c, 37
                    st c, ret1_bank
                    ldi d, resume_main_6
                    st d, ret1_addr
                    ldi c, 32
                    ldi d, gfx_set_workspace
                    jmp set_bank
resume_main_6:
                    ldi a, MODEL_BASE
                    st a, ptr_bank
                    ldi a, MODEL_ADDR
                    st a, ptr_addr
                    ldi c, 37
                    st c, ret0_bank
                    ldi d, resume_main_11
                    st d, ret0_addr
                    ldi c, 1
                    ldi d, gfx_load_model
                    jmp set_bank
resume_main_11:
                    jmp main_modes

; Р—Р°РґР°С‚СЊ РїСЂРѕРµРєС†РёСЋ, РїСЂРёРјРёС‚РёРІС‹, С†РІРµС‚Р° Рё РѕС‚СЃРµС‡РµРЅРёРµ РІС‹Р·РѕРІР°РјРё РѕР±С‰РµРіРѕ API.
main_modes:
                    ldi a, DEMO_PROJECTION
                    ldi c, 37
                    st c, ret1_bank
                    ldi d, resume_main_modes_1
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_projection
                    jmp set_bank
resume_main_modes_1:
                    ldi a, DEMO_RENDER
                    ldi c, 37
                    st c, ret1_bank
                    ldi d, resume_main_modes_3
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_render_mode
                    jmp set_bank
resume_main_modes_3:
                    ldi a, DEMO_COLOR_MODE
                    ldi c, 37
                    st c, ret1_bank
                    ldi d, resume_main_modes_5
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_color_mode
                    jmp set_bank
resume_main_modes_5:
                    ldi a, DEMO_CULL
                    ldi c, 37
                    st c, ret1_bank
                    ldi d, resume_main_modes_7
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_cull
                    jmp set_bank
resume_main_modes_7:
                    ldi c, 38
                    ldi d, frame_start
                    jmp set_bank
padding37 db 0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #38
;===================================================================================================

; Р’СЃРµ РѕСЃРё РјРµРЅСЏСЋС‚СЃСЏ РїРѕСЃС‚РµРїРµРЅРЅРѕ: Y=n/4, X=n/2, Z=3n/4, РїРѕ РјРѕРґСѓР»СЋ 32.
frame_start:
                    ldi d, 38
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
                    ldi d, 38
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
                    ldi d, 38
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
                    ldi c, 38
                    st c, ret1_bank
                    ldi d, resume_frame_start_20
                    st d, ret1_addr
                    ldi c, 3
                    ldi d, gfx_set_rotation
                    jmp set_bank
resume_frame_start_20:
                    ldi c, 39
                    ldi d, frame_scale
                    jmp set_bank
padding38 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;===================================================================================================
; Р‘Р°РЅРє РїР°РјСЏС‚Рё #39
;===================================================================================================

; РџРѕР»РЅС‹Р№ С†РёРєР» Г—2 в†’ Г—1 в†’ Г—2 Р·Р° 256 РєР°РґСЂРѕРІ, РєР°Рє Сѓ РґРµРјРѕРЅСЃС‚СЂР°С†РёРё 1K.
frame_scale:
                    ldi d, 39
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
                    ldi c, 39
                    st c, ret1_bank
                    ldi d, resume_frame_scale_10
                    st d, ret1_addr
                    ldi c, 33
                    ldi d, gfx_set_scale
                    jmp set_bank
resume_frame_scale_10:
                    jmp frame_draw

; РџРѕСЃС‚СЂРѕРёС‚СЊ РјРѕРґРµР»СЊ РІ LCD RAM РїСЂРё РѕС‚РєР»СЋС‡С‘РЅРЅРѕРј РІС‹РІРѕРґРµ Рё РѕРїСѓР±Р»РёРєРѕРІР°С‚СЊ 64 РіРѕС‚РѕРІС‹С… Р±Р°Р№С‚Р°.
frame_draw:
                    ldi c, 39
                    st c, ret0_bank
                    ldi d, resume_frame_draw_0
                    st d, ret0_addr
                    ldi c, 34
                    ldi d, gfx_begin
                    jmp set_bank
resume_frame_draw_0:
                    ldi c, 39
                    st c, ret0_bank
                    ldi d, resume_frame_draw_1
                    st d, ret0_addr
                    ldi c, 29
                    ldi d, gfx_draw_object
                    jmp set_bank
resume_frame_draw_1:
                    ldi c, 39
                    st c, ret0_bank
                    ldi d, resume_frame_draw_2
                    st d, ret0_addr
                    ldi c, 34
                    ldi d, gfx_present
                    jmp set_bank
resume_frame_draw_2:
                    jmp frame_advance

; РЎР»РµРґСѓСЋС‰Р°СЏ С„Р°Р·Р° 0вЂ¦255; РєР°РґСЂС‹ 0 Рё 128 РёРјРµСЋС‚ РѕРґРёРЅР°РєРѕРІС‹Р№ СЂР°РєСѓСЂСЃ Рё РІРґРІРѕРµ СЂР°Р·РЅС‹Рµ XYZ.
frame_advance:
frame_complete:
                    ldi d, 39
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_advance_1
                    jmp read_byte
io_frame_advance_1:
                    inc a
                    ldi d, 39
                    st d, io_ret_bank
                    ldi c, STATE_BANK
                    ldi b, STATE_PHASE
                    ldi d, io_frame_advance_3
                    jmp write_byte
io_frame_advance_3:
                    ldi c, 38
                    ldi d, frame_start
                    jmp set_bank
