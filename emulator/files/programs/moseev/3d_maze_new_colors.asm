start_coord equ 0xe3 ;координата старта игрока
RED equ 1
BLUE equ 2
VIOLET equ 3
start:
ldi c, 4 ;переходим к старту пускания лучей
ldi d, start_rays
set_bank: ;банкинг
  st c, bank
  jmp d
to_move: ;переход на движение координаты после добавления косинуса
  st a, cos ;сохраняем полученный косинус
  ldi c, 2 ;переходим
  st c, bank
  jmp move
ray_wall: ;конец обработки врезания луча в стену
  ld a, walls ;уменьшаем количество лучей, которые не врезались в стену
  dec a
  st a, walls
  ldi c, 4 ;переходим
  st c, bank
  jmp check_end_ray
to_end_ray: ;переход после обработки луча
  ldi c, 4
  st c, bank
  jmp end_ray
read_color_step: ;чтение цвета стены и количества шагов, которое прошёл луч
  ;регистр d уже содержит 5
  ;регистр b уже содержит адрес чтения цвета
  ;регистр c уже содержит адрес чтения количества шагов, которое прошёл луч
  st d, bank ;переключаемся на 5 банк
  ld b, b ;читаем цвет
  ld c, c ;читаем шаги
  inc d ;6 банк
  st d, bank ;переходим обратно
  jmp next_draw
void db 0
player_coord db start_coord ;координата игрока
dir db 0 ;8-битное направление игрока
speed db 0 ;скорость (-1 или 1) синуса или косинуса
speed_x db 0 ;скорость (от -1 до 1) движения по x
speed_y db 0 ;скорость (от -1 до 1) движения по y
sin db 0 ;результат синуса
cos db 0 ;результат косинуса
save1 db 0 ;сохранение важных значений
save2 db 0
walls db 0 ;количество лучей, которые не врезались в стену
i db 0 ;счётчик для больших циклов
;аргументы основной функции движения
f_output_adress_wall db 0 ;адрес перехода при врезании в стену
f_bank_output_load db 0 ;банк всех переходов
f_adress_output db 0 ;адрес перехода в конце функции
f_adress_load_sin db 0 ;адрес чтения синуса
f_adress_load_cos db 0 ;адрес чтения косинуса
f_coord db 0 ;координата
f_dir db 0 ;направление
terminal db 0, 0 ;терминал
in_out db 0b00110001 ;ввод-вывод (подключён цветной дисплей и терминал)
bank db 0 ;банк
display_r db ;заставка
0b00000000, 0b00100011,
0b00000000, 0b00101010,
0b00100010, 0b00101010,
0b00101010, 0b00101010,
0b00100000, 0b00101010,
0b00100000, 0b00101000,
0b00000000, 0b00101000,
0b00001010, 0b00101000,
0b00101010, 0b00101000,
0b00101010, 0b00101000,
0b00100010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00001000
display_b db
0b00000000, 0b00000001,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
;BANK 1: BANK SIN_COS - содержит обработку направления, синусов и косинусов
raycast: ;функция движения
start_sin:
  ld a, f_dir ;читаем направление
  clr c ;очищаем скорости
  st c, speed_x
  st c, speed_y
  ld d, f_adress_load_sin ;читаем адрес перехода для чтения синуса
  ldi b, 1 ;скорость для движения вправо
  jmp get_sin ;переходим к получению синуса

add_cos: ;добавление косинуса
  ;регистр a уже содержит косинус от направления
  ;регистр b уже содержит старый косинус
  add a, b ;добавляем
  jns to_move ;если результат больше 1, значит нужно перемещать координату по y (старший бит = 1)
  ld c, speed ;читаем скорость
  st c, speed_y ;сохраняем в скорость движения по y
  shl a ;обрезаем старший бит (вычитаем 1)
  shr a
  jmp to_move ;переход

add_sin: ;добавление синуса
  ;регистр a уже содержит синус от направления
  ;регистр b уже содержит старый синус
  add a, b ;добавляем
  jns start_cos ;если результат больше 1, значит нужно перемещать координату по x (старший бит = 1)
  ld c, speed ;читаем скорость
  st c, speed_x ;сохраняем в скорость движения по x
  shl a ;обрезаем старший бит (вычитаем 1)
  shr a

