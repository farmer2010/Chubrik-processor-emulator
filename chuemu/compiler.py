spaces = [" ", "\n", "\t", chr(65279)]
symb = [",", ":", "-", "+", "$", "@"]
words = ["db", "equ", ".bank"]
all_commands = ["nop", "hlt", "ssp", "ld", "ldi", "st", "jmp", "jz", "js", "jc", "jo", "jnz", "jns", "jnc", "jno", "clr", "mov", "and", "or", "xor", "add", "adc", "sub", "sbb", "test", "inc", "dec", "not", "neg", "rnd", "shl", "shr", "sar", "rcl", "rcr"]
cmd1 = {"inc" : 0x60, "dec" : 0x70, "not" : 0x80, "neg" : 0x90, "clr" : 0xA0, "test" : 0xB0, "rcl" : 0xC0, "rcr" : 0xD0}
cmd2 = {"add" : 0x60, "sub" : 0x70, "adc" : 0x80, "sbb" : 0x90, "mov" : 0xA0, "and" : 0xB0, "or" : 0xC0, "xor" : 0xD0}

numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
fr = ["a", "b", "c", "d", "z", "s", "o"]
registers = ["a", "b", "c", "d"]
reg_to_num = {"a" : 0, "b" : 1, "c" : 2, "d" : 3}

