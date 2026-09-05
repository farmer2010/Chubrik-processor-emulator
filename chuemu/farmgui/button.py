from farmgui.image_factory import *
from farmgui.component import *
import pygame
pygame.init()

class Button(Component):
    def __init__(self,
                 rect,
                 text="",
                 font=None,
                 font_name=None,
                 font_size=30,
                 font_color=(0, 0, 0),
                 font_alpha=True,
                 font_center=(0.5, 0.5, 0.5, 0.5),
                 **kwargs):
        Component.__init__(self, rect, **kwargs)
        self.inactive_image = kwargs.get("inactive_image") if kwargs.get("inactive_image") != None else get_button_image(self.rect.w, self.rect.h, 0, (90, 90, 90))#90
        self.pressed_image = kwargs.get("pressed_image") if kwargs.get("pressed_image") != None else get_button_image(self.rect.w, self.rect.h, 1, (90, 90, 90))#50
        self.hover_image = kwargs.get("hover_image") if kwargs.get("hover_image") != None else get_button_image(self.rect.w, self.rect.h, 0, (120, 120, 120))#120
        self.image = self.inactive_image
        self.onclick = kwargs.get("onclick")
        self.onclick_params = kwargs.get("onclick_params")
        self.onrelease = kwargs.get("onrelease")
        self.onrelease_params = kwargs.get("onrelease_params")
        self.onpressed = kwargs.get("onpressed")
        self.onpressed_params = kwargs.get("onpressed_params")
        #
        self.text = text
        if font == None: font = pygame.font.SysFont(font_name, font_size)
        self.font = font
        self.font_color = font_color
        self.font_alpha = font_alpha
        self.update_text = None
        self.center = font_center

    def update(self, events):
        mousedown = pygame.mouse.get_pressed()[0]
        mouse_collide = self.collide()
        if mouse_collide:
            if mousedown:
                if self.input_manager.mousetag_object[0] == None:
                    self.image = self.pressed_image
                    if str(type(self.onclick)) == "<class 'function'>":
                        if self.onclick_params != None:
                            self.onclick(*self.onclick_params)
                        else:
                            self.onclick()
            else:
                if self.input_manager.mousetag_object[0] == self:
                    if str(type(self.onrelease)) == "<class 'function'>":
                        if self.onrelease_params != None:
                            self.onrelease(*self.onrelease_params)
                        else:
                            self.onrelease()
                self.image = self.hover_image
        else:
            if self.input_manager.mousetag_object[0] == self:
                self.image = self.pressed_image
            if not mousedown:
                self.image = self.inactive_image
        #
        if self.input_manager.mousetag_object[0] == self:#only onpressed
            if str(type(self.onpressed)) == "<class 'function'>":
                if self.onpressed_params != None:
                    self.onpressed(*self.onpressed_params)
                else:
                    self.onpressed()

    def add_onrelease(self, p):
        self.onrelease = p

    def add_onrelease_params(self, p):
        self.onrelease_params = p

    def add_onclick(self, p):
        self.onclick = p

    def add_onclick_params(self, p):
        self.onclick_params = p

    def add_onpressed(self, p):
        self.onpressed = p

    def add_onpressed_params(self, p):
        self.onpressed_params = p

    def set_text(self, text):
        self.text = text

    def draw(self, screen):
        screen.blit(self.image, self.rect)
        img = self.font.render(self.text, self.font_alpha, self.font_color)
        screen.blit(img, (self.rect.x + self.rect.w * self.center[0] - img.get_width() * self.center[2], self.rect.y + self.rect.h * self.center[1] - img.get_height() * self.center[3]))