start_cos:
  st a, sin ;сохраняем полученный синус
  ld a, f_dir ;читаем направление
  ld d, f_adress_load_cos ;читаем адрес перехода для чтения косинуса
  ldi b, 0 - 1 ;скорость для движения вверх

get_cos: ;получение косинуса
  ldi c, 45 ;cos(a) = sin(45 - a)
  sub c, a
  mov a, c
  jnc get_sin ;если результат положительный, переходим на получение синуса
  ldi c, 180 ;иначе прибавляем 180 и получаем положительное число
  add a, c

get_sin:
  ldi c, 90 ;если направление больше 90, значит двигаться нужно в противоположную сторону
  sub c, a
  jc neg_sin
pos_sin: ;направление меньше 90 (движение вправо)
  st b, speed ;сохраняем скорость для движения в нужную сторону
  jmp read_sin
neg_sin:
  neg b ;скорость движения в противоположную сторону
  st b, speed
  ldi c, 90 ;вычитаем 90, чтобы направление было от 0 до 90
  sub a, c
read_sin:
  ldi c, 45 ;если полученное направление меньше 45, переходим сразу к чтению
  sub c, a
  jnc read
  ldi c, 90 ;иначе из 90 вычитаем направление и получаем новое значение от 0 до 45
  sub c, a
  mov a, c
read:
  ldi c, table_sin ;читаем значение синуса
  add a, c
  ld a, a
  ld c, f_bank_output_load ;читаем банк перехода
  jmp set_bank ;переходим на чтение синуса/косинуса

;все значения синусов от 0 до 45 (старший бит = 1)
table_sin db 0b00000000, 0b00000100, 0b00001000, 0b00001101, 0b00010001,
0b00010110, 0b00011010, 0b00011110, 0b00100011, 0b00100111,
0b00101011, 0b00101111, 0b00110011, 0b00110111, 0b00111011,
0b01000000, 0b01000100, 0b01000111, 0b01001011, 0b01001110,
0b01010010, 0b01010101, 0b01011001, 0b01011100, 0b01011111,
0b01100010, 0b01100101, 0b01100111, 0b01101010, 0b01101100,
0b01101110, 0b01110001, 0b01110011, 0b01110101, 0b01110111,
0b01111000, 0b01111001, 0b01111010, 0b01111011, 0b01111100,
0b01111101, 0b01111110, 0b01111110, 0b01111111, 0b01111111,
0b10000000
;BANK 2: BANK MOVE - содержит движение координаты
;BANK SETTINGS_PLAYER - содержит настройки для игрока
;BANK MOVE
move:
  ld a, f_coord ;читаем координату
  mov b, a ;копируем
  ldi d, 0x0f ;в a - x
  and a, d
  shr b ;в b - y
  shr b
  shr b
  shr b
move_x:
  ld c, speed_x ;читаем скорость движения по x
  add a, c ;добавляем
  test c
  jz move_y ;если скорость 0, пропускаем проверку
  js move_left ;если отрицательная, переходим на проверку для неё
move_right: ;проверка для положительной скорости
  and a, d ;0 получается только если 15 + 1 = 16, 16 & 15 = 0
  jz wall_edge ;если 0 есть, значит переходим к попаданию на границу карты
  jmp move_y ;иначе переходим к движению по y
move_left: ;проверка для отрицательной скорости
  test a ;флаг s получается только если 0 + (-1) = -1
  js wall_edge ;если флаг s есть, значит переходим к попаданию на границу карты
move_y: ;то же самое, что и для x, но для y
  ld c, speed_y
  add b, c
  test c
  jz move_end
  js move_up
move_down:
  and b, d
  jnz move_end
wall_edge: ;обработка попадания на границу карты
  ldi a, BLUE ;границы карты синего цвета
  ld c, f_bank_output_load ;читаем банк перехода
  ld d, f_output_adress_wall ;читаем адрес перехода для стены
  jmp set_bank ;переходим
move_up:
  test b
  js wall_edge
move_end:
  st a, save1 ;сохраняем новые координаты
  st b, save2
  ldi c, 7 ;превращаем их в позицию и адрес
  and c, a
  shr a
  shr a
  shr a
  shl b
  add b, a
  ldi a, 0b10000000
  shr_loop:
    shr a
    dec c
    jns shr_loop
  rcl a
  ldi c, 3 ;переходим на проверку столкновения со стенами
  ldi d, check_wall
  jmp set_bank
