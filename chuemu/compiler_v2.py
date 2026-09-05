spaces = [" ", "\n", "\t", chr(65279)]
symb = [",", ":", "-", "+", "$", "'", '"', "<", ">", "<=", ">=", "==", "!="]
labels = ["db", "equ"]
words = [".bank", "IF", "ELSE", "WHILE", "END", "set"]
all_commands = ["nop", "hlt", "ssp", "ld", "ldi", "st", "jmp", "jz", "js", "jc", "jo", "jnz", "jns", "jnc", "jno", "clr", "mov", "and", "or", "xor", "add", "adc", "sub", "sbb", "test", "inc", "dec", "not", "neg", "rnd", "shl", "shr", "sar", "rcl", "rcr"]
cmd1 = {"inc" : 0x60, "dec" : 0x70, "not" : 0x80, "neg" : 0x90, "clr" : 0xA0, "test" : 0xB0, "rcl" : 0xC0, "rcr" : 0xD0}
cmd2 = {"add" : 0x60, "sub" : 0x70, "adc" : 0x80, "sbb" : 0x90, "mov" : 0xA0, "and" : 0xB0, "or" : 0xC0, "xor" : 0xD0}

numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
fr = ["a", "b", "c", "d", "z", "s", "o"]
registers = ["a", "b", "c", "d"]
reg_to_num = {"a" : 0, "b" : 1, "c" : 2, "d" : 3}

syntax_notation = {
    "nop" : {
        "length" : 0,#количество параметров
        "index" : 0,#индекс токена команды в строке
        "param type" : ""#тип параметра
    },
    "hlt" : {
        "length" : 0,
        "index" : 0,
        "param type" : "register"
    },
    "clr" : {
        "length" : 1,
        "index" : 0,
        "param type" : "register"
    },
}

class Token():
    def __init__(self, txt, line_ind=0, symb_ind=0):
        self.text = txt
        self.line_ind = line_ind
        self.symb_ind = symb_ind
        if txt[0] in numbers:
            self.type = "number"
        elif txt[0] == "#":
            self.type = "tag"
        elif txt in symb:
            self.type = "special symbol"
        elif txt in labels:
            self.type = "label"
        elif txt in words:
            self.type = "word"
        elif txt[0] == "'" or txt[0] == '"':
            self.type = "string"
        elif txt in all_commands:
            self.type = "command"
        elif txt in fr:
            self.type = "register/flag"
        elif txt == "__end__":
            self.type = "end line"
        elif txt == "__end_code__":
            self.type = "end code"
        elif txt == "__set__":
            self.type = "set"
        else:
            self.type = "unknown"

    def __eq__(self, other):
        return(self.text == other)

    def __str__(self):
        return(self.text)

    def __repr__(self):
        return("'" + self.text + "'")

def numbergen(tokens):
    if len(tokens) == 1:
        return(Token(str(eval(tokens[0].text))))
    elif len(tokens) == 3:
        number1 = eval(tokens[0].text)
        number2 = eval(tokens[2].text)
        out = 0
        if tokens[1] == "+":
            out = (number1 + number2) % 256
        elif tokens[1] == "-":
            out = (number1 - number2) % 256
        return(Token(str(out)))
    return(None)

def get_error(err_code, line_ind, pos, line, token=Token(" "), token2=Token(" ")):
    res = f"Syntax error (code {err_code}) on line {line_ind}:\n"
    res += line + "\n"
    res += " " * pos + "^\n"
    if err_code == 0:
        res += f"Uncnown command: {token}"
    elif err_code == 1:
        res += f"Incorrect label name: {token}"
    elif err_code == 2:
        res += "Expected label name"
    res += "\n\n"
    return(res)

