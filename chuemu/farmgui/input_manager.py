import pygame
pygame.init()

class InputManager():
    def __init__(self):
        self.mousetag = [0, 0, 0]
        self.mouse = [0, 0, 0]
        self.mousetag_object = [None, None, None]#объект, привязанный к курсору
        self.mouse_connect_object = [None, None, None]#активный объект(для ввода)
        #
        self.keys_tag = {"A" : 0, "B" : 0, "C" : 0, "D" : 0, "E" : 0, "F" : 0, "G" : 0, "H" : 0, "I" : 0, "J" : 0,
            "K": 0, "L" : 0, "M" : 0, "N" : 0, "O" : 0, "P" : 0, "Q" : 0, "R" : 0, "S" : 0, "T" : 0, "U" : 0, "V" : 0,
            "W": 0, "X" : 0, "Y" : 0, "Z" : 0,
            "F1": 0,"F2" : 0, "F3" : 0, "F4" : 0, "F5" : 0, "F6" : 0, "F7" : 0, "F8" : 0, "F9" : 0, "F10" : 0, "F11" : 0, "F12" : 0,
            "ESC" : 0
        }
        self.keys = {"A" : 0, "B" : 0, "C" : 0, "D" : 0, "E" : 0, "F" : 0, "G" : 0, "H" : 0, "I" : 0, "J" : 0,
            "K": 0, "L" : 0, "M" : 0, "N" : 0, "O" : 0, "P" : 0, "Q" : 0, "R" : 0, "S" : 0, "T" : 0, "U" : 0, "V" : 0,
            "W": 0, "X" : 0, "Y" : 0, "Z" : 0,
            "F1": 0,"F2" : 0, "F3" : 0, "F4" : 0, "F5" : 0, "F6" : 0, "F7" : 0, "F8" : 0, "F9" : 0, "F10" : 0, "F11" : 0, "F12" : 0,
            "ESC" : 0
        }
        self.keys_ind = {
            "A" : pygame.K_a, "B" : pygame.K_b, "C" : pygame.K_c, "D" : pygame.K_d, "E" : pygame.K_e,
            "F" : pygame.K_f, "G" : pygame.K_g, "H" : pygame.K_h, "I" : pygame.K_i, "J" : pygame.K_j, "K": pygame.K_k,
            "L" : pygame.K_l, "M" : pygame.K_m, "N" : pygame.K_n, "O" : pygame.K_o, "P" : pygame.K_p, "Q" : pygame.K_q,
            "R" : pygame.K_r, "S" : pygame.K_s, "T" : pygame.K_t, "U" : pygame.K_u, "V" : pygame.K_v, "W": pygame.K_w,
            "X" : pygame.K_x, "Y" : pygame.K_y, "Z" : pygame.K_z,
            "F1": pygame.K_F1, "F2" : pygame.K_F2, "F3" : pygame.K_F3, "F4" : pygame.K_F4, "F5" : pygame.K_F5,
            "F6" : pygame.K_F6, "F7" : pygame.K_F7, "F8" : pygame.K_F8, "F9" : pygame.K_F9, "F10" : pygame.K_F10,
            "F11" : pygame.K_F11, "F12" : pygame.K_F11,
            "ESC" : pygame.K_ESCAPE
        }
        self.mousewheel = 0

    def update(self, events):
        self.mousewheel = 0
        for event in events:
            if event.type == pygame.MOUSEWHEEL:
                self.mousewheel = event.y
        #
        keys = pygame.key.get_pressed()
        for key in self.keys:
            self.keys[key] = 0
            if keys[self.keys_ind[key]]:
                if self.keys_tag[key] == 0:
                    self.keys_tag[key] = 1
                    self.keys[key] = 1
            else:
                self.keys_tag[key] = 0
        #
        for i in range(3):
            self.mouse[i] = 0
            if pygame.mouse.get_pressed()[i]:
                if self.mousetag_object[i] == None:
                    self.mouse[i] = 1

    def get_mousewheel(self):
        return(self.mousewheel)

    def get_key(self, key):
        return(self.keys[key])

    def get_mouse(self, ind):
        return(self.mouse[ind])

input_manager = InputManager()