;BANK SETTINGS_PLAYER
set_settings_player:
  ldi a, 7 ;банк всех переходов
  st a, f_bank_output_load
  ldi a, check_game_over ;если врезаемся, проверяем на финиш
  st a, f_output_adress_wall
  ldi a, save_coord_player ;после перемещения сохраняем новую координату
  st a, f_adress_output
  ldi a, player_load_sin ;чтение синуса игрока
  st a, f_adress_load_sin
  ldi a, player_load_cos ;чтение косинуса игрока
  st a, f_adress_load_cos
  ld a, player_coord ;координата игрока
  st a, f_coord
  ld a, dir ;8-битное направление игрока
  st a, f_dir
  clr c ;переходим к старту перемещения
  ldi d, raycast
  jmp set_bank

void3 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0

;BANK 3: BANK MAP - содержит карту и проверку на столкновение с ней
check_wall:
  ldi d, ver ;карта вертикальных линий
  add d, b ;добавляем адрес
  ld c, d ;читаем байт
  and c, a ;если попали на стену, значит сохраняем красный цвет
  jz check_hor
  ldi a, RED
  jmp wall_jmp
check_hor: ;то же самое, что и для вертикальной, но для горизонтальной
  ldi d, hor
  add d, b
  ld c, d
  and c, a
  jz check_win
  ldi a, BLUE ;у горизонтальных стен синий цвет
  jmp wall_jmp
check_win:
  shr a ;позиция 0b00000001 - позиция финиша
  jnc save_jmp
check_win_adress:
  dec b ;адрес 1 - адрес финиша
  jnz save_jmp
  ldi a, VIOLET ;у финиша фиолетовый цвет
wall_jmp: ;переход в случае попадания на стену
  ld c, f_bank_output_load
  ld d, f_output_adress_wall
  jmp set_bank
save_jmp:
  ld a, save1 ;читаем координаты
  ld b, save2
  shl b ;сохраняем в один байт
  shl b
  shl b
  shl b
  or a, b
  ld c, f_bank_output_load ;читаем банк перехода
  ld d, f_adress_output ;читаем адрес перехода в конце функции
  jmp set_bank ;переходим

void4 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

hor db ;карта горизонтальных линий
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
ver db ;карта вертикальных линий
0b00000000, 0b00100010,
0b00000000, 0b00101010,
0b00100010, 0b00101010,
0b00101010, 0b00101010,
0b00100000, 0b00101010,
0b00100000, 0b00101000,
0b00000000, 0b00101000,
0b00001010, 0b00101000,
0b00101010, 0b00101000,
0b00101010, 0b00101000,
0b00100010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00001000

;BANK 4: BANK RAYS 1 - содержит пускание лучей, их координаты и конец движения
start_rays:
  ldi b, 16 ;обновляем количество лучей, которые не врезались в стену
  st b, walls
  dec b ;15
start_ray:
  st b, i ;сохраняем номер луча
set_settings:
  ldi a, 5 ;банк всех переходов
  st a, f_bank_output_load
  ldi a, save_color ;если луч попадёт в стену, цвет сохраняем
  st a, f_output_adress_wall
  ldi a, next_step ;адрес в конце функции
  st a, f_adress_output
  ldi a, ray_load_sin ;адрес загрузки синуса луча
  st a, f_adress_load_sin
  ldi a, ray_load_cos ;адрес загрузки косинуса луча
  st a, f_adress_load_cos
  ldi c, coord_rays ;адрес координат лучей
  add c, b ;добавляем номер луча и получаем адрес координаты для луча
  ld a, c ;читаем
  st a, f_coord ;сохраняем
  shl b ;умножаем на 2
  ldi a, 165 ;прибавляем 165 и получаем направление от -15 до 15
  add a, b
  clr b ;старший байт
  ld c, dir ;читаем направление
  add a, c ;добавляем
  jnc dir_mod
  inc b ;если направление превысило 256, то старший байт = 1
dir_mod: ;вычисляем остаток от деления направления на 180
  ldi c, 179
  clr d
  sub c, a
  sbb d, b
  jnc set_dir
  ldi c, 180
  clr d
  sub a, c
  sbb b, d
  jmp dir_mod
set_dir:
  st a, f_dir ;сохраняем направление
  clr c ;переходим к старту функции
  ldi d, raycast
  jmp set_bank

end_ray:
  ldi c, coord_rays ;сохраняем новую координату
  add c, b
  st a, c
