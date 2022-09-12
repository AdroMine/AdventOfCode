import sys 

def run_instructions(input: list[str], a_start = 0) -> int:
    registers = {'a': a_start, 'b': 0}
#    hlf r sets register r to half its current value, then continues with the next instruction.
#    tpl r sets register r to triple its current value, then continues with the next instruction.
#    inc r increments register r, adding 1 to it, then continues with the next instruction.
#    jmp offset is a jump; it continues with the instruction offset away relative to itself.
#    jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
#    jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd) 
    i = 0
    while True:
        if i >= len(input):
            break
        line = input[i].replace(',', '').split()
        match line:
            case ['hlf', r]:
                registers[r] //= 2
            case ['tpl' , r]:
                registers[r] *= 3
            case ['inc', r]:
                registers[r] += 1
            case ['jmp', offset]:
                i += int(offset)
                continue
            case ['jie', r, offset]:
                if not registers[r] % 2:
                    i += int(offset)
                    continue
            case ['jio', r, offset]:
                if registers[r] == 1:
                    i += int(offset)
                    continue
        i += 1
    
    return registers['b']        
    
    

if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day23\\input.txt'
    input = [line.strip() for line in open(in_file).readlines()]

    print(f"Part 1 = {run_instructions(input)}")
    print(f"Part 2 = {run_instructions(input, 1)}")
    