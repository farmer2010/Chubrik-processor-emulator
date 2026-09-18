.bank 0


field  db 1,0,0,
          0,2,0,
          0,0,1

; Промежуточные переменные (9 байт)
sPtr   db 0                        ; указатель на таблицу линий
sCnt   db 0                        ; счётчик
sTgt   db 0                        ; целевое значение (1 или 2)
sZ     db 0                        ; число целевых в линии
sE     db 0                        ; число пустых в линии
sEIdx  db 0                        ; индекс пустой клетки
sIdx   db 0                        ; текущий индекс клетки
sTmp   db 0                        ; временная переменная
sRet  db 0                        ; адрес возврата

change_bank:
	st c, bank
    jmp d
	
	
bank db 0
s4_start db 0


.bank 1

s3_start:
        clr a
        st a, sCnt                  ; счётчик кандидатов
        st a, sEIdx                 ; выбранный кандидат
        ldi a, 0
        st a, sIdx                  ; индекс клетки

s3_loop:
        ld a, sIdx
        ldi c, field
        add c, a
        ld b, c
        test b
        jnz s3_next                 ; не пустая - пропускаем

        ; Проверяем, есть ли среди соседей нолик (значение 2)
        ld a, sIdx
        ldi c, neigh_off
        add c, a
        ld d, c                     ; d = смещение списка соседей
        ldi c, neigh
        add c, d                    ; c = указатель на список

n_loop:
        ld a, c                     ; a = индекс соседа
        inc c
        ldi d, 0xFF
        xor a, d
        jz n_no                     ; конец списка
        ldi d, field
        add d, a
        ld a, d                     ; a = field[сосед]
        ldi d, 2
        xor a, d
        jz n_yes                    ; нашли нолик
        jmp n_loop

n_yes:
        clr a
        test a                      ; Z=1 (есть нолик рядом)
        jmp n_done

n_no:
        ldi a, 1
        test a                      ; Z=0 (нолика рядом нет)

n_done:
        jnz s3_next                 ; нолика рядом нет - пропускаем

        ; Кандидат найден. Резервуарная выборка: с вероятностью 1/cnt выбираем его.
        ld a, sCnt
        inc a
        st a, sCnt
        dec a
        jz s3_select                ; первый кандидат - выбираем всегда

        rnd a
        ld b, sCnt
s3_mod:
        sub a, b
        jns s3_mod
        add a, b                    ; a = random % cnt
        test a
        jnz s3_next

s3_select:
        ld a, sIdx
        st a, sEIdx

s3_next:
        ld a, sIdx
        inc a
        st a, sIdx
        ldi b, 9
        xor a, b
        jnz s3_loop

        ; Если кандидатов нет - переходим к шагу 4
        ld a, sCnt
        test a
        jz go_s4

        ; Возвращаем адрес выбранного кандидата
        ldi a, field
        ld b, sEIdx
        add a, b
        jmp ret_b2

go_s4:
        ldi c, 3                    ; переключаемся на банк 3
        ldi d, s4_start
        jmp change_bank

; --------------------------------------------------------------------------------------------------
; Возврат из бота (результат в B)
; --------------------------------------------------------------------------------------------------
ret_b2:
        mov b, a
        ldi c, 1
        ld d, sRet
        jmp change_bank

; Таблица смещений списков соседей для каждой клетки
neigh_off db 0,4,10,14,20,29,35,39,45

; Списки соседей (8-связность), 0xFF - конец списка
neigh  db 1,3,4,0xFF,
          0,2,3,4,5,0xFF,
          1,4,5,0xFF,
          0,1,4,6,7,0xFF,
          0,1,2,3,5,6,7,8,0xFF,
          1,2,4,7,8,0xFF,
          3,4,7,0xFF,
          3,4,5,6,8,0xFF,
          4,5,7,0xFF

.bank 2
