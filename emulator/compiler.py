import math
from pathlib import Path

spaces = [" ", "\n", "\t", chr(65279)]
symb = [",", ":", "-", "+", "$", "@"]
words = ["db", "equ", ".bank", ".include"]
all_commands = ["nop", "hlt", "ssp", "ld", "ldi", "st", "jmp", "jz", "js", "jc", "jo", "jnz", "jns", "jnc", "jno", "clr", "mov", "and", "or", "xor", "add", "adc", "sub", "sbb", "cmp", "test", "inc", "dec", "not", "neg", "rnd", "shl", "shr", "sar", "rcl", "rcr"]
cmd1 = {"inc" : 0x60, "dec" : 0x70, "not" : 0x80, "neg" : 0x90, "clr" : 0xA0, "test" : 0xB0, "rcl" : 0xC0, "rcr" : 0xD0}
cmd2 = {"add" : 0x60, "sub" : 0x70, "adc" : 0x80, "sbb" : 0x90, "mov" : 0xA0, "and" : 0xB0, "or" : 0xC0, "xor" : 0xD0, "cmp" : 0xF0}

numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
fr = ["a", "b", "c", "d", "z", "s", "o"]
registers = ["a", "b", "c", "d"]
reg_to_num = {"a" : 0, "b" : 1, "c" : 2, "d" : 3}

