from farmgui.image_factory import *
from farmgui.component import *
import pygame
pygame.init()

class RadioButton(Component):
    def __init__(self,
                 rect,
                 selected=0,
                 offset=3,
                 group=None,
                 text="", font=None, font_name=None, font_size=30, font_color=(0, 0, 0), font_alpha=True, center=(0.5, 0.5), x_offset=5,
                 **kwargs
                 ):
        Component.__init__(self, rect, **kwargs)
        self.offset = offset
        self.inactive_image = kwargs.get("inactive_image") if kwargs.get("inactive_image") != None else get_text_box_image(self.rect.w, self.rect.h, (80, 80, 80), ch=20)
        self.hover_image = kwargs.get("hover_image") if kwargs.get("hover_image") != None else get_text_box_image(self.rect.w, self.rect.h, (110, 110, 110), ch=20)
        #
        self.c_inactive_image = kwargs.get("c_inactive_image") if kwargs.get("c_inactive_image") != None else get_button_image(self.rect.w - offset*2, self.rect.h - offset*2, 0, (120, 120, 120))
        self.c_hover_image = kwargs.get("c_hover_image") if kwargs.get("c_hover_image") != None else get_button_image(self.rect.w - offset*2, self.rect.h - offset*2, 0, (140, 140, 140))
        self.image = self.inactive_image
        self.c_image = self.c_inactive_image
        self.onclick = kwargs.get("onclick")
        self.onclick_params = kwargs.get("onclick_params")
        self.onrelease = kwargs.get("onrelease")
        self.onrelease_params = kwargs.get("onrelease_params")
        self.selected = selected
        self.group = group
        if self.group != None: self.group.add(self)
        #
        self.text = text
        if font == None: font = pygame.font.SysFont(font_name, font_size)
        self.font = font
        self.font_color = font_color
        self.font_alpha = font_alpha
        self.update_text = None
        self.center = center
        self.x_offset = x_offset

    def update(self, events):
        mousedown = pygame.mouse.get_pressed()[0]
        mouse_collide = self.collide()
        if mouse_collide:
            if mousedown:
                if self.input_manager.mousetag_object[0] == None:
                    if str(type(self.onclick)) == "<class 'function'>":
                        if self.onclick_params != None:
                            self.onclick(*self.onclick_params)
                        else:
                            self.onclick()
            else:
                if self.input_manager.mousetag_object[0] == self:
                    if self.group == None:
                        self.selected = not self.selected
                    else:
                        for b in self.group.get_buttons():
                            b.set_selected(0)
                        self.selected = 1
                    if str(type(self.onrelease)) == "<class 'function'>":
                        if self.onrelease_params != None:
                            self.onrelease(*self.onrelease_params)
                        else:
                            self.onrelease()
                self.image = self.hover_image
                self.c_image = self.c_hover_image
        else:
            if not mousedown:
                self.image = self.inactive_image
                self.c_image = self.c_inactive_image

    def add_onclick(self, p):
        self.onclick = p

    def add_onclick_params(self, p):
        self.onclick_params = p

    def add_onrelease(self, p):
        self.onrelease = p

    def add_onrelease_params(self, p):
        self.onrelease_params = p

    def set_text(self, text):
        self.text = text

    def get_selected(self):
        return(bool(self.selected))

    def set_selected(self, num):
        self.selected = num

    def add_group(self, group):
        self.group = group
        group.buttons.append(self)

    def draw(self, screen):
        screen.blit(self.image, self.rect)
        if self.selected:
            screen.blit(self.c_image, (self.rect.x + self.offset, self.rect.y + self.offset))
        img = self.font.render(self.text, self.font_alpha, self.font_color)
        screen.blit(img, (self.rect.x + self.rect.w + self.x_offset, self.rect.y + self.rect.h * self.center[0] - img.get_height() * self.center[1]))
