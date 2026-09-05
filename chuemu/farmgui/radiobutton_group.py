class RadioButtonGroup():
    def __init__(self):
        self.buttons = []

    def add(self, b):
        self.buttons.append(b)

    def remove(self, b):
        self.buttons.remove(b)
        b.group = None

    def get_selected_button_index(self):
        for i in range(len(self.buttons)):
            if self.buttons[i].get_selected:
                return(i)

    def get_button(self, index):
        return(self.buttons[index])

    def get_buttons(self):
        return(self.buttons)