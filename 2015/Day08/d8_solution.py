import sys
from typing import List

def d8_p1(input: List[str]) -> int:
    lit = 0
    mem = 0
    for line in input:
        lit += len(line)
        mem += len(eval(line))
    return lit - mem

def d8_p2(input: List[str]) -> int:
    enc = 0
    lit = 0
    for line in input:
        lit += len(line)
        enc += len(line.replace('\\', '\\\\').replace('"', '\\"')) + 2 # 2 for quotes at start/end
    return enc - lit

def d8_p2_2(input: List[str]) -> int:
    tot = 0
    for line in input:
        tot += 2 + line.count('\\') + line.count('"')
    return tot
    
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day08\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]

    print(f"Part 1 = {d8_p1(input)}")
    print(f"Part 1 = {d8_p2(input)}")