from utils import *
from emulator import *
import time
import pygame
import crossfiledialog
from constant import *
pygame.mixer.pre_init()
pygame.init()

pygame.mixer.set_num_channels(1000)

screen = pygame.display.set_mode((W, H), pygame.FULLSCREEN)
pygame.display.set_caption(emuname)
keep_going = 1
timer = pygame.time.Clock()

emu = Emulator()

up_buttons_img = pygame.Surface((W, 30))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="open", font=font16), (0, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="restart", font=font16), (150, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="pause", font=font16), (300, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="show panel", font=font16), (450, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="console", font=font16), (600, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="show memory", font=font16), (750, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="counter", font=font16), (900, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="save state", font=font16), (1050, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="load state", font=font16), (1200, 0))
up_buttons_img.blit(get_button_image(W - 1350, 30, 0, color=(180, 180, 180)), (1350, 0))

left_buttons_img = get_button_image(300, H - 30, 0, color=(180, 180, 180))
render_text("SPEED:", (5, 200), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 220))
render_text("CONSOLE WIDTH:", (5, 260), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 280))
render_text("CONSOLE HEIGHT:", (5, 320), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(150, 30, color=(160, 160, 160)), (10, 340))
render_text("TOGGLE KEYS", (40, 380), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(24, 24, color=(160, 160, 160)), (10, 373))
render_text("SELECT EMULATOR:", (5, 410), left_buttons_img, font=font14)
render_text("(Change will clear the", (5, 430), left_buttons_img, font=font14)
render_text("emulator state)", (5, 450), left_buttons_img, font=font14)
render_text("computer v1", (40, 480), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(24, 24, color=(160, 160, 160)), (10, 474))
render_text("computer v2", (40, 510), left_buttons_img, font=font14)
left_buttons_img.blit(get_text_box_image(24, 24, color=(160, 160, 160)), (10, 504))

radiobutton_img = get_button_image(18, 18, 0, color=(180, 180, 180))

console_background = get_text_box_image(W - 20, H - 30, color=(180, 180, 180))

bank_img = pygame.Surface((90 + 10, 896 + 10))
bank_img.fill((255, 0, 0))
bank_img.set_colorkey((0, 0, 0))
pygame.draw.rect(bank_img, (0, 0, 0), (4, 4, 92, 898))

left_button_img_enabled = get_button_image(80, 80, 0, color=(180, 180, 180))
render_text("<", (40, 40), left_button_img_enabled, centerx="center", centery="center", font=font48)
right_button_img_enabled = get_button_image(80, 80, 0, color=(180, 180, 180))
render_text(">", (40, 40), right_button_img_enabled, centerx="center", centery="center", font=font48)
left_button_img_disabled = get_button_image(80, 80, 1, color=(90, 90, 90))
render_text("<", (40, 40), left_button_img_disabled, centerx="center", centery="center", font=font48)
right_button_img_disabled = get_button_image(80, 80, 1, color=(90, 90, 90))
render_text(">", (40, 40), right_button_img_disabled, centerx="center", centery="center", font=font48)

open_button_pos = 150
restart_button_pos = 300
pause_button_pos = 450
show_panel_button_pos = 600
console_button_pos = 750
memory_button_pos = 900
counter_button_pos = 1050
save_button_pos = 1200
load_button_pos = 1350

texts = ["", str(emu.console_w), str(emu.console_h)]
page = 0

def get_param_text(i):
    if i == 0:
        return(str(emu.speed))
    elif i == 1:
        return(texts[1])
    elif i == 2:
        return(texts[2])
    return("")