command_notation = {
    "nop" : {#no, p - param, r - register
        "params" : ["no", "no"],
        "params_count" : 0
    },
    "hlt" : {
        "params" : ["no", "no"],
        "params_count" : 0
    },
    "ssp" : {
        "params" : ["no", "no"],
        "params_count" : 0
    },
    "ld" : {
        "params" : ["r", "r/p"],
        "params_count" : 2
    },
    "ldi" : {
        "params" : ["r", "p"],
        "params_count" : 2
    },
    "st" : {
        "params" : ["r", "r/p"],
        "params_count" : 2
    },
    "jmp" : {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jz" : {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "js" : {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jc": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jo": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jnz": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jns": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jnc": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "jno": {
        "params" : ["r/p", "no"],
        "params_count" : 1
    },
    "clr": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "mov": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "and": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "or": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "xor": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "add": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "adc": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "sub": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "sbb": {
        "params" : ["r", "r"],
        "params_count" : 2
    },
    "inc": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "dec": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "not": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "neg": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "test": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "rnd": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "shr": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "shl": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "sar": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "rcr": {
        "params" : ["r", "no"],
        "params_count" : 1
    },
    "rcl": {
        "params" : ["r", "no"],
        "params_count" : 1
    }
}


class Token():
    def __init__(self, txt, line_ind=0, symb_ind=0):
        self.text = txt
        self.line_ind = line_ind
        self.symb_ind = symb_ind
        if txt[0] in numbers or ((len(txt) >= 2) and txt[0] == "-" and txt[1] in numbers):
            self.type = "number"
        elif txt in symb:
            self.type = "special symbol"
        elif txt in words:
            self.type = "word"
        elif txt[0] == "'" or txt[0] == '"':
            self.type = "string"
        elif txt in all_commands:
            self.type = "command"
        elif txt in registers:
            self.type = "register"
        elif txt == "__end__":
            self.type = "end line"
        elif txt == "__end_code__":
            self.type = "end code"
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
        return(Token(str(eval(tokens[0].text)), line_ind=tokens[0].line_ind, symb_ind=tokens[0].symb_ind))
    elif len(tokens) == 3:
        number1 = eval(tokens[0].text)
        number2 = eval(tokens[2].text)
        out = 0
        if tokens[1] == "+":
            out = number1 + number2
        elif tokens[1] == "-":
            out = number1 - number2
        return(Token(str(out), line_ind=tokens[0].line_ind, symb_ind=tokens[0].symb_ind))
    return(None)#syntax error

def is_number(token):
    return(token.type == "number" or token.type == "string" or token == "$" or token.type == "unknown")

def get_error(err_code, line_ind, pos, code, token=Token(" ")):
    res = f"Syntax error (code {err_code}) on line {line_ind}:\n"
    res += code.split("\n")[line_ind] + "\n"
    res += " " * pos + "^\n"
    if err_code == 0:
        res += f'Unknown command: "{token}"'
    elif err_code == 1:
        res += f'Invalid label name: "{token}"'
    elif err_code == 2:
        res += "Expected label name"
    elif err_code == 3:
        res += f'Duplicate label: "{token}"'
    elif err_code == 4:
        res += "Expected parameter"
    elif err_code == 5:
        res += "Invalid number of parameters"
    elif err_code == 6:
        res += "Empty parameter"
    elif err_code == 7:
        res += f"Invalid type of parameter: {token}"
    elif err_code == 8:
        res += "Invalid parameter syntax"
    elif err_code == 9:
        res += f'Unknown label: "{token}"'
    elif err_code == 10:
        res += "Empty string"
    elif err_code == 11:
        res += f"Length of this string must be 1, not {token}"#token - string len
    elif err_code == 12:
        res += "String not closed"
    elif err_code == 13:
        res += "Invalid number format"
    elif err_code == 14:
        res += f"Number must be between 0 and 255, not {token}"
    res += "\n\n"
    return(res)

def compile(code):
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
        #
        if (symbol == "'" or symbol == '"') and not comment:
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
            elif not symbol in spaces:
                token_type = "word"
        #
        if not comment and ((token_type == "string" and symbol != "\n") or (not symbol in spaces and (
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
    #ПРОВЕРКА СИНТАКСИСА
    #
    error = 0
    for token in lines_level1:
        if token.type == "number":
            #invalid number format
            try:
                eval(token.text)
            except:
                console += get_error(13, token.line_ind, token.symb_ind, code)
                error = 1
                continue
        elif token.type == "string":
            #string not closed
            if token.text[-1] != "'" and token.text[-1] != '"' or len(token.text) < 2:
                console += get_error(12, token.line_ind, token.symb_ind + len(token.text), code)
                error = 1
                continue
            #empty string
            if len(token.text) == 2:
                console += get_error(10, token.line_ind, token.symb_ind, code)
                error = 1
                continue
    #
    labels = []
    for i in range(len(lines_level2)):#проверка дублирования меток
        command = lines_level2[i]
        if len(command) >= 2 and (command[1] == ":" or command[1] == "equ" or command[1] == "db"):
            if command[0].text in labels:
                console += get_error(3, command[0].line_ind, command[0].symb_ind, code, token=command[0])
                error = 1
            else:
                labels.append(command[0].text)
    #
    for i in range(len(lines_level2)):
        cont = 0
        command = lines_level2[i]
        #unknown command
        if command[0].type == "unknown" and ((len(command) >= 2 and command[1] != ":" and command[1] != "equ" and command[1] != "db") or (len(command) == 1)):
            console += get_error(0, command[0].line_ind, command[0].symb_ind, code, token=command[0])
            error = 1
            continue
        #incorrect label name
        if len(command) == 2 and (command[1] == ":" or command[1] == "equ" or command[1] == "db") and command[0].type != "unknown":
            console += get_error(1, command[0].line_ind, command[0].symb_ind, code, token=command[0])
            error = 1
            continue
        #expected label name
        if command[0] == ":" or command[0] == "equ" or command[0] == "db":
            console += get_error(2, command[0].line_ind, command[0].symb_ind, code, token=command[0])
            error = 1
            continue
        #command params
        if command[0].type == "command":
            param = []
            buffer = []
            p_ind = 0
            if len(command) == 1 and command_notation[command[0].text]["params_count"] > 0:
                console += get_error(5, command[0].line_ind, command[0].symb_ind + len(command[0].text), code)
                error = 1
                break
            for j in range(1, len(command)):
                token = command[j]
                #
                if token != ",":
                    buffer.append(token)
                if token == "," or j == len(command) - 1:
                    p_ind += 1
                    if p_ind > command_notation[command[0].text]["params_count"]:
                        console += get_error(5, token.line_ind, token.symb_ind, code)
                        error = 1
                        cont = 1
                        break
                    #empty parameter
                    if buffer == []:
                        console += get_error(6, token.line_ind, token.symb_ind - 1, code)
                        error = 1
                        cont = 1
                        break
                    #
                    param.append(buffer)
                    buffer = []
                    #
                    if token == "," and j == len(command) - 1:
                        console += get_error(6, token.line_ind, token.symb_ind + 1, code)
                        error = 1
                        cont = 1
                        break
            if cont:
                continue
            #
            param += [[]] * (2 - len(param))
            #
            param_type = ["no", "no"]
            for j in range(2):
                if param[j] != []:
                    if param[j][0].type == "register":
                        param_type[j] = "r"
                    elif param[j][0] == "$" or param[j][0].type == "number" or param[j][0].type == "unknown" or param[j][0].type == "string":
                        param_type[j] = "p"
            #
            for j in range(2):
                # incorrect param syntax
                if ((param_type[j] == "r" and (len(param[j]) != 1 or param[j][0].type != "register")) or
                        (param_type[j] == "p" and not (
                                (len(param[j]) == 1 and is_number(param[j][0])) or
                                (len(param[j]) == 3 and is_number(param[j][0]) and is_number(param[j][2]) and (
                                        param[j][1] == "-" or param[j][1] == "+"))
                        ))):
                    console += get_error(8, param[j][0].line_ind, param[j][0].symb_ind, code)
                    error = 1
                    cont = 1
                    break
                #incorrect param syntax
                if param[j] != [] and param_type[j] not in command_notation[command[0].text]["params"][j]:
                    if param_type[j] == "no":
                        console += get_error(8, param[j][0].line_ind, param[j][0].symb_ind, code)
                    else:
                        console += get_error(7, param[j][0].line_ind, param[j][0].symb_ind, code, token=Token("register") if param_type[j] == "r" else Token("expression"))
                    error = 1
                    cont = 1
                    break
                #
                if param_type[j] == "p":
                    for token in param[j]:
                        #unknown label
                        if token.type == "unknown" and token not in labels:
                            console += get_error(9, token.line_ind, token.symb_ind, code, token=token)
                            error = 1
                            cont = 1
                            break
                        #
                        if token.type == "string":
                            #string too long
                            if len(token.text) > 3:
                                console += get_error(11, token.line_ind, token.symb_ind + 1, code, Token(str(len(token.text) - 2)))
                                cont = 1
                                error = 1
                                break
            if cont:
                continue
        #equ params
        if len(command) >= 2 and command[1] == "equ":
            param = command[2:]

    #
    if error:
        return([], console)
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
                        l.append(Token(str(int.from_bytes(token.text[k].encode("cp1251"))), line_ind=token.line_ind, symb_ind=token.symb_ind))
                        if k < len(token.text) - 2:
                            l.append(Token(","))
                else:
                    l.append(token)
            lines_level2[i] = l
        elif len(line) >= 2 and line[1] != "db":
            for j in range(len(line)):
                token = line[j]
                if token.type == "string":
                    line[j] = Token(str(int.from_bytes(token.text[1].encode("cp1251"))), line_ind=token.line_ind, symb_ind=token.symb_ind)
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
                line[j] = Token(str(index), line_ind=token.line_ind, symb_ind=token.symb_ind)
            elif token == "@":
                line[j] = Token(str(bank), line_ind=token.line_ind, symb_ind=token.symb_ind)
            elif type(token) == type([]):
                for k in range(len(token)):
                    param = token[k]
                    for h in range(len(param)):
                        tk = param[h]
                        if tk == "$":
                            param[h] = Token(str(index), line_ind=tk.line_ind, symb_ind=tk.symb_ind)
                        elif tk == "@":
                            param[h] = Token(str(bank), line_ind=tk.line_ind, symb_ind=tk.symb_ind)
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
                            line[j] = Token(change_data[token.text], line_ind=token.line_ind, symb_ind=token.symb_ind)
                else:
                    for param in token:
                        for k in range(len(param)):
                            tk = param[k]
                            if tk.text in change_data:
                                param[k] = Token(change_data[tk.text], line_ind=tk.line_ind, symb_ind=tk.symb_ind)
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
                        l.append(token[k][0])
                    lines_level2[i] = l
                elif line[1] == "db":
                    l = [line[0], line[1], []]
                    for k in range(len(token)):
                        l[2].append(token[k][0])
                    lines_level2[i] = l
    #
    #ПЕРЕВОД СТРОК В ЧИСЛА
    #
    for line in lines_level2:
        for i in range(len(line)):
            token = line[i]
            if type(token) != type([]) and token.type == "number":
                line[i] = Token(str(eval(token.text)), line_ind=token.line_ind, symb_ind=token.symb_ind)
    #
    #ПРОВЕРКА ЧИСЕЛ НА ДОПУСТИМЫЙ ДИАПАЗОН
    #
    error2 = 0
    for line in lines_level2:
        for token in line:
            if type(token) != type([]):
                if token.type == "number" and (eval(token.text) > 255 or eval(token.text) < 0):
                    console += get_error(14, token.line_ind, token.symb_ind, code, token=token)
                    error2 = 1
            else:
                for tk in token:
                    if tk.type == "number" and (eval(tk.text) > 255 or eval(tk.text) < 0):
                        console += get_error(14, tk.line_ind, tk.symb_ind, code, token=token)
                        error2 = 1
    if error2:
        return([], console)
    #
    #ФИНАЛЬНОЕ ПРЕОБРАЗОВАНИЕ В БАЙТ - КОД
    #
    print(change_data)
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

text = '''
jmp lab + ""
'''

file = open("files/programs/snake.asm", encoding="utf-8")
prog = file.read()
file.close()

#r = compile(text)
#print(r[1])