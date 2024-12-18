from collections import deque
from re import findall

registers, program = [findall(r"\d+",x) for x in open('Day17\\input.txt').read().strip().split("\n\n")]
registers = [int(x) for x in registers]
program = [int(x) for x in program]



def program_execute(registers, program = program):
    output = ""

    i = 0
    while i < len(program):
        opcode = program[i]
        operand = program[i + 1]
        
        i += 2

        value = operand if 0 <= operand <= 3 else registers[operand - 4]
        
        match opcode:
            case 0:
                registers[0] = registers[0] // (2**value)
            case 1:
                registers[1] = registers[1] ^ operand
            case 2:
                registers[1] = value % 8
            case 3:
                if registers[0] != 0:
                    i = operand
            case 4:
                registers[1] = registers[1] ^ registers[2]
            case 5:
                output +=  str(value % 8) + ','
            case 6:
                registers[1] = registers[0] // (2**value)
            case 7:
                registers[2] = registers[0] // (2**value)
    
    return output


# Part 1
print(program_execute(registers, program))


# Part 2

cur_prg = ""
i = len(program) - 1
Qcur = deque([0])

for i in range(15, -1, -1):
    cur_prg = str(program[i]) + "," + cur_prg
    
    Qnxt = deque()
    while Qcur:
        num = Qcur.popleft()

        for j in range(8):
            if program_execute([num*8 + j, 0, 0]) == cur_prg:
                Qnxt.append(num * 8 + j)
    Qcur = deque(list(Qnxt))

print(min(Qnxt))