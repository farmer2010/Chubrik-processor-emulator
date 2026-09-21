from utils import *
from emulator import *
import time
import pygame
import crossfiledialog
pygame.mixer.pre_init()
pygame.init()

W = pygame.display.Info().current_w
H = pygame.display.Info().current_h

screen = pygame.display.set_mode((W, H), pygame.FULLSCREEN)
pygame.display.set_caption("emulator")
keep_going = 1
timer = pygame.time.Clock()

font16 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 16)
font14 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 14)
progfont = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 13)

emu = Emulator()

up_buttons_img = pygame.Surface((W, 30))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="open", font=font16), (0, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="restart", font=font16), (150, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="pause", font=font16), (300, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="show panel", font=font16), (450, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="console", font=font16), (600, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="show memory", font=font16), (750, 0))
up_buttons_img.blit(get_button_image(W - 900, 30, 0, color=(180, 180, 180)), (900, 0))

left_buttons_img = get_button_image(300, H - 30, 0, color=(180, 180, 180))
render_text("SPEED:", (5, 200), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 220))
render_text("CONSOLE WIDTH:", (5, 260), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 280))
render_text("CONSOLE HEIGHT:", (5, 320), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 340))

console_background = get_text_box_image(W - 20, H - 30, color=(180, 180, 180))

bank_img = pygame.Surface((90 + 10, 896 + 10))
bank_img.fill((255, 0, 0))
bank_img.set_colorkey((0, 0, 0))
pygame.draw.rect(bank_img, (0, 0, 0), (4, 4, 92, 898))

open_button_pos = 150
restart_button_pos = 300
pause_button_pos = 450
show_panel_button_pos = 600
console_button_pos = 750
memory_button_pos = 900

texts = [str(emu.speed), str(emu.console_w), str(emu.console_h)]
mouse_connect = 0#0 - no, 1 - speed, 2 - console w, 3 - console h
cursor_timer = 0
change_console = 0

menu = "main"
console_scroll = 0
draw_panel = 1

