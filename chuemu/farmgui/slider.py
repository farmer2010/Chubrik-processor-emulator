from farmgui.image_factory import *
from farmgui.component import *
import pygame
pygame.init()

class Slider(Component):
    def __init__(
            self,
            rect,
            c_rect,
            preset_value=0, min_value=0, max_value=100, period=0,
            offset=3,
            font=None, font_name=None, font_size=30, font_color=(0, 0, 0), font_alpha=True, font_center=(0.5, 0.5, 0.5, 0.5),
            vertical=False,
            **kwargs
        ):
        Component.__init__(self, rect, **kwargs)
        self.c_rect = c_rect
        self.value = preset_value
        self.min_value = min_value
        self.max_value = max_value
        self.offset = offset
        self.period = period
        self.vertical = vertical
        self.inactive_image = kwargs.get("inactive_image") if kwargs.get("inactive_image") != None else get_slider_image(self.rect.w, self.rect.h, (90, 90, 90))
        self.hover_image = kwargs.get("hover_image") if kwargs.get("hover_image") != None else get_slider_image(self.rect.w, self.rect.h, (120, 120, 120))
        self.image = self.inactive_image
        #
        self.c_inactive_image = kwargs.get("c_inactive_image") if kwargs.get("c_inactive_image") != None else get_button_image(self.c_rect[0], self.c_rect[1], 0, (50, 50, 50))
        self.c_hover_image = kwargs.get("c_hover_image") if kwargs.get("c_hover_image") != None else get_button_image(self.c_rect[0], self.c_rect[1], 0, (80, 80, 80))
        self.c_image = self.c_inactive_image
        #
        self.onclick = kwargs.get("onclick")
        self.onclick_params = kwargs.get("onclick_params")
        self.onchange = kwargs.get("onchange")
        self.onchange_params = kwargs.get("onchange_params")
        #
        self.update_text = None
        self.text = ""
        if font == None: font = pygame.font.SysFont(font_name, font_size)
        self.font = font
        self.font_color = font_color
        self.font_alpha = font_alpha
        self.update_text = None
        self.center = font_center
        self.last_value = self.value
        self.stx = 0

    def update(self, events):
        self.last_value = self.value
        mousedown = pygame.mouse.get_pressed()[0]
        mouse_collide = self.collide()
        if mouse_collide:
            if mousedown:
                if self.input_manager.mousetag_object[0] == None:
                    self.update_param_onclick()
                    #
                    if str(type(self.onclick)) == "<class 'function'>":
                        if self.onclick_params != None:
                            self.onclick(*self.onclick_params)
                        else:
                            self.onclick()
            else:
                self.image = self.hover_image
                self.c_image = self.c_hover_image
        else:
            if not mousedown:
                self.image = self.inactive_image
                self.c_image = self.c_inactive_image
        if self.input_manager.mousetag_object[0] == self and mousedown:
            self.update_param()
        if self.update_text != None: self.text = self.update_text(self.value)
        if self.last_value != self.value:
            if str(type(self.onchange)) == "<class 'function'>":
                if self.onchange_params != None:
                    self.onchange(*self.onchange_params)
                else:
                    self.onchange()

    def update_param(self):
        mousepos = self.get_mousepos()
        pos = (mousepos[0] - self.rect.x, mousepos[1] - self.rect.y)
        if not self.vertical:
            pos = (mousepos[0] - self.rect.x + (self.c_rect[0]/2 - self.stx), mousepos[1] - self.rect.y)
            if pos[0] >= self.offset + self.c_rect[0] / 2 and pos[0] < self.rect.w - self.offset - self.c_rect[0] / 2:
                self.value = self.min_value + (pos[0] - self.offset - self.c_rect[0] / 2) / (self.rect.w - self.offset * 2 - self.c_rect[0]) * (self.max_value - self.min_value)
            elif pos[0] < self.offset + self.c_rect[0] / 2:
                self.value = self.min_value
            elif pos[0] >= self.rect.w - self.offset * 2 - self.c_rect[0] / 2:
                self.value = self.max_value
        else:
            pos = (mousepos[0] - self.rect.x, mousepos[1] - self.rect.y + (self.c_rect[1] / 2 - self.stx))
            if pos[1] >= self.offset + self.c_rect[1] / 2 and pos[1] < self.rect.h - self.offset - self.c_rect[1] / 2:
                self.value = self.min_value + (pos[1] - self.offset - self.c_rect[1] / 2) / (self.rect.h - self.offset * 2 - self.c_rect[1]) * (self.max_value - self.min_value)
            elif pos[1] < self.offset + self.c_rect[1] / 2:
                self.value = self.min_value
            elif pos[1] >= self.rect.h - self.offset * 2 - self.c_rect[1] / 2:
                self.value = self.max_value
        self.value = round(self.value, self.period)

    def update_param_onclick(self):
        mousepos = self.get_mousepos()
        pos = (mousepos[0] - self.rect.x, mousepos[1] - self.rect.y)
        if not self.vertical:
            cx = (self.rect.w - self.offset * 2 - self.c_rect[0]) * (self.value / (self.max_value - self.min_value))
            mx = mousepos[0] - self.rect.x - self.offset
            if not (pos[0] - self.offset - cx > 0 and pos[0] - self.offset - cx < self.c_rect[0]):
                self.stx = self.c_rect[0] / 2
                #
                pos = (mousepos[0] - self.rect.x - self.stx / 2, mousepos[1] - self.rect.y)
                if pos[0] >= self.offset + self.c_rect[0] / 2 and pos[0] < self.rect.w - self.offset - self.c_rect[0] / 2:
                    self.value = self.min_value + (pos[0] - self.offset - self.c_rect[0] / 2) / (self.rect.w - self.offset * 2 - self.c_rect[0]) * (self.max_value - self.min_value)
                elif pos[0] < self.offset + self.c_rect[0] / 2:
                    self.value = self.min_value
                elif pos[0] >= self.rect.w - self.offset * 2 - self.c_rect[0] / 2:
                    self.value = self.max_value
            else:
                self.stx = mx - cx
        else:
            cy = (self.rect.h - self.offset * 2 - self.c_rect[1]) * (self.value / (self.max_value - self.min_value))
            my = mousepos[1] - self.rect.y - self.offset
            if not (pos[1] - self.offset - cy > 0 and pos[1] - self.offset - cy < self.c_rect[1]):
                self.stx = self.c_rect[1] / 2
                #
                pos = (mousepos[0] - self.rect.x, mousepos[1] - self.rect.y - self.stx / 2)
                if pos[1] >= self.offset + self.c_rect[1] / 2 and pos[1] < self.rect.h - self.offset - self.c_rect[1] / 2:
                    self.value = self.min_value + (pos[1] - self.offset - self.c_rect[1] / 2) / (self.rect.h - self.offset * 2 - self.c_rect[1]) * (self.max_value - self.min_value)
                elif pos[1] < self.offset + self.c_rect[1] / 2:
                    self.value = self.min_value
                elif pos[1] >= self.rect.h - self.offset * 2 - self.c_rect[1] / 2:
                    self.value = self.max_value
            else:
                self.stx = my - cy
        self.value = round(self.value, self.period)

    def draw(self, screen):
        screen.blit(self.image, self.rect)
        if not self.vertical:
            x = (self.rect.w - self.offset * 2 - self.c_rect[0]) * (self.value / (self.max_value - self.min_value))
            screen.blit(self.c_image, (self.rect.x + self.offset + x, (self.rect.y + self.rect.h / 2) - (self.c_rect[1] / 2)))
            img = self.font.render(self.text, self.font_alpha, self.font_color)
            screen.blit(img, (self.rect.x + self.rect.w * self.center[0] - img.get_width() * self.center[2], self.rect.y + self.rect.h * self.center[1] - img.get_height() * self.center[3]))
        else:
            y = (self.rect.h - self.offset * 2 - self.c_rect[1]) * (self.value / (self.max_value - self.min_value))
            screen.blit(self.c_image, ((self.rect.x + self.rect.w / 2) - (self.c_rect[0] / 2), self.rect.y + self.offset + y))
            img = self.font.render(self.text, self.font_alpha, self.font_color)
            screen.blit(img, (self.rect.x + self.rect.w * self.center[0] - img.get_width() * self.center[2], self.rect.y + self.rect.h * self.center[1] - img.get_height() * self.center[3]))

    def add_onclick(self, p):
        self.onclick = p

    def add_onclick_params(self, p):
        self.onclick_params = p

    def add_onchange(self, p):
        self.onchange = p

    def add_onchange_params(self, p):
        self.onchange_params = p

    def set_text(self, text):
        self.text = text

    def add_update_text(self, upd):
        self.update_text = upd

    def get_value(self):
        return(self.value)

    def set_value(self, value):
        self.value = value