def compile_v2(code):
    #
    console = ""
    #
    #ТОКЕНАЙЗЕР
    #
    lines_level1 = []
    buffer = ""
    line = []
    txt = None
    token_type = None
    comment = 0
    tag = 0
    line_ind = 0
    pos = 0
    curpos = 0
    db = 0
    double_block = 0
    for i in range(len(code)):
        symbol = code[i]
        next_symbol = code[i + 1] if i < len(code) - 1 else ""
        #
        pos += 1
        if symbol == "\n":
            line_ind += 1
            pos = 0
            tag = 0
        #
        if symbol == "#":
            tag = 1
        #
        if (symbol == "'" or symbol == '"') and not comment and not tag:
            if txt == None:
                txt = symbol
            elif txt == symbol:
                txt = None
        #
        if symbol == ";":
            comment = 1
        if comment and symbol == "\n":
            comment = 0
        #
        if token_type == None:
            curpos = pos - 1
            if symbol == "'" or symbol == '"':
                token_type = "string"
            elif symbol in numbers:
                token_type = "number"
            elif symbol in symb and (symbol != "'" or symbol != '"'):
                token_type = "special symbol"
            elif symbol == "#":
                token_type = "tag"
            elif not symbol in spaces:
                token_type = "word"
        #
        if not comment and (
                (token_type == "string" and symbol != "\n") or
                (token_type == "tag" and symbol != "\n") or
                (not symbol in spaces and (
                    (token_type == "word" and not symbol in symb) or
                    (token_type == "special symbol" and symbol in symb) or
                    (token_type == "number")
        ))):
            if token_type == "string" and symbol == "\\":
                if next_symbol == "a":
                    buffer += "\a"
                elif next_symbol == "b":
                    buffer += "\b"
                elif next_symbol == "t":
                    buffer += "\t"
                elif next_symbol == "n":
                    buffer += "\n"
                elif next_symbol == "v":
                    buffer += "\v"
                elif next_symbol == "f":
                    buffer += "\f"
                elif next_symbol == "r":
                    buffer += "\r"
                double_block = 1
            elif not double_block:
                buffer += symbol
            #
            if token_type == "string" and double_block and symbol != "\\":
                double_block = 0
        #
        if (token_type == "word" and (next_symbol in spaces or next_symbol in symb)) or \
                (token_type == "special symbol" and not buffer + next_symbol in symb) or \
                ((token_type == "string" and (symbol == "'" or symbol == '"') and txt == None) or next_symbol == "\n") or \
                (token_type == "number" and (next_symbol in spaces or next_symbol in symb)) or \
                (token_type == "tag" and next_symbol == "\n") or \
                i == len(code) - 1:
            token_type = None
            if buffer != "":
                if buffer == "db":
                    db = 1
                elif db and len(line) > 0 and line[-1] != "," and line[-1] != "db" and buffer != ",":
                    if buffer != "-" and buffer != "+":
                        line = []
                        lines_level1.append(Token("__end__", line_ind, curpos))
                    db = 0
                lines_level1.append(Token(buffer, line_ind, curpos))
                line.append(Token(buffer))
                buffer = ""
        if len(line) > 0 and (symbol == "\n" and db == 0 or line[-1] == ":"):
            line = []
            lines_level1.append(Token("__end__", line_ind, curpos))
    #
    #ПРОВЕРКА СИНТАКСИСА
    #
    line_ind = 0
    for i in range(len(lines_level1)):
        token = lines_level1[i]
        next_token = lines_level1[i + 1] if i < len(lines_level1) - 1 else Token("__end_code__")
        #
        if token.type == "unknown" and next_token not in labels and next_token != ":" and line_ind == 0:
            console = get_error(0, token.line_ind, token.symb_ind, code.split("\n")[token.line_ind], token=token)
            return([], console)
        if next_token == ":" and token.type != "unknown" and token.type != "end line":
            console = get_error(1, token.line_ind, token.symb_ind, code.split("\n")[token.line_ind], token=token)
            return ([], console)
        if token.type == "end line" and next_token == ":":
            console = get_error(2, next_token.line_ind, next_token.symb_ind, code.split("\n")[next_token.line_ind])
            return ([], console)
        if token.type != "unknown" and next_token in labels:
            console = get_error(2, next_token.line_ind, next_token.symb_ind, code.split("\n")[next_token.line_ind])
            return ([], console)
        #
        if token.type != "end line":
            line_ind += 1
        else:
            line_ind = 0
    #
    #ОБЪЕДИНЕНИЕ ТОКЕНОВ В КОМАНДЫ
    #
    lines_level2 = []
    line = []
    for i in range(len(lines_level1)):
        token = lines_level1[i]
        if token.type != "end line":
            line.append(token)
        if token.type == "end line" or i == len(lines_level1) - 1:
            lines_level2.append(line)
            line = []
    #
    #РАЗДЕЛЕНИЕ ELSE - IF
    #
    i = 0
    while i < len(lines_level2):
        line = lines_level2[i]
        if len(line) >= 2:
            if line[0] == "ELSE" and line[1] == "IF":
                lines_level2.insert(i, [Token("ELSE")])
                lines_level2[i + 1] = line[1:]
                if lines_level2[i - 1][0].type == "tag":
                    lines_level2[i - 1], lines_level2[i] = lines_level2[i], lines_level2[i - 1]
                i += 1
                #
                j = i
                bra_count = 0
                while j < len(lines_level2):
                    if lines_level2[j][0] == "IF":
                        bra_count += 1
                    if lines_level2[j][0] == "END":
                        bra_count -= 1
                    #
                    if lines_level2[j][0] == "END" and bra_count == 0:
                        lines_level2.insert(j, [Token("END")])
                        break
                    #
                    j += 1
        i += 1
    #
    #ОБРАБОТКА IF
    #
    i = 0
    ind = 0
    while i < len(lines_level2):
        if lines_level2[i][0] == "IF":
            endif_pos = i
            bra_count = 0
            while endif_pos < len(lines_level2):#определение позиции конца if
                if lines_level2[endif_pos][0] == "IF" or lines_level2[endif_pos][0] == "WHILE":
                    bra_count += 1
                if lines_level2[endif_pos][0] == "END":
                    bra_count -= 1
                if bra_count == 0 or (bra_count == 1 and lines_level2[endif_pos][0] == "ELSE"):
                    break
                #
                endif_pos += 1
            #
            if endif_pos < len(lines_level2) and lines_level2[endif_pos][0] == "ELSE":#if-else
                endelse_pos = endif_pos + 1
                bra_count = 1
                while endelse_pos < len(lines_level2):#определение позиции конца else
                    if lines_level2[endelse_pos][0] == "IF" or lines_level2[endelse_pos][0] == "WHILE":
                        bra_count += 1
                    if lines_level2[endelse_pos][0] == "END":
                        bra_count -= 1
                    if bra_count == 0 and lines_level2[endelse_pos][0] == "END":
                        break
                    #
                    endelse_pos += 1
                #
                lines_level2[endelse_pos] = [Token(f"__if_label_{ind}__"), Token(":")]
                #
                lines_level2[endif_pos] = [Token("jmp"), Token(f"__if_label_{ind}__")]
                ind += 1
                lines_level2.insert(endif_pos + 1, [Token(f"__if_label_{ind}__"), Token(":")])
                #
                lines_level2.insert(i, [Token("__set__")] + lines_level2[i][1:])
                lines_level2[i + 1] = [Token("jmp"), Token(f"__if_label_{ind}__")]
                ind += 1
            else:#if
                lines_level2[endif_pos] = [Token(f"__if_label_{ind}__"), Token(":")]
                lines_level2.insert(i, [Token("__set__")] + lines_level2[i][1:])
                lines_level2[i + 1] = [Token("jmp"), Token(f"__if_label_{ind}__")]
                ind += 1
        i += 1

    #
    #ОБРАБОТКА УСЛОВИЙ
    #
    i = 0
    while i < len(lines_level2):
        if lines_level2[i][0] == "__set__":
            op = ""
            param = [[], []]
            regs = [0, 0]
            reg_index = 0
            num = 0
            for j in range(len(lines_level2[i])):
                if lines_level2[i][j].type == "number" or lines_level2[i][j].type == "string" or lines_level2[i][j].type == "unknown" or lines_level2[i][j] == "$" or lines_level2[i][j] == "@":
                    num = 1
                if lines_level2[i][j] in ["==", "!=", ">", "<", ">=", "<="]:
                    op = lines_level2[i][j]
                    num = 0
                    reg_index += 1
                if lines_level2[i][j] in registers:
                    regs[reg_index] = lines_level2[i][j]
                if num:
                    param[reg_index].append(lines_level2[i][j])
            #
            key = []
            if i != 0 and lines_level2[i - 1][0].type == "tag":
                key = lines_level2[i - 1][0].text[1:].split(" ")
            #
            if param != [[], []]:
                reg = ""
                if "-a" in key:
                    reg = "a"
                elif "-b" in key:
                    reg = "b"
                elif "-c" in key:
                    reg = "c"
                elif "-d" in key:
                    reg = "d"
                p = []
                if len(param[0]) != 0:
                    p = param[0]
                    regs[0] = Token(reg)
                elif len(param[1]) != 0:
                    p = param[1]
                    regs[1] = Token(reg)
                lines_level2[i - 1] = [Token("ldi"), Token(reg), Token(",")] + p
            #
            if "-sub0" in key:
                regs[0], regs[1] = regs[1], regs[0]
            #
            lines_level2[i] = [Token("sub"), regs[1], Token(","), regs[0]]
            #
            if op == "==":
                lines_level2[i + 1][0] = Token("jnz")
            elif op == "!=":
                lines_level2[i + 1][0] = Token("jz")
            elif op == ">":
                lines_level2[i + 1][0] = Token("jz")
                lines_level2.insert(i + 1, [Token("jnc"), lines_level2[i + 1][1]])
            elif op == "<":
                lines_level2[i + 1][0] = Token("jz")
                lines_level2.insert(i + 1, [Token("jc"), lines_level2[i + 1][1]])
            elif op == ">=":
                lines_level2[i + 1][0] = Token("jnc")
            elif op == "<=":
                lines_level2[i + 1][0] = Token("jc")
        i += 1
    #
    #ОБРАБОТКА СТРОК В DB
    #
    for i in range(len(lines_level2)):
        line = lines_level2[i]
        if len(line) > 2 and line[1] == "db":
            l = [line[0], line[1]]
            for j in range(2, len(line)):
                token = line[j]
                if token.type == "string":
                    for k in range(1, len(token.text) - 1):
                        l.append(Token(str(int.from_bytes(token.text[k].encode("cp1251")))))
                        if k < len(token.text) - 2:
                            l.append(Token(","))
                else:
                    l.append(token)
            lines_level2[i] = l
        elif len(line) >= 2 and line[1] != "db":
            for j in range(len(line)):
                token = line[j]
                if token.type == "string":
                    line[j] = Token(str(int.from_bytes(token.text[1].encode("cp1251"))))
    #
    #ПРЕОБРАЗОВАНИЕ DB
    #
    for i in range(len(lines_level2)):
        line = lines_level2[i]
        if len(line) > 2 and line[1] == "db":
            l = [line[0], line[1], []]
            buff = []
            for j in range(2, len(line)):
                if line[j] != ",":
                    buff.append(line[j])
                if line[j] == "," or j == len(line) - 1:
                    l[2].append(buff)
                    buff = []
            lines_level2[i] = l
    #
    #ОБРАБОТКА ССЫЛОК
    #
    change_data = {}
    index = 0
    bank = 0
    for line in lines_level2:
        if len(line) >= 2 and (line[1] == ":" or line[1] == "db"):
            change_data[line[0].text] = str(index)
        #
        if len(line) == 2 and line[0] == ".bank":
            bank = int(line[1].text)
            if eval(line[1].text) != 0:
                index = 128
            else:
                index = 0
        #
        for j in range(len(line)):
            token = line[j]
            if token == "$":
                line[j] = Token(str(index))
            elif token == "@":
                line[j] = Token(str(bank))
            elif type(token) == type([]):
                for k in range(len(token)):
                    param = token[k]
                    for h in range(len(param)):
                        tk = param[h]
                        if tk == "$":
                            param[h] = Token(str(index))
                        elif tk == "@":
                            param[h] = Token(str(bank))
                    index += 1
                    if index > 255:
                        index = (index - 128) % 128 + 128
                        bank += 1
        #
        if line[0] in all_commands:
            index += 1
            for token in line:
                if token.type == "unknown" or token.type == "number" or token == "$" or token == "@":
                    index += 1
                    break
            if index > 255:
                index = (index - 128) % 128 + 128
                bank += 1
    #
    #ОБРАБОТКА EQU
    #
    for line in lines_level2:
        if len(line) == 3 and line[1] == "equ" and line[2].type == "number":
            change_data[line[0].text] = str(eval(line[2].text))
    #
    #
    #
    for n in range(10):
        #
        #замена меток на числа
        #
        for i in range(len(lines_level2)):
            line = lines_level2[i]
            for j in range(len(line)):
                token = line[j]
                if type(token) != type([]):#если не массив
                    if j != 0:
                        if token.text in change_data:
                            line[j] = Token(change_data[token.text])
                else:
                    for param in token:
                        for k in range(len(param)):
                            tk = param[k]
                            if tk.text in change_data:
                                param[k] = Token(change_data[tk.text])
        #
        #преобразование арифметических операций
        #
        for i in range(len(lines_level2)):
            line = lines_level2[i]
            for j in range(len(line)):
                token = line[j]
                #
                if type(token) == type([]):
                    for k in range(len(token)):
                        if token[k][0].type == "number":#преобразование параметра в число
                            if len(token[k]) > 1 and token[k][2].type == "number":#если несколько параметров
                                token[k] = [numbergen([token[k][0], token[k][1], token[k][2]])]
                            else:
                                token[k] = [numbergen([token[k][0]])]
                else:
                    if token.type == "number":#преобразование параметра в число
                        if j < len(line) - 1 and line[j + 2].type == "number":#если несколько параметров
                            lines_level2[i] = line[:j] + [numbergen([line[j], line[j + 1], line[j + 2]])]
                        else:
                            lines_level2[i] = line[:j] + [numbergen([token])]
                        break
        #
        #добавление к ссылкам числового значения equ
        #
        for line in lines_level2:
            if len(line) == 3 and line[1] == "equ" and line[2].type == "number":
                change_data[line[0].text] = str(eval(line[2].text))
    #
    #РАСКРЫВАЕМ СКОБКИ
    #
    for i in range(len(lines_level2)):
        line = lines_level2[i]
        for j in range(len(line)):
            token = line[j]
            if type(token) == type([]) and j == 2:
                if line[1] == "equ":
                    l = [line[0], line[1]]
                    for k in range(len(token)):
                        l.append(Token(str(eval(token[k][0].text))))
                    lines_level2[i] = l
                elif line[1] == "db":
                    l = [line[0], line[1], []]
                    for k in range(len(token)):
                        l[2].append(Token(str(eval(token[k][0].text))))
                    lines_level2[i] = l
    #
    #ПЕРЕВОД СТРОК В ЧИСЛА
    #
    for line in lines_level2:
        for i in range(len(line)):
            token = line[i]
            if type(token) != type([]) and token.type == "number":
                line[i] = Token(str(eval(token.text)))
    #
    #ФИНАЛЬНОЕ ПРЕОБРАЗОВАНИЕ В БАЙТ - КОД
    #
    print(change_data)
    print()
    lines_level3 = []
    for line in lines_level2:
        command = line[0]
        if len(line) >= 2 and line[1] == "db":
            for number in line[2]:
                lines_level3.append(int(number.text))
        if command == ".bank":
            if int(line[1].text) != 0:
                print(f"Bank {int(line[1].text) - 1}: {min(int(line[1].text) * 128 - len(lines_level3), 128)} bytes left")
            index = int(line[1].text) * 128
            lines_level3 += [0] * (index - len(lines_level3))
        if command == "nop":
            lines_level3.append(0x00)
        elif command == "hlt":
            lines_level3.append(0x01)
        elif command == "ssp":
            lines_level3.append(0x02)
        elif command == "jmp":
            if line[1] not in registers:
                lines_level3.append(0x03)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x04 + reg_to_num[line[1].text])
        elif command == "jz":
            if line[1] not in registers:
                lines_level3.append(0x08)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x10 + reg_to_num[line[1].text] * 4)
        elif command == "js":
            if line[1] not in registers:
                lines_level3.append(0x09)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x11 + reg_to_num[line[1].text] * 4)
        elif command == "jc":
            if line[1] not in registers:
                lines_level3.append(0x0A)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x12 + reg_to_num[line[1].text] * 4)
        elif command == "jo":
            if line[1] not in registers:
                lines_level3.append(0x0B)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x13 + reg_to_num[line[1].text] * 4)
        elif command == "jnz":
            if line[1] not in registers:
                lines_level3.append(0x0C)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x20 + reg_to_num[line[1].text] * 4)
        elif command == "jns":
            if line[1] not in registers:
                lines_level3.append(0x0D)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x21 + reg_to_num[line[1].text] * 4)
        elif command == "jnc":
            if line[1] not in registers:
                lines_level3.append(0x0E)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x22 + reg_to_num[line[1].text] * 4)
        elif command == "jno":
            if line[1] not in registers:
                lines_level3.append(0x0F)
                lines_level3.append(int(line[1].text))
            else:
                lines_level3.append(0x23 + reg_to_num[line[1].text] * 4)
        elif command == "st":
            if line[3] not in registers:
                lines_level3.append(0x30 + reg_to_num[line[1].text] * 5)
                lines_level3.append(int(line[3].text))
            else:
                lines_level3.append(0x30 + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4)
        elif command == "ld":
            if line[3] not in registers:
                lines_level3.append(0x50 + reg_to_num[line[1].text])
                lines_level3.append(int(line[3].text))
            else:
                lines_level3.append(0x40 + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4)
        elif command == "ldi":
            lines_level3.append(0x54 + reg_to_num[line[1].text])
            lines_level3.append(int(line[3].text))
        elif command.text in cmd1:
            lines_level3.append(cmd1[command.text] + reg_to_num[line[1].text] * 5)
        elif command.text in cmd2:
            lines_level3.append(cmd2[command.text] + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4)
        elif command == "shl":
            lines_level3.append(0xE0 + reg_to_num[line[1].text])
        elif command == "shr":
            lines_level3.append(0xE4 + reg_to_num[line[1].text])
        elif command == "sar":
            lines_level3.append(0xE8 + reg_to_num[line[1].text])
        elif command == "rnd":
            lines_level3.append(0xEC + reg_to_num[line[1].text])
    #
    console += "File succesfully compilated"
    return(lines_level3, console)