command_notation = {
    "nop" : {#no, p - param, r - register
        "params" : ["no", "no"],
        "params_count" : 0,
        "block_double_reg" : 0
    },
    "hlt" : {
        "params" : ["no", "no"],
        "params_count" : 0,
        "block_double_reg" : 0
    },
    "ssp" : {
        "params" : ["no", "no"],
        "params_count" : 0,
        "block_double_reg" : 0
    },
    "ld" : {
        "params" : ["r", "r/p"],
        "params_count" : 2,
        "block_double_reg" : 0
    },
    "ldi" : {
        "params" : ["r", "p"],
        "params_count" : 2,
        "block_double_reg" : 0
    },
    "st" : {
        "params" : ["r", "r/p"],
        "params_count" : 2,
        "block_double_reg" : 0
    },
    "jmp" : {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jz" : {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "js" : {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jc": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jo": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jnz": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jns": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jnc": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "jno": {
        "params" : ["r/p", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "clr": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "mov": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "and": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "or": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "xor": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "add": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "adc": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "sub": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "sbb": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "cmp": {
        "params" : ["r", "r"],
        "params_count" : 2,
        "block_double_reg" : 1
    },
    "inc": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "dec": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "not": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "neg": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "test": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "rnd": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "shr": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "shl": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "sar": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "rcr": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    },
    "rcl": {
        "params" : ["r", "no"],
        "params_count" : 1,
        "block_double_reg" : 0
    }
}


class Token():
    def __init__(self, txt, line_ind=0, symb_ind=0, filename=""):
        self.text = txt
        self.line_ind = line_ind
        self.symb_ind = symb_ind
        self.filename = filename
        if len(txt) == 0:
            self.type = "null"
        elif txt[0] in numbers or ((len(txt) >= 2) and txt[0] == "-" and txt[1] in numbers):
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
    for token in tokens:#syntax error
        if token.type != "number" and token != "+" and token != "-":
            return(None)
    #
    while len(tokens) > 1:
        number1 = int(tokens[0].text, base=0)
        number2 = int(tokens[2].text, base=0)
        out = 0
        if tokens[1] == "+":
            out = number1 + number2
        elif tokens[1] == "-":
            out = number1 - number2
        out %= 256
        tokens = [Token(str(out), line_ind=tokens[0].line_ind, symb_ind=tokens[0].symb_ind, filename=tokens[0].filename)] + tokens[3:]
    return(Token(str(int(tokens[0].text, base=0)), line_ind=tokens[0].line_ind, symb_ind=tokens[0].symb_ind, filename=tokens[0].filename))

def is_number(token):
    return(token.type == "number" or token.type == "string" or token == "$" or token == "@" or token.type == "unknown")

def test_param_syntax(param):
    for i in range(len(param)):
        token = param[i]
        next_token = param[i + 1] if i < len(param) - 1 else Token("")
        prev_token = param[i - 1] if i > 0 else Token("")
        if ((token == "-" or token == "+") and (not is_number(next_token) or not is_number(prev_token))) or \
            (is_number(token) and (is_number(next_token) or is_number(prev_token))):
            return(0)
    return(1)

def test_param(param, target_param_types, code, labels, max_string_len=1):
    console_changes = ""
    param_type = "no"
    if len(param) != 0:
        if param[0].type == "register":
            param_type = "r"
        elif is_number(param[0]):
            param_type = "p"
    #
    #
    #invalid param syntax
    if ((param_type == "r" and (len(param) != 1 or param[0].type != "register")) or
            (param_type == "p" and not (
                (len(param) == 1 and is_number(param[0])) or
                (len(param) > 1 and test_param_syntax(param))
            ))):
        console_changes += get_error(8, param[0].line_ind, param[0].symb_ind, param[0].filename)
        return(console_changes, 1)
    #invalid param syntax
    if param != [] and param_type not in target_param_types:
        if param_type == "no":
            console_changes += get_error(8, param[0].line_ind, param[0].symb_ind, param[0].filename)
        else:
            console_changes += get_error(7, param[0].line_ind, param[0].symb_ind, param[0].filename,
                                         token=Token("register") if param_type == "r" else Token("expression"))
        return(console_changes, 1)
    #
    if param_type == "p":
        for token in param:
            #unknown label
            if token.type == "unknown" and token not in labels:
                console_changes += get_error(9, token.line_ind, token.symb_ind, token.filename, token=token)
                return(console_changes, 1)
            #
            if token.type == "string":
                #string too long
                if len(token.text) - 2 > max_string_len or len(token.text) - 2 <= 0:
                    console_changes += get_error(11, token.line_ind, token.symb_ind + 1, token.filename,
                                                 token=Token(str(len(token.text) - 2)))
                    return(console_changes, 1)
    return("", 0)

def get_error(err_code, line_ind, pos, filename, token=Token(" ")):
    file = open(filename, "r", encoding="utf-8")
    code = file.read()
    file.close()
    #
    if err_code != 22 and err_code != 23:
        res = f"Syntax error in file \"{filename}\" on line {line_ind}:\n"
    else:
        res = f"Error in file \"{filename}\" on line {line_ind}:\n"
    res += code.split("\n")[line_ind].replace("\t", "    ") + "\n"
    t = 0
    for symb in code.split("\n")[line_ind]:
        if symb == "\t":
            t += 3
    res += " " * (pos + t) + "^\n"
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
    elif err_code == 15:
        res += f"Invalid colon placement"
    elif err_code == 16:
        res += f"Invalid comma placement"
    elif err_code == 17:
        res += f"Directive .bank requires a number, not {token}"
    elif err_code == 18:
        res += f"Number must be between 1 and 255, not {token}"
    elif err_code == 19:
        res += f"Bank {token} already exists"
    elif err_code == 20:
        res += f"Memory overflow: bank {token} > 255"
    elif err_code == 21:
        res += f"Data overflow from bank {token} to next bank"
    elif err_code == 22:
        res += f"File \"{token}\" was included earlier\n"
    elif err_code == 23:
        res += f"File \"{token}\" not found"
    elif err_code == 24:
        res += "Parameter must be a string"
    res += "\n\n"
    return(res)

def tokenise(filename, files):
    console = ""
    code = ""
    try:
        file = open(filename, "r", encoding="utf-8")
        code = file.read()
        file.close()
    except:
        console += f"File \"{filename}\" not found"
        return([], console, 1)
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
        if (symbol == "'" or symbol == '"') and not comment and not double_block:
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
                elif next_symbol == '"':
                    buffer += '"'
                elif next_symbol == "'":
                    buffer += "'"
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
                elif db and len(line) > 0 and line[-1] != "," and line[-1] != "db" and line[-1] != "-" and line[-1] != "+" and buffer != ",":
                    if buffer != "-" and buffer != "+":
                        line = []
                        lines_level1.append(Token("__end__", line_ind, curpos, filename))
                        db = 0
                lines_level1.append(Token(buffer, line_ind, curpos, filename))
                line.append(Token(buffer))
                buffer = ""
        if len(line) > 0 and db == 0 and (symbol == "\n" or line[-1] == ":"):
            line = []
            lines_level1.append(Token("__end__", line_ind, curpos, filename))
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
    print(lines_level1)
    for token in lines_level1:
        if token.type == "number":
            #invalid number format
            try:
                int(token.text, 0)
            except:
                console += get_error(13, token.line_ind, token.symb_ind, token.filename)
                error = 1
                continue
        elif token.type == "string":
            #string not closed
            if token.text[-1] != "'" and token.text[-1] != '"' or len(token.text) < 2:
                console += get_error(12, token.line_ind, token.symb_ind + len(token.text), token.filename)
                error = 1
                continue
            #empty string
            if len(token.text) == 2:
                console += get_error(10, token.line_ind, token.symb_ind, token.filename)
                error = 1
                continue
    #
    for i in range(len(lines_level2)):
        command = lines_level2[i]
        #неверное количество параметров
        if command[0] == ".include" and len(command) > 2:
            console += get_error(5, command[2].line_ind, command[2].symb_ind, command[2].filename)
            error = 1
            continue
        if command[0] == ".include" and len(command) == 1:
            console += get_error(4, command[0].line_ind, command[0].symb_ind + len(command[0].text), command[0].filename)
            error = 1
            continue
        #параметр - не строка
        if command[0] == ".include" and command[1].type != "string":
            console += get_error(24, command[1].line_ind, command[1].symb_ind, command[1].filename)
            error = 1
            continue
    if error:
        return([], console, 1)
    #
    #.include
    #
    out = lines_level2.copy()
    for i in range(len(lines_level2)):
        line = lines_level2[i]
        if line[0] == ".include":
            patch = str(Path(filename).parent) + "\\" + line[1].text[1:-1]
            if patch not in files:
                try:
                    file = open(patch, encoding="utf-8")
                    file.close()
                except:
                    console += get_error(23, line[1].line_ind, line[1].symb_ind, line[1].filename, token=line[1].text[1:-1])
                    return([], console, 1)
                files.append(patch)
                res = tokenise(patch, files)
                console += res[1]
                if res[2]:
                    return([], console, 1)
                out += res[0]
            else:
                console += get_error(22, line[1].line_ind, line[1].symb_ind, line[1].filename, token=line[1].text[1:-1])
                return([], console, 1)
    return(out, console, 0)




def compile(filename):
    code = ""
    try:
        file = open(filename, "r", encoding="utf-8")
        code = file.read()
        file.close()
    except:
        pass
    console = ""
    t = "Restart: " + filename
    console += f"=={"=" * max(len(t), 100)}==\n"
    console += f"=={" " * int(50 - len(t) / 2)}{t}{" " * math.ceil(50 - len(t) / 2)}==\n"
    console += f"=={"=" * max(len(t), 100)}==\n\n"
    #
    #ТОКЕНАЙЗЕР И ПРЕПРОЦЕССОР
    #
    res = tokenise(filename, [filename])
    commands = res[0]
    console += res[1]
    if res[2]:
        return([], console, 1)
    #
    #ПРОВЕРКА СИНТАКСИСА
    #
    error = 0
    labels = []
    for i in range(len(commands)):#проверка дублирования меток
        command = commands[i]
        if len(command) >= 2 and (command[1] == ":" or command[1] == "equ" or command[1] == "db"):
            if command[0].text in labels:
                console += get_error(3, command[0].line_ind, command[0].symb_ind, command[0].filename, token=command[0])
                error = 1
            else:
                labels.append(command[0].text)
    #
    for i in range(len(commands)):
        cont = 0
        command = commands[i]
        #неизвестная команда
        if command[0] != ".bank" and command[0] != ".include" and (
                command[0].type == "unknown" and
                ((len(command) >= 2 and command[1] != ":" and command[1] != "equ" and command[1] != "db") or (len(command) == 1)) or
                (command[0].type != "command" and command[0].type != "unknown")
        ):
            console += get_error(0, command[0].line_ind, command[0].symb_ind, command[0].filename, token=command[0])
            error = 1
            continue
        #двоеточие в конце строки
        if command[-1] == ":" and command[0].type != "unknown":
            console += get_error(15, command[-1].line_ind, command[-1].symb_ind, command[-1].filename)
            error = 1
            continue
        #запятая в конце строки
        if command[-1] == ",":
            console += get_error(16, command[-1].line_ind, command[-1].symb_ind, command[-1].filename)
            error = 1
            continue
        #incorrect label name
        if len(command) == 2 and (command[1] == ":" or command[1] == "equ" or command[1] == "db") and command[0].type != "unknown":
            console += get_error(1, command[0].line_ind, command[0].symb_ind, command[0].filename, token=command[0])
            error = 1
            continue
        #expected label name
        if command[0] == ":" or command[0] == "equ" or command[0] == "db":
            console += get_error(2, command[0].line_ind, command[0].symb_ind, command[0].filename, token=command[0])
            error = 1
            continue
        #.bank incorrect token
        if command[0] == ".bank" and (len(command) > 1 and command[1].type != "number"):
            console += get_error(17, command[1].line_ind, command[1].symb_ind, command[0].filename, token=command[1])
            error = 1
            continue
        #.bank number < 1 or > 255
        if command[0] == ".bank" and len(command) == 2 and (
                int(command[1].text, base=0) <= 0 or int(command[1].text, base=0) > 255):
            console += get_error(18, command[1].line_ind, command[1].symb_ind, command[1].filename, token=command[1])
            error = 1
            continue
        #.bank incorrect number of params
        if command[0] == ".bank" and len(command) > 2:
            console += get_error(5, command[2].line_ind, command[2].symb_ind, command[2].filename)
            error = 1
            continue
        #command params
        if command[0].type == "command":
            param = []
            buffer = []
            p_ind = 0
            if len(command) == 1 and command_notation[command[0].text]["params_count"] > 0:
                console += get_error(5, command[0].line_ind, command[0].symb_ind + len(command[0].text),
                                     command[0].filename)
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
                        console += get_error(5, token.line_ind, token.symb_ind, token.filename)
                        error = 1
                        cont = 1
                        break
                    #empty parameter
                    if buffer == []:
                        console += get_error(6, token.line_ind, token.symb_ind - 1, token.filename)
                        error = 1
                        cont = 1
                        break
                    #
                    param.append(buffer)
                    buffer = []
                    #
                    if token == "," and j == len(command) - 1:
                        console += get_error(6, token.line_ind, token.symb_ind + 1, token.filename)
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
                    elif is_number(param[j][0]):
                        param_type[j] = "p"
            #
            for j in range(2):
                res = test_param(param[j], command_notation[command[0].text]["params"][j], code, labels)
                if res[1]:
                    console += res[0]
                    error = 1
                    cont = 1
                    break
            if cont:
                continue
            #
            if command_notation[command[0].text]["params_count"] == 2 and \
                    command_notation[command[0].text]["params"][0] == "r" and \
                    command_notation[command[0].text]["params"][1] == "r" and \
                    command_notation[command[0].text]["block_double_reg"] and \
                    param[0][0].text == param[1][0].text:
                console += get_error(0, command[0].line_ind, command[0].symb_ind, command[0].filename,
                                     token=f"{command[0].text} {command[1].text}, {command[3].text}")
                error = 1
                continue
        #equ params
        if len(command) >= 2 and command[1] == "equ":
            param = command[2:]
            res = test_param(param, "p", code, labels)
            if res[1]:
                console += res[0]
                error = 1
                continue
        #db params
        if len(command) >= 2 and command[1] == "db":
            params = []
            buffer = []
            for i in range(2, len(command)):
                token = command[i]
                if token != ",":
                    buffer.append(token)
                if token == "," or i == len(command) - 1:
                    params.append(buffer)
                    buffer = []
            #
            cont = 0
            for i in range(2, len(command)):
                token = command[i]
                next_token = command[i + 1] if i < len(command) - 1 else ""
                if token == "," and next_token == ",":
                    console += get_error(16, token.line_ind, token.symb_ind, token.filename)
                    error = 1
                    break
            #
            for param in params:
                res = test_param(param, "p", code, labels, max_string_len=1000)
                if res[1]:
                    console += res[0]
                    error = 1
                    break
    #
    if error:
        return([], console, 1)
    #
    #ОБРАБОТКА СТРОК В DB
    #
    for i in range(len(commands)):
        line = commands[i]
        if len(line) > 2 and line[1] == "db":
            l = [line[0], line[1]]
            for j in range(2, len(line)):
                token = line[j]
                if token.type == "string":
                    for k in range(1, len(token.text) - 1):
                        l.append(Token(str(int.from_bytes(token.text[k].encode("cp1251"))), line_ind=token.line_ind, symb_ind=token.symb_ind, filename=token.filename))
                        if k < len(token.text) - 2:
                            l.append(Token(","))
                else:
                    l.append(token)
            commands[i] = l
        elif len(line) >= 2 and line[1] != "db" and line[0] != ".include":
            for j in range(len(line)):
                token = line[j]
                if token.type == "string":
                    line[j] = Token(str(int.from_bytes(token.text[1].encode("cp1251"))), line_ind=token.line_ind, symb_ind=token.symb_ind, filename=token.filename)
    #
    #ПРЕОБРАЗОВАНИЕ DB
    #
    for i in range(len(commands)):
        line = commands[i]
        if len(line) > 2 and line[1] == "db":
            l = [line[0], line[1], []]
            buff = []
            for j in range(2, len(line)):
                if line[j] != ",":
                    buff.append(line[j])
                if line[j] == "," or j == len(line) - 1:
                    l[2].append(buff)
                    buff = []
            commands[i] = l
    #
    #ПРОВЕРКА ДУБЛИРОВАНИЯ БАНКОВ
    #
    banks = []
    index = 0
    bank = 0
    for i in range(len(commands)):
        command = commands[i]
        cont = 0
        #
        for j in range(len(command)):
            token = command[j]
            if type(token) == type([]):
                for k in range(len(token)):
                    if index > 255:
                        index = (index - 128) % 128 + 128
                        bank += 1
                        if bank in banks:
                            console += get_error(19, token[k][0].line_ind, token[k][0].symb_ind, token[k][0].filename, token=bank)
                            error = 1
                            cont = 1
                            break
                        if bank > 255:
                            console += get_error(20, token[k][0].line_ind, token[k][0].symb_ind, token[k][0].filename, token=bank)
                            error = 1
                            cont = 1
                            break
                        banks.append(bank)
                    index += 1
        if cont:
            continue
        #
        if command[0] in all_commands:
            index += 1
            for token in command:
                if token.type == "unknown" or token.type == "number" or token == "$" or token == "@":
                    index += 1
                    break
            if index > 255:
                index = (index - 128) % 128 + 128
                bank += 1
                if bank in banks:
                    console += get_error(19, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                if bank > 255:
                    console += get_error(20, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                banks.append(bank)
        #
        if command[0] == ".bank":
            if len(command) == 1:
                index = 128
                bank += 1
                if bank in banks:
                    console += get_error(19, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                if bank > 255:
                    console += get_error(20, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                banks.append(bank)
            else:
                bank = int(command[1].text, base=0)
                index = 128
                if bank in banks:
                    console += get_error(19, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                if bank > 255:
                    console += get_error(20, command[0].line_ind, command[0].symb_ind, command[0].filename, token=bank)
                    error = 1
                    continue
                banks.append(bank)
    if error:
        return([], console, 1)
    #
    #ОБРАБОТКА ССЫЛОК
    #
    change_data = {}
    index = 0
    bank = 0
    for line in commands:
        if len(line) >= 2 and (line[1] == ":" or line[1] == "db"):
            change_data[line[0].text] = str(index)
        #
        if line[0] == ".bank":
            if len(line) == 1:
                bank += 1
                index = 128
            else:
                bank = int(line[1].text, base=0)
                index = 128
        #
        for j in range(len(line)):
            token = line[j]
            if token == "$":
                line[j] = Token(str(index), line_ind=token.line_ind, symb_ind=token.symb_ind, filename=token.filename)
            elif token == "@":
                line[j] = Token(str(bank), line_ind=token.line_ind, symb_ind=token.symb_ind, filename=token.filename)
            elif type(token) == type([]):
                for k in range(len(token)):
                    param = token[k]
                    for h in range(len(param)):
                        tk = param[h]
                        if tk == "$":
                            param[h] = Token(str(index), line_ind=tk.line_ind, symb_ind=tk.symb_ind, filename=token.filename)
                        elif tk == "@":
                            param[h] = Token(str(bank), line_ind=tk.line_ind, symb_ind=tk.symb_ind, filename=token.filename)
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
    for line in commands:
        if len(line) == 3 and line[1] == "equ" and line[2].type == "number":
            change_data[line[0].text] = str(eval(line[2].text))
    #
    #
    #
    for n in range(10):
        #
        #замена меток на числа
        #
        for i in range(len(commands)):
            line = commands[i]
            for j in range(len(line)):
                token = line[j]
                if type(token) != type([]):#если не массив
                    if j != 0:
                        if token.text in change_data:
                            line[j] = Token(change_data[token.text], line_ind=token.line_ind, symb_ind=token.symb_ind, filename=token.filename)
                else:
                    for param in token:
                        for k in range(len(param)):
                            tk = param[k]
                            if tk.text in change_data:
                                param[k] = Token(change_data[tk.text], line_ind=tk.line_ind, symb_ind=tk.symb_ind, filename=tk.filename)
        #
        #преобразование арифметических операций
        #
        for i in range(len(commands)):
            line = commands[i]
            for j in range(len(line)):
                token = line[j]
                #
                if type(token) == type([]):#для db
                    for k in range(len(token)):
                        num = numbergen(token[k])
                        if num != None:
                            token[k] = [num]
                else:#для equ и прочих команд
                    if token.type == "number":#преобразование параметра в число
                        num = numbergen(line[j:])
                        if num != None:
                            commands[i] = line[:j] + [num]
                        break
        #
        #добавление к ссылкам числового значения equ
        #
        for line in commands:
            if len(line) == 3 and line[1] == "equ" and line[2].type == "number":
                change_data[line[0].text] = str(eval(line[2].text))
    #
    #РАСКРЫВАЕМ СКОБКИ
    #
    for i in range(len(commands)):
        line = commands[i]
        for j in range(len(line)):
            token = line[j]
            if type(token) == type([]) and j == 2:
                if line[1] == "equ":
                    l = [line[0], line[1]]
                    for k in range(len(token)):
                        l.append(token[k][0])
                    commands[i] = l
                elif line[1] == "db":
                    l = [line[0], line[1], []]
                    for k in range(len(token)):
                        l[2].append(token[k][0])
                    commands[i] = l
    #
    #ПЕРЕВОД СТРОК В ЧИСЛА
    #
    for line in commands:
        for i in range(len(line)):
            token = line[i]
            if type(token) != type([]) and token.type == "number":
                line[i] = Token(str(eval(token.text)), line_ind=token.line_ind, symb_ind=token.symb_ind)
    #
    #ПРОВЕРКА ЧИСЕЛ НА ДОПУСТИМЫЙ ДИАПАЗОН
    #
    for line in commands:
        for token in line:
            if type(token) != type([]):
                if token.type == "number" and (eval(token.text) > 255 or eval(token.text) < 0):
                    console += get_error(14, token.line_ind, token.symb_ind, token.filename, token=token)
                    error = 1
            else:
                for tk in token:
                    if tk.type == "number" and (eval(tk.text) > 255 or eval(tk.text) < 0):
                        console += get_error(14, tk.line_ind, tk.symb_ind, tk.filaname, token=token)
                        error = 1
    if error:
        return([], console, 1)
    #
    #УБИРАЕМ ЛИШНИЕ КОМАНДЫ
    #
    coms = []
    for command in commands:
        if not(len(command) > 1 and (command[1] == "equ" or command[1] == ":")):
            coms.append(command)
    #
    #ФИНАЛЬНОЕ ПРЕОБРАЗОВАНИЕ В БАЙТ - КОД
    #
    #print(change_data)
    out = [0 for x in range(32768)]
    bl = [-1 for x in range(256)]
    addr = 0
    laddr = 0
    code_length = 0
    for h in range(len(coms)):
        line = coms[h]
        command = line[0]
        if command == ".bank":
            la = addr
            if len(line) == 1:
                addr = (laddr // 128 + 1) * 128
            else:
                addr = int(line[1].text) * 128
            bl[laddr // 128] = laddr // 128 * 128 + 128 - la
        laddr = addr
        if len(line) >= 2 and line[1] == "db":
            la = addr
            for n in range(len(line[2])):
                number = line[2][n]
                la = addr
                out[addr] = int(number.text, base=0)
                if addr // 128 != (addr + 1) // 128 and n != len(line[2]) - 1:
                    console += get_error(21, number.line_ind, number.symb_ind, number.filaname, addr // 128)
                    return([], console, 1)
                addr += 1
                code_length += 1
            if laddr // 128 != addr // 128 or h == len(coms) - 1:
                bl[la // 128] = la // 128 * 128 + 128 - addr
        if command == "nop":
            out[addr] = 0x00
            addr += 1
            code_length += 1
        elif command == "hlt":
            out[addr] = 0x01
            addr += 1
            code_length += 1
        elif command == "ssp":
            out[addr] = 0x02
            addr += 1
            code_length += 1
        elif command == "jmp":
            if line[1] not in registers:
                out[addr] = 0x03
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x04 + reg_to_num[line[1].text]
                addr += 1
                code_length += 1
        elif command == "jz":
            if line[1] not in registers:
                out[addr] = 0x08
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x10 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "js":
            if line[1] not in registers:
                out[addr] = 0x09
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x11 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jc":
            if line[1] not in registers:
                out[addr] = 0x0A
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x12 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jo":
            if line[1] not in registers:
                out[addr] = 0x0B
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x13 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jnz":
            if line[1] not in registers:
                out[addr] = 0x0C
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x20 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jns":
            if line[1] not in registers:
                out[addr] = 0x0D
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x21 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jnc":
            if line[1] not in registers:
                out[addr] = 0x0E
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x22 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "jno":
            if line[1] not in registers:
                out[addr] = 0x0F
                addr += 1
                out[addr] = int(line[1].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x23 + reg_to_num[line[1].text] * 4
                addr += 1
                code_length += 1
        elif command == "st":
            if line[3] not in registers:
                out[addr] = 0x30 + reg_to_num[line[1].text] * 5
                addr += 1
                out[addr] = int(line[3].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x30 + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4
                addr += 1
                code_length += 1
        elif command == "ld":
            if line[3] not in registers:
                out[addr] = 0x50 + reg_to_num[line[1].text]
                addr += 1
                out[addr] = int(line[3].text)
                addr += 1
                code_length += 2
            else:
                out[addr] = 0x40 + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4
                addr += 1
                code_length += 1
        elif command == "ldi":
            out[addr] = 0x54 + reg_to_num[line[1].text]
            addr += 1
            out[addr] = int(line[3].text)
            addr += 1
            code_length += 2
        elif command.text in cmd1:
            out[addr] = cmd1[command.text] + reg_to_num[line[1].text] * 5
            addr += 1
            code_length += 1
        elif command.text in cmd2:
            out[addr] = cmd2[command.text] + reg_to_num[line[1].text] + reg_to_num[line[3].text] * 4
            addr += 1
            code_length += 1
        elif command == "shl":
            out[addr] = 0xE0 + reg_to_num[line[1].text]
            addr += 1
            code_length += 1
        elif command == "shr":
            out[addr] = 0xE4 + reg_to_num[line[1].text]
            addr += 1
            code_length += 1
        elif command == "sar":
            out[addr] = 0xE8 + reg_to_num[line[1].text]
            addr += 1
            code_length += 1
        elif command == "rnd":
            out[addr] = 0xEC + reg_to_num[line[1].text]
            addr += 1
            code_length += 1
        #
        if (laddr // 128 != addr // 128 or h == len(coms) - 1) and not(len(line) >= 2 and line[1] == "db") and command != ".bank":
            bl[laddr // 128] = laddr // 128 * 128 + 128 - addr
    #
    for i in range(len(bl)):
        if bl[i] != -1:
            console += f"Bank {i}: {bl[i]} bytes left\n"
    #
    console += "\n"
    console += "File succesfully compilated\n"
    console += f"Code length: {code_length} bytes"
    return(out, console, 0)

if __name__ == "__main__":
    res = compile("D:/projects/chuemu/emulator/files/programs/farmer_2010/test.asm")
    print(res[1])