def set_param(i, text):
    if i == 0:
        emu.speed = int(text) if text != "" else 0
    elif i == 1:
        texts[1] = text
    elif i == 2:
        texts[2] = text


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
    mods = pygame.key.get_mods()
    events = pygame.event.get()
    keys = pygame.key.get_pressed()
    for event in events:
        if event.type == pygame.QUIT:
            keep_going = 0
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                menu = "main"
            if mouse_connect != 0:
                if event.key == pygame.K_BACKSPACE:
                    t = get_param_text(mouse_connect - 1)[:-1]
                    set_param(mouse_connect - 1, t)
                    if mouse_connect == 2 or mouse_connect == 3:
                        change_console = 1
                if event.unicode in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
                    if len(get_param_text(mouse_connect - 1)) < 12:
                        t = get_param_text(mouse_connect - 1) + event.unicode
                        set_param(mouse_connect - 1, t)
                        if mouse_connect == 2 or mouse_connect == 3:
                            change_console = 1
            if event.key == pygame.K_F2:
                if change_console:
                    change_console = 0
                    w = int(texts[1]) if len(texts[1]) > 0 else 0
                    h = int(texts[2]) if len(texts[2]) > 0 else 0
                    emu.change_console_scale(w, h)
                emu.load()
            if event.key == pygame.K_F5:
                if menu != "console":
                    menu = "console"
                elif menu == "console":
                    menu = "main"
                mouse_connect = 0
            if event.key == pygame.K_F6:
                if menu != "memory":
                    menu = "memory"
                elif menu == "memory":
                    menu = "main"
                mouse_connect = 0
            if event.key == pygame.K_F7:
                if menu != "counter":
                    menu = "counter"
                elif menu == "counter":
                    menu = "main"
                mouse_connect = 0
            if event.key == pygame.K_F9:
                emu.toggle_keys = not emu.toggle_keys
            if mods & pygame.KMOD_CTRL:
                if event.key == pygame.K_o:
                    name = crossfiledialog.open_file(start_dir=os.path.abspath("files/programs/"), filter=["*.asm", "*.txt"])
                    if name != None:
                        if change_console:
                            change_console = 0
                            w = int(texts[1]) if len(texts[1]) > 0 else 0
                            h = int(texts[2]) if len(texts[2]) > 0 else 0
                            emu.change_console_scale(w, h)
                        emu.filename = name
                        emu.load()
                if event.key == pygame.K_LEFT:
                    page -= 1
                    if page < 0:
                        page = 0
                if event.key == pygame.K_RIGHT:
                    page += 1
                    if page > 15:
                        page = 15
        if event.type == pygame.MOUSEWHEEL and menu == "console":
            console_scroll = max(console_scroll - event.y * 2, 0)
        if event.type == pygame.MOUSEBUTTONDOWN:
            mousepos = pygame.mouse.get_pos()
            if event.button == 1:
                if mousepos[1] < 30:
                    if mousepos[0] < open_button_pos:
                        name = crossfiledialog.open_file(start_dir=os.path.abspath("files/programs/"), filter=["*.asm", "*.txt"])
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
                    elif mousepos[0] < counter_button_pos:
                        if menu != "counter":
                            menu = "counter"
                        elif menu == "counter":
                            menu = "main"
                        mouse_connect = 0
                    elif mousepos[0] < save_button_pos:
                        filename = crossfiledialog.save_file(start_dir=os.path.abspath("files/saves/"), filter=["*.dat"])
                        if filename != None:
                            emu.save_state(filename + ".dat")
                    elif mousepos[0] < load_button_pos:
                        filename = crossfiledialog.open_file(start_dir=os.path.abspath("files/saves/"), filter=["*.dat"])
                        if filename != None:
                            emu.load_state(filename)
                #
                if menu == "main" and draw_panel:
                    if mousepos[0] > 10 and mousepos[0] < 160:
                        if mousepos[1] > 250 and mousepos[1] < 280:
                            mouse_connect = 1
                            cursor_timer = 0
                        elif mousepos[1] > 310 and mousepos[1] < 340:
                            mouse_connect = 2
                            cursor_timer = 0
                        elif mousepos[1] > 370 and mousepos[1] < 400:
                            mouse_connect = 3
                            cursor_timer = 0
                        else:
                            mouse_connect = 0
                    else:
                        mouse_connect = 0
                    if mousepos[0] > 10 and mousepos[0] < 34 and mousepos[1] > 403 and mousepos[1] < 427:
                        emu.toggle_keys = not emu.toggle_keys
                elif menu == "console":
                    if mousepos[1] > 30 and mousepos[0] > W - 20:
                        lenlines = len(emu.compilation_console.split("\n"))
                        if lenlines > (H - 40) // 20:
                            h = min(1, (H - 40) // 20 / lenlines) * (H - 30)
                            m_y = (mousepos[1] - 30 - h/2) / (H - 30 - h)
                            console_scroll = max(0, int(lenlines * m_y))
                elif menu == "memory":#(W / 2 + 10, H - 90), (W / 2 - 90, H - 90) 80*80
                    if mousepos[1] > H - 90 and mousepos[1] < H - 10 and mousepos[0] > W / 2 - 90 and mousepos[0] < W / 2 + 90:
                        if mousepos[0] < W / 2 - 10:#left button
                            if page > 0:
                                page -= 1
                        elif mousepos[0] > W / 2 + 10:
                            if page < 15:
                                page += 1
    #
    #ОБНОВЛЕНИЕ
    #
    fps = round(timer.get_fps(), 2)
    if menu == "main" or menu == "memory" or menu == "counter":
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
    if menu == "main" or menu == "memory" or menu == "counter":
        alerts = []
        if emu.compilation_error:
            alerts.append("[COMPILATION ERROR]")
        elif emu.stop:
            alerts.append("[PROGRAM FINISHED]")
        elif emu.breakpoint:
            alerts.append("[BREAKPOINT. PRESS F4]")
        elif emu.invalid_console_scale:
            alerts.append("[INVALID CONSOLE SCALE]")
        elif emu.file_not_found:
            alerts.append("[FILE NOT FOUND]")
        if emu.pause:
            alerts.append("[PAUSED]")
        for i in range(len(alerts)):
            render_text(alerts[i], (W / 2, 35 + i * 35), screen, color=(255, 0, 0), font=font_alert, centerx="center")
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
                t = get_param_text(i)
                render_text(t, (20, 258 + 60 * i), screen, font=font14)
            if mouse_connect > 0:
                cursor_timer += 1
                if cursor_timer > fps:
                    cursor_timer = 0
                if cursor_timer < fps/2:
                    pygame.draw.rect(screen, (0, 0, 0), (20 + 11 * len(get_param_text(mouse_connect - 1)), 256 + 60 * (mouse_connect - 1), 2, 18))
            #
            if emu.toggle_keys:
                screen.blit(radiobutton_img, (13, 406))
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
            bank = page * 16 + j
            for i in range(64):
                ind = i * 2 + 128 * (bank > 0)
                if (emu.index == ind or emu.index == ind + 1) and (emu.bank == bank or (bank == 0 and ind < 128)):
                    h = emu.index - ind
                    pygame.draw.rect(screen, (255, 160, 64), (j * 110 + 160 * (j >= 8) + 10, 14 * i + 90 - 1, 20, 14))
                    pygame.draw.rect(screen, (255, 100, 128), (j * 110 + 160 * (j >= 8) + 50 + 30 * h, 14 * i + 90 - 1, 20, 14))
                render_text(f"{ind:02X}:", (j * 110 + 40 + 160 * (j >= 8), 14 * i + 90), screen, font=progfont, centerx="right", color=(128, 128, 128))
                render_text(f"    {emu.memory[bank * 128 + i * 2]:02X} {emu.memory[bank * 128 + i * 2 + 1]:02X}", ((i // 64) * 90 + j * 110 + 160 * (j >= 8) + 10, 14 * i + 90), screen, font=progfont)
            render_text(f"bank {bank}" if bank > 0 else "common", (j * 110 + 160 * (j >= 8) + 20, 1000), screen, font=progfont)
        #
        b = emu.bank % 16
        if emu.bank >= page * 16 and emu.bank < page * 16 + 16:
            screen.blit(bank_img, (b * 110 + 160 * (b >= 8) + 5, 84))
        screen.blit(right_button_img_enabled if page < 15 else right_button_img_disabled, (W / 2 + 10, H - 90))
        screen.blit(left_button_img_enabled if page > 0 else left_button_img_disabled, (W / 2 - 90, H - 90))
        render_text(f"page {page}", (W / 2 - 40, H - 120), screen, font=font16)
    elif menu == "counter":
        gp = lambda x, y: (W / 2 - 800 + (x * 200 + 30) + 10, H / 2 - 400 + 16 * y)
        gpp = lambda x, y: (W / 2 - 800 + (x * 200 + 40) + 10, H / 2 - 400 + 16 * y)
        for i in range(32):
            for j in range(8):
                ind = j * 32 + i
                render_text(f"{opcodes[ind] if opcodes[ind] != 0 else f"0x{ind:02X}"}:", gp(j, i), screen, font=font15, centerx="right", color=(128, 128, 128))
                render_text(f"{emu.opers_types_count[ind]}", gpp(j, i), screen, font=font15)
        render_text(f"All: {emu.opers_count}", (W / 2 - 800 - 5, H / 2 - 400 - 32), screen, font=font15)
        #
        #
        render_text("nop:", gp(2, 34), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0]}", gpp(2, 34), screen, font=font15)
        #
        render_text("hlt:", gp(2, 35), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[1]}", gpp(2, 35), screen, font=font15)
        #
        render_text("ssp:", gp(2, 36), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[2]}", gpp(2, 36), screen, font=font15)
        #
        render_text("jmp:", gp(2, 37), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[3]}", gpp(2, 37), screen, font=font15)
        #
        render_text("jmp X:", gp(2, 38), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[4:8])}", gpp(2, 38), screen, font=font15)
        #
        render_text("jF:", gp(2, 39), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[8:12])}", gpp(2, 39), screen, font=font15)
        #
        render_text("jnF:", gp(2, 40), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[12:16])}", gpp(2, 40), screen, font=font15)
        #
        render_text("jF X:", gp(2, 41), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[16:32])}", gpp(2, 41), screen, font=font15)
        #
        render_text("jnF X:", gp(2, 42), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[32:48])}", gpp(2, 42), screen, font=font15)
        #
        #
        render_text("ld X:", gp(3, 34), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x50:0x54])}", gpp(3, 34), screen, font=font15)
        #
        render_text("ld X,Y:", gp(3, 35), screen, font=font15,  centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x40:0x50])}", gpp(3, 35), screen, font=font15)
        #
        render_text("ldi X:", gp(3, 36), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x54:0x58])}", gpp(3, 36), screen, font=font15)
        #
        render_text("st X:", gp(3, 37), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0x30] + emu.opers_types_count[0x35] + emu.opers_types_count[0x3A] + emu.opers_types_count[0x3F]}", gpp(3, 37), screen, font=font15)
        #
        render_text("st X,Y:", gp(3, 38), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x31:0x35]) + sum(emu.opers_types_count[0x36:0x3A]) + sum(emu.opers_types_count[0x3B:0x40])}", gpp(3, 38), screen, font=font15)
        #
        #
        render_text("clr X:", gp(4, 34), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0xA0] + emu.opers_types_count[0xA5] + emu.opers_types_count[0xAA] + emu.opers_types_count[0xAF]}", gpp(4, 34), screen, font=font15)
        #
        render_text("neg X:", gp(4, 35), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0x90] + emu.opers_types_count[0x95] + emu.opers_types_count[0x9A] + emu.opers_types_count[0x9F]}", gpp(4, 35), screen, font=font15)
        #
        render_text("inc X:", gp(4, 36), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0x60] + emu.opers_types_count[0x65] + emu.opers_types_count[0x6A] + emu.opers_types_count[0x6F]}", gpp(4, 36), screen, font=font15)
        #
        render_text("dec X:", gp(4, 37), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0x70] + emu.opers_types_count[0x75] + emu.opers_types_count[0x7A] + emu.opers_types_count[0x7F]}", gpp(4, 37), screen, font=font15)
        #
        render_text("not X:", gp(4, 38), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0x80] + emu.opers_types_count[0x85] + emu.opers_types_count[0x8A] + emu.opers_types_count[0x8F]}", gpp(4, 38), screen, font=font15)
        #
        render_text("test X:", gp(4, 39), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0xB0] + emu.opers_types_count[0xB5] + emu.opers_types_count[0xBA] + emu.opers_types_count[0xBF]}", gpp(4, 39), screen, font=font15)
        #
        render_text("rnd X:", gp(4, 40), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xEC:0xF0])}", gpp(4, 40), screen, font=font15)
        #
        render_text("shl X:", gp(4, 41), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xE0:0xE4])}", gpp(4, 41), screen, font=font15)
        #
        render_text("shr X:", gp(4, 42), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xE4:0xF8])}", gpp(4, 42), screen, font=font15)
        #
        render_text("sar X:", gp(4, 43), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xE8:0xEC])}", gpp(4, 43), screen, font=font15)
        #
        render_text("rcl X:", gp(4, 44), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0xC0] + emu.opers_types_count[0xC5] + emu.opers_types_count[0xCA] + emu.opers_types_count[0xCF]}", gpp(4, 44), screen, font=font15)
        #
        render_text("rcr X:", gp(4, 45), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{emu.opers_types_count[0xD0] + emu.opers_types_count[0xD5] + emu.opers_types_count[0xDA] + emu.opers_types_count[0xDF]}", gpp(4, 45), screen, font=font15)
        #
        #
        render_text("mov X,Y:", gp(5, 34), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xA1:0xA5]) + sum(emu.opers_types_count[0xA6:0xAA]) + sum(emu.opers_types_count[0xAB:0xAF])}", gpp(5, 34), screen, font=font15)
        #
        render_text("and X,Y:", gp(5, 35), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xB1:0xB5]) + sum(emu.opers_types_count[0xB6:0xBA]) + sum(emu.opers_types_count[0xBB:0xBF])}", gpp(5, 35), screen, font=font15)
        #
        render_text("or X,Y:", gp(5, 36), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xC1:0xC5]) + sum(emu.opers_types_count[0xC6:0xCA]) + sum(emu.opers_types_count[0xCB:0xCF])}", gpp(5, 36), screen, font=font15)
        #
        render_text("xor X,Y:", gp(5, 37), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xD1:0xD5]) + sum(emu.opers_types_count[0xD6:0xDA]) + sum(emu.opers_types_count[0xDB:0xDF])}", gpp(5, 37), screen, font=font15)
        #
        render_text("add X,Y:", gp(5, 38), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x61:0x65]) + sum(emu.opers_types_count[0x66:0x6A]) + sum(emu.opers_types_count[0x6B:0x6F])}", gpp(5, 38), screen, font=font15)
        #
        render_text("adc X,Y:", gp(5, 39), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x81:0x85]) + sum(emu.opers_types_count[0x86:0x8A]) + sum(emu.opers_types_count[0x8B:0x8F])}", gpp(5, 39), screen, font=font15)
        #
        render_text("sub X,Y:", gp(5, 40), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x71:0x75]) + sum(emu.opers_types_count[0x76:0x7A]) + sum(emu.opers_types_count[0x7B:0x7F])}", gpp(5, 40), screen, font=font15)
        #
        render_text("sbb X,Y:", gp(5, 41), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0x91:0x95]) + sum(emu.opers_types_count[0x96:0x9A]) + sum(emu.opers_types_count[0x9B:0x9F])}", gpp(5, 41), screen, font=font15)
        #
        render_text("cmp X,Y:", gp(5, 42), screen, font=font15, centerx="right", color=(128, 128, 128))
        render_text(f"{sum(emu.opers_types_count[0xF1:0xF5]) + sum(emu.opers_types_count[0xF6:0xFA]) + sum(emu.opers_types_count[0xFB:0xFF])}", gpp(5, 42), screen, font=font15)
    steps += 1
    #
    pygame.display.update()
    timer.tick(1000)
pygame.quit()