check_end_ray:
  dec b ;следующий луч
  jns start_ray ;если лучи не закончились, продолжаем
  ld a, walls ;иначе читаем количество лучей, которые не врезались в стену
  test a ;если их не 0, значит свободные лучи ещё остались
  jnz start_rays ;поэтому переходим на дальнейшее движение лучей
  ldi c, 6 ;если все лучи врезались, переходим к отрисовке
  ldi d, clear_display
  jmp set_bank

clear_coord_rays: ;сбрасывание координат лучей
  ;регистр a уже содержит координату
  ldi b, clear_coord_rays_loop ;адрес цикла
  ldi d, coord_rays ;адрес координат лучей
clear_coord_rays_loop:
  st a, d ;сбрасываем координату
  inc d ;следующая
  jnz b ;если не закончились, повторяем
clr a ;очищаем
ldi c, 5 ;переходим к сбросу других параметров
ldi d, clear
jmp set_bank

void5 db 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0

;координаты лучей
coord_rays db start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord
;BANK 5: BANK RAYS 2 - содержит много параметров лучей и их обработку
ray_load_sin: ;чтение синуса у луча
  ld b, i ;номер луча
  ldi c, sin_rays ;адрес синусов
  add c, b
  ld b, c ;читаем синус
  clr c ;переходим на добавление
  ldi d, add_sin
  jmp set_bank
ray_load_cos: ;чтение косинуса у луча
  ;то же самое, что и чтение синуса, но косинус
  ld b, i
  ldi c, cos_rays
  add c, b
  ld b, c
  clr c
  ldi d, add_cos
  jmp set_bank

save_color: ;сохранение цвета, если луч врезался в стену
  ld b, i ;читаем номер
  ldi d, rays_color ;адрес цветов
  add d, b
  st a, d ;сохраняем цвет
  jmp ray_wall ;переход

next_step: ;конец функции
  ld b, i ;читаем номер
  ldi d, sin_rays ;адрес синусов
  add d, b
  ld c, sin ;читаем синус
  st c, d ;сохраняем
  ldi d, cos_rays ;адрес косинусов
  add d, b
  ld c, cos ;читаем косинус
  st c, d ;сохраняем
  ldi d, rays_steps ;адрес шагов, которое прошли лучи
  add d, b
  ld c, d ;читаем
  inc c ;увеличиваем
  st c, d ;сохраняем
  jmp to_end_ray ;переход

clear: ;очищаем другие параметры
  ;регистр a пустой
  ldi b, clear_loop ;адрес цикла
  ldi d, rays_steps ;адрес параметров
clear_loop:
  st a, d ;сбрасываем
  inc d ;следующий
  jnz b ;если не закончились, повторяем
jmp start ;переходим к самому началу

void6 db 0, 0, 0

;цвета стен, в которые врезались лучи
rays_color db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;количество шагов, которое прошёл каждый луч
rays_steps db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;синусы лучей
sin_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;косинусы лучей
cos_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0

;BANK 6: BANK DRAW - содержит отрисовку стен
clear_display:
  clr a ;очищаем
  ldi b, clear_display_loop ;адрес цикла
  ldi d, display_r ;дисплей
clear_display_loop:
  st a, d ;очищаем байт дисплея
  inc d ;следующий байт
  jns b ;если не закончились, повторяем
draw:
  st a, i ;сохраняем счётчик
  ldi b, rays_color ;адрес чтения цвета
  add b, a
  ldi c, rays_steps ;адрес чтения количества шагов
  add c, a
  ldi d, 5 ;банк чтения
  jmp read_color_step ;переходим на чтение
  next_draw:
    st b, color ;сохраняем цвет
    ldi d, 15 ;если количество шагов больше 15, назначаем 15
    sub d, c
    jnc i_to_pos
    ldi c, 15
  i_to_pos:
    ldi d, 7 ;вычисляем позицию в байте
    and d, a
    ldi b, 0b10000000
    draw_shr_loop:
      shr b
      dec d
      jns draw_shr_loop
    rcl b
  ldi d, 16 ;из 16 вычитаем количество шагов (чем меньше прошёл луч, тем ближе стена)
  sub d, c
  mov c, d
  st c, iter ;сохраняем
