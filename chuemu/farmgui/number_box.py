from farmgui.panel import *
from farmgui.text_box import *
from farmgui.button import *

def up(comp, num, min_value, max_value, self):
    self.buttons[1].timer = 0
    try:
        n = min(max(int(comp.get_text()) + num, min_value), max_value)
    except:
        n = min(max(round(float(comp.get_text()) + num, self.period), min_value), max_value)
    comp.set_text(str(n))

def down(comp, num, min_value, max_value, self):
    self.buttons[2].timer = 0
    try:
        n = min(max(int(comp.get_text()) - num, min_value), max_value)
    except:
        n = min(max(round(float(comp.get_text()) - num, self.period), min_value), max_value)
    comp.set_text(str(n))

def up_scroll(self):
    timer = self.buttons[1].timer
    self.buttons[1].timer += 1
    if (timer > 30 and timer <= 130 and (timer - 30) % 10 == 0) or \
            (timer > 130 and timer <= 230 and (timer - 130) % 7 == 0) or \
            (timer > 230 and (timer - 230) % 5 == 0):
        try:
            n = min(max(int(self.buttons[0].get_text()) + self.change_value, self.min_value), self.max_value)
        except:
            n = min(max(round(float(self.buttons[0].get_text()) + self.change_value, self.period), self.min_value), self.max_value)
        self.buttons[0].set_text(str(n))

def down_scroll(self):
    timer = self.buttons[2].timer
    self.buttons[2].timer += 1
    if (timer > 30 and timer <= 130 and (timer - 30) % 10 == 0) or \
            (timer > 130 and timer <= 230 and (timer - 130) % 7 == 0) or \
            (timer > 230 and (timer - 230) % 5 == 0):
        try:
            n = min(max(int(self.buttons[0].get_text()) - self.change_value, self.min_value), self.max_value)
        except:
            n = min(max(round(float(self.buttons[0].get_text()) - self.change_value, self.period), self.min_value), self.max_value)
        self.buttons[0].set_text(str(n))

def text_to_number(self):
    text = self.buttons[0].get_text()
    t = ""
    try:
        if int(text) >= self.min_value and int(text) <= self.max_value:
            t = str(int(text))
        else:
            t = str(self.preset_value)
    except:
        try:
            if float(text) >= self.min_value and float(text) <= self.max_value:
                t = str(float(text))
            else:
                t = str(self.preset_value)
        except:
            t = str(self.preset_value)
    self.buttons[0].set_text(t)

class NumberBox(Panel):
    def __init__(self, rect, preset_value=0, min_value=0, max_value=100, change_value=1, period=1, **kwargs):
        Panel.__init__(self, rect, **kwargs)
        self.preset_value = preset_value
        self.min_value = min_value
        self.max_value = max_value
        self.change_value = change_value
        self.period = period
        #
        textbox = TextBox((0, 0, self.rect.w - self.rect.h / 2, self.rect.h), text=str(preset_value), font_size=16, text_x=5, onsubmit=text_to_number, onsubmit_params=[self])
        textbox.add_enabled_symbols(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-"])
        self.add(textbox)
        #
        button1 = Button((self.rect.w - self.rect.h / 2, 0, self.rect.h / 2, self.rect.h / 2))
        button1.timer = 0
        button1.add_onrelease(up)
        button1.add_onrelease_params((self.buttons[0], change_value, min_value, max_value, self))
        button1.add_onpressed(up_scroll)
        button1.add_onpressed_params([self])
        self.add(button1)
        #
        button2 = Button((self.rect.w - self.rect.h / 2, self.rect.h / 2, self.rect.h / 2, self.rect.h / 2))
        button2.timer = 0
        button2.add_onrelease(down)
        button2.add_onrelease_params((self.buttons[0], change_value, min_value, max_value, self))
        button2.add_onpressed(down_scroll)
        button2.add_onpressed_params([self])
        self.add(button2)

    def get_value(self):
        if self.period == 1:
            return(int(float(self.buttons[0].get_text())))
        else:
            return(round(float(self.buttons[0].get_text()), self.period))

    def set_value(self, value):
        self.buttons[0].set_text(str(value))