prev_time = 0
steps = 0
tps = 0
while keep_going:
    events = pygame.event.get()
    for event in events:
        if event.type == pygame.QUIT:
            keep_going = 0
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                menu = "main"
            if mouse_connect != 0:
                if event.key == pygame.K_BACKSPACE:
                    texts[mouse_connect - 1] = texts[mouse_connect - 1][:-1]
                    t = texts[mouse_connect - 1]
                    if mouse_connect == 1:
                        emu.speed = int(t) if len(t) > 0 else 0
                if event.unicode in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
                    if len(texts[mouse_connect - 1]) < 12:
                        texts[mouse_connect - 1] += event.unicode
                        t = texts[mouse_connect - 1]
                        if mouse_connect == 1:
                            emu.speed = int(t) if len(t) > 0 else 0
                        elif mouse_connect == 2 or mouse_connect == 3:
                            change_console = 1
            if event.key == pygame.K_F2:
                if change_console:
                    change_console = 0
                    w = int(texts[1]) if len(texts[1]) > 0 else 0
                    h = int(texts[2]) if len(texts[2]) > 0 else 0
                    emu.change_console_scale(w, h)
                emu.load()
            if event.key == pygame.K_F5:
                menu = "console"
            if event.key == pygame.K_F6:
                menu = "memory"
        if event.type == pygame.MOUSEWHEEL and menu == "console":
            console_scroll = max(console_scroll - event.y * 2, 0)
        if event.type == pygame.MOUSEBUTTONDOWN:
            mousepos = pygame.mouse.get_pos()
            if event.button == 1:
                if mousepos[1] < 30:
                    if mousepos[0] < open_button_pos:
                        name = crossfiledialog.open_file(start_dir="files/programs/", filter=["*.asm", "*.txt"])
                        if name != None:
                            if change_console:
                                change_console = 0
                                w = int(texts[1]) if len(texts[1]) > 0 else 0
                                h = int(texts[2]) if len(texts[2]) > 0 else 0
                                emu.change_console_scale(w, h)
                            emu.filename = name
                            emu.load()
                    elif mousepos[0] < restart_button_pos:
                        if change_console:
                            change_console = 0
                            w = int(texts[1]) if len(texts[1]) > 0 else 0
                            h = int(texts[2]) if len(texts[2]) > 0 else 0
                            emu.change_console_scale(w, h)
                        emu.load()
                    elif mousepos[0] < pause_button_pos:
                        emu.pause = not emu.pause
                    elif mousepos[0] < show_panel_button_pos:
                        draw_panel = not draw_panel
                        mouse_connect = 0
                    elif mousepos[0] < console_button_pos:
                        if menu != "console":
                            menu = "console"
                        elif menu == "console":
                            menu = "main"
                        mouse_connect = 0
                    elif mousepos[0] < memory_button_pos:
                        if menu != "memory":
                            menu = "memory"
                        elif menu == "memory":
                            menu = "main"
                        mouse_connect = 0
                #
                if menu == "console":
                    if mousepos[1] > 30 and mousepos[0] > W - 20:
                        lenlines = len(emu.compilation_console.split("\n"))
                        if lenlines > (H - 40) // 20:
                            h = min(1, (H - 40) // 20 / lenlines) * (H - 30)
                            m_y = (mousepos[1] - 30 - h/2) / (H - 30 - h)
                            console_scroll = max(0, int(lenlines * m_y))
                elif menu == "main" and draw_panel:
                    if mousepos[0] > 10 and mousepos[0] < 160:
                        if mousepos[1] > 250 and mousepos[1] < 280:
                            mouse_connect = 1
                        elif mousepos[1] > 310 and mousepos[1] < 340:
                            mouse_connect = 2
                        elif mousepos[1] > 370 and mousepos[1] < 400:
                            mouse_connect = 3
                        else:
                            mouse_connect = 0
                    else:
                        mouse_connect = 0
    #
    #ОБНОВЛЕНИЕ
    #
    fps = round(timer.get_fps(), 2)
    if menu == "main" or menu == "memory":
        current_time = time.time()
        counter = emu.update(events, fps)
        #
        if steps % 10 == 0:
            tps = counter / (current_time - prev_time)
        prev_time = current_time
    #
    #ОТРИСОВКА
    #
    screen.fill((255, 255, 255))
    screen.blit(up_buttons_img, (0, 0))
    #
    if menu == "main" or menu == "memory":
        if emu.compilation_error:
            render_text("[COMPILATION ERROR]", (W / 2, 35), screen, color=(255, 0, 0), font=font48, centerx="center")
        elif emu.stop:
            render_text("[PROGRAM FINISHED]", (W / 2, 35), screen, color=(255, 0, 0), font=font48, centerx="center")
        elif emu.breakpoint:
            render_text("[BREAKPOINT. PRESS F4]", (W / 2, 35), screen, color=(255, 0, 0), font=font48, centerx="center")
        elif emu.pause:
            render_text("[PAUSED]", (W / 2, 35), screen, color=(255, 0, 0), font=font48, centerx="center")
    #
    if menu == "main":
        emu.draw(screen)
        if draw_panel:
            screen.blit(left_buttons_img, (0, 30))
        #
        render_text(f"fps: {fps}", (5, 40), screen, font=font14)
        render_text(f"tps: {round(tps, 1)}", (5, 60), screen, font=font14)
        if draw_panel:
            render_text("index:   , command:", (5, 80), screen, font=font14)
            render_text(f"      {emu.index}", (5, 80), screen, font=font14)
            render_text(f"                   {hex(emu.read(emu.index))}", (5, 80), screen, font=font14)
            render_text("A:    B:    C:    D:", (5, 100), screen, font=font14)
            render_text(f"  {emu.reg[0]}", (5, 100), screen, font=font14)
            render_text(f"        {emu.reg[1]}", (5, 100), screen, font=font14)
            render_text(f"              {emu.reg[2]}", (5, 100), screen, font=font14)
            render_text(f"                    {emu.reg[3]}", (5, 100), screen, font=font14)
            render_text("Z:    S:    C:    O:", (5, 120), screen, font=font14)
            render_text(f"  {int(emu.flags[0])}", (5, 120), screen, font=font14)
            render_text(f"        {int(emu.flags[1])}", (5, 120), screen, font=font14)
            render_text(f"              {int(emu.flags[2])}", (5, 120), screen, font=font14)
            render_text(f"                    {int(emu.flags[3])}", (5, 120), screen, font=font14)
            render_text(f"bank:      {emu.bank}", (5, 140), screen, font=font14)
            render_text(f"display:   {emu.enable_display}", (5, 160), screen, font=font14)
            render_text(f"indicator: {emu.enable_indicator}", (5, 180), screen, font=font14)
            render_text(f"terminal:  {emu.enable_console}", (5, 200), screen, font=font14)
            #
            for i in range(3):
                render_text(texts[i], (20, 258 + 60 * i), screen, font=font14)
            if mouse_connect > 0:
                cursor_timer += 1
                if cursor_timer > fps:
                    cursor_timer = 0
                if cursor_timer < fps/2:
                    pygame.draw.rect(screen, (0, 0, 0), (20 + 11 * len(texts[mouse_connect - 1]), 256 + 60 * (mouse_connect - 1), 2, 18))
    elif menu == "console":
        screen.blit(console_background, (0, 30))
        lines = emu.compilation_console.split("\n")
        if len(lines) <= (H - 40) // 20:
            console_scroll = 0
        if console_scroll > len(lines) - 1:
            console_scroll = len(lines) - 1
        pygame.draw.rect(screen, (100, 100, 100), (W - 20, 30, 20, H - 30))
        h = min(1, (H - 40) // 20 / len(lines)) * (H - 30)
        pygame.draw.rect(screen, (160, 160, 160), (W - 20, 30 + console_scroll / len(lines) * (H - 30 - h), 20, h))
        lpos = 0
        for i in range(console_scroll, console_scroll + (H - 40) // 20):
            if i < len(lines):
                render_text(lines[i], (10, 40 + 20 * lpos), screen, font=font16, antialias=0)
            lpos += 1
    elif menu == "memory":
        for j in range(16):
            for i in range(64):
                ind = i * 2 + 128 * (j > 0)
                if (emu.index == ind or emu.index == ind + 1) and (emu.bank == j or (j == 0 and ind < 128)):
                    h = emu.index - ind
                    pygame.draw.rect(screen, (255, 160, 64), (j * 110 + 160 * (j >= 8) + 10, 14 * i + 90 - 1, 20, 14))
                    pygame.draw.rect(screen, (255, 100, 128), (j * 110 + 160 * (j >= 8) + 50 + 30 * h, 14 * i + 90 - 1, 20, 14))
                render_text(f"{ind:02X}:", (j * 110 + 40 + 160 * (j >= 8), 14 * i + 90), screen, font=progfont, centerx="right", color=(128, 128, 128))
                render_text(f"    {emu.memory[j * 128 + i * 2]:02X} {emu.memory[j * 128 + i * 2 + 1]:02X}", ((i // 64) * 90 + j * 110 + 160 * (j >= 8) + 10, 14 * i + 90), screen, font=progfont)
            render_text(f"bank {j}" if j > 0 else "common", (j * 110 + 160 * (j >= 8) + 20, 1000), screen, font=progfont)
        #
        b = emu.bank
        screen.blit(bank_img, (b * 110 + 160 * (b >= 8) + 5, 84))
    steps += 1
    #
    pygame.display.update()
    timer.tick(1000)
pygame.quit()