check_red:
  ld d, color ;читаем цвет
  shr d ;если красного пигмента нет, переходим на проверку синего
  jnc check_blue
  ldi d, check_blue ;если есть, сохраняем адрес перехода после вывода стены
  st d, next
  ldi d, display_r + 16 ;красный дисплей
  jmp draw_wall
check_blue: ;то же самое, что и для красного, но для синего пигмента
  ld d, color
  shr d
  shr d
  jnc draw_end
  ldi d, draw_end
  st d, next
  ldi d, display_b + 16
  jmp draw_wall
draw_end:
  inc a ;следующий луч
  ldi b, 16 ;если не закончились, повторяем
  xor b, a
  jnz draw
ldi c, 7 ;переходим на чтение клавиши
ldi d, key_read
jmp set_bank
draw_wall:
  shr c ;обрезаем младший бит
  shl c
  sub d, c ;вычитаем из центра дисплея
  shr a ;при необходимости переключаемся на правую половину дисплея
  shr a
  shr a
  add d, a
  ld c, iter ;читаем количество итераций
draw_wall_loop:
  ld a, d ;читаем байт
  or a, b ;зажигаем пиксель
  st a, d ;выводим
  inc d ;следующий байт ниже
  inc d
  dec c ;повторяем количество итераций
  jnz draw_wall_loop
ld a, i ;читаем номер
ld c, iter ;читаем количество итераций
ld d, next ;читаем адрес перехода
jmp d ;переходим по адресу
next db 0 ;адрес перехода после вывода пигмента стены
iter db 0 ;количество итераций
color db 0 ;цвет
void7 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0
;BANK 7: BANK PLAYER - содержит обработку игрока
key_read:
  ld a, in_out ;читаем ввод
  ldi b, 0x11 ;клавиша влево
  sub a, b
  jz left
  dec a ;клавиша вверх
  jz move_player
  dec a ;клавиша вправо
  jnz key_read
right:
  ld a, player_dir + 1 ;читаем младший байт направления
  ld b, player_dir ;читаем старший байт направления
  ldi c, 15 ;добавляем 15
  clr d
  add a, c
  adc b, d
  ldi c, 359 - 256 ;если превысили 359, обнуляем
  inc d
  sub c, a
  sbb d, b
  jnc save_dir
  clr a
  clr b
  jmp save_dir
left:
  ld a, player_dir + 1 ;читаем младший байт направления
  ld b, player_dir ;читаем старший байт направления
  ldi c, 15 ;вычитаем 15
  clr d
  sub a, c
  sbb b, d
  jnc save_dir ;если меньше 0, задаём направление 360 - 15
  ldi a, 360 - 15 - 256
  ldi b, 1
save_dir:
  st a, player_dir + 1 ;сохраняем 16-битное направление
  st b, player_dir
  shr b ;делим на 2 и получаем 8-битное направление
  rcr a
  st a, dir ;сохраняем
jmp_clear:
  ld a, player_coord ;читаем координату
  ldi c, 4 ;переходим на обновление параметров лучей
  ldi d, clear_coord_rays
  jmp set_bank
move_player: ;движение игрока
  ldi c, 2 ;переходим на задание настроек
  ldi d, set_settings_player
  jmp set_bank
player_load_sin:
  ld b, sin_player ;чтение синуса игрока
  clr c
  ldi d, add_sin
  jmp set_bank
player_load_cos:
  ld b, cos_player ;чтение косинуса игрока
  clr c
  ldi d, add_cos
  jmp set_bank
check_game_over:
  dec a ;если в a значение 2, значит игрок врезался в финиш
  dec a
  jz game_over ;поэтому выводим победный текст
  jmp jmp_clear
save_coord_player:
  st a, player_coord ;сохраняем новую координату игрока
  ld a, sin ;сохраняем новый синус игрока
  st a, sin_player
  ld a, cos ;сохраняем новый косинус игрока
  st a, cos_player
  jmp jmp_clear ;переходим на обновление параметров лучей
game_over:
  ldi b, game_over_loop ;адрес цикла
  ldi c, text_game_over ;адрес текста
  ldi d, terminal ;адрес вывода
game_over_loop:
  ld a, c ;читаем символ
  st a, d ;выводим
  inc c ;следующий символ
  jnz b ;если не закончились, повторяем
hlt ;конец
void8 db 0
player_dir db 0, 0 ;16-битное направление игрока
sin_player db 0 ;синус игрока
cos_player db 0 ;косинус игрока
text_game_over db "  You win!" ;победный текст