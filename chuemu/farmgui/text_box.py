from farmgui.image_factory import *
from farmgui.utils import *
from farmgui.component import *
import pygame
pygame.init()

class TextBox(Component):
    def __init__(self, rect,
                 text="",
                 font=None,
                 font_name="times new roman",
                 font_size=30,
                 font_color=(0, 0, 0),
                 text_x=10,
                 enabled_symbols=None,
                 disabled_symbols=[],
                 **kwargs
                 ):
        Component.__init__(self, rect, **kwargs)
        self.text = text
        self.inactive_image = kwargs.get("inactive_image") if kwargs.get("inactive_image") != None else get_text_box_image(self.rect.w, self.rect.h, (90, 90, 90))
        self.hover_image = kwargs.get("hover_image") if kwargs.get("hover_image") != None else get_text_box_image(self.rect.w, self.rect.h, (120, 120, 120))
        self.image = self.inactive_image
        self.mouselast = 0
        #
        self.text_x = text_x
        if font == None: font = pygame.font.SysFont(font_name, font_size)
        self.font = font
        self.font_color = font_color
        #
        self.enabled_symbols = enabled_symbols
        self.disabled_symbols = disabled_symbols
        #
        self.onclick = kwargs.get("onclick")
        self.onclick_params = kwargs.get("onclick_params")
        self.onchange = kwargs.get("onchange")
        self.onchange_params = kwargs.get("onchange_params")
        self.onsubmit = kwargs.get("onsubmit")
        self.onsubmit_params = kwargs.get("onsubmit_params")
        self.timer = 0
        self.cursor_pos = 0

    def update(self, events):
        self.timer += 1
        self.timer %= 60
        mousedown = pygame.mouse.get_pressed()[0]
        mousepos = self.get_mousepos()
        mouse_collide = self.collide()
        last_text = self.text
        if mouse_collide:
            if mousedown:
                if self.input_manager.mousetag_object[0] == None:
                    if str(type(self.onclick)) == "<class 'function'>":
                        if self.onclick_params != None:
                            self.onclick(*self.onclick_params)
                        else:
                            self.onclick()
                    #
                    mp = [mousepos[0] - self.rect.x, mousepos[1] - self.rect.y]
                    if mp[0] < self.text_x:
                        self.cursor_pos = 0
                    elif mp[0] > self.font.render(self.text, 1, self.font_color).get_width() + self.text_x:
                        self.cursor_pos = len(self.text)
                    else:
                        for i in range(len(self.text)):
                            w1 = self.font.render(self.text[:i + 1], 1, self.font_color).get_width()
                            w0 = self.font.render(self.text[:i], 1, self.font_color).get_width()
                            if mp[0] < self.text_x + w1:
                                if mp[0] < self.text_x + w0 + (w1 - w0) / 2:
                                    self.cursor_pos = i
                                else:
                                    self.cursor_pos = i + 1
                                break
            else:
                self.image = self.hover_image
                if self.mouselast and self.input_manager.mousetag_object[0] == self:
                    self.input_manager.mouse_connect_object[0] = self
            self.mouselast = mousedown
        else:
            if self.input_manager.mousetag_object[0] == self:
                self.input_manager.mouse_connect_object[0] = self
            if not mousedown:
                self.image = self.inactive_image
            if mousedown and self.input_manager.mouse_connect_object[0] == self:
                self.input_manager.mouse_connect_object[0] = None
                if str(type(self.onsubmit)) == "<class 'function'>":
                    if self.onsubmit_params != None:
                        self.onsubmit(*self.onsubmit_params)
                    else:
                        self.onsubmit()
        if self.input_manager.mouse_connect_object[0] == self:
            for event in events:
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_LEFT and self.cursor_pos >= 1:
                        self.cursor_pos -= 1
                    if event.key == pygame.K_RIGHT and self.cursor_pos < len(self.text):
                        self.cursor_pos += 1
                    if event.key == pygame.K_BACKSPACE and self.cursor_pos > 0:
                        self.text = self.text[:self.cursor_pos - 1] + self.text[self.cursor_pos:]
                        self.cursor_pos -= 1
                    elif event.unicode != "" and event.key != pygame.K_ESCAPE and event.key != pygame.K_TAB and event.key != pygame.K_DELETE and event.key != pygame.K_BACKSPACE and event.key != pygame.K_RETURN and event.key != pygame.K_KP_ENTER:
                        if (self.enabled_symbols == None or event.unicode in self.enabled_symbols) and not (event.unicode in self.disabled_symbols):
                            text_img = self.font.render(self.text + event.unicode, True, self.font_color)
                            if text_img.get_width() < self.rect.w - self.text_x * 2:
                                self.text = self.text[:self.cursor_pos] + event.unicode + self.text[self.cursor_pos:]
                                self.cursor_pos += 1
        if last_text != self.text:
            if str(type(self.onchange)) == "<class 'function'>":
                if self.onchange_params != None:
                    self.onchange(*self.onchange_params)
                else:
                    self.onchange()

    def draw(self, screen):
        screen.blit(self.image, self.rect)
        render_text(self.text, (self.rect.x + self.text_x, self.rect.y + self.rect.h / 2), screen, centery="center", font=self.font, color=self.font_color)
        if self.timer < 30 and self.input_manager.mouse_connect_object[0] == self:
            text_img = self.font.render(self.text[:self.cursor_pos], True, self.font_color)
            pygame.draw.rect(screen, self.font_color, (self.rect.x + self.text_x + text_img.get_width(), self.rect.y + self.rect.h / 2 - text_img.get_height() / 2, 2, text_img.get_height()))

    def add_enabled_symbols(self, e):
        self.enabled_symbols = e

    def add_disabled_symbols(self, d):
        self.disabled_symbols = d

    def add_onclick(self, p):
        self.onclick = p

    def add_onclick_params(self, p):
        self.onclick_params = p

    def add_onchange(self, p):
        self.onchange = p

    def add_onchange_params(self, p):
        self.onchange_params = p

    def add_onsubmit(self, p):
        self.onsubmit = p

    def add_onsubmit_params(self, p):
        self.onsubmit_params = p

    def get_text(self):
        return(self.text)

    def set_text(self, text):
        self.text = text