import sys
from typing import List, DefaultDict
from collections import defaultdict
import re 
import numpy as np

def parse_input(input: List[str]) -> List[str]:
    s = re.compile(r"(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)")
    output = []
    for line in input:
        inst, *coords = s.search(line).groups()
        coords = [int(x) for x in coords]
        output.append((inst, *coords))
    return output

def d6_p1_nm(input) -> int:
    grid = np.zeros((1000, 1000), bool)
    for inst, x1, y1, x2, y2 in input:
        r = slice(x1, x2+1)
        c = slice(y1, y2+1)
        if inst == 'toggle':
            grid[r, c] ^= True
        elif inst == 'turn on':
            grid[r, c] = True
        elif inst == 'turn off':
            grid[r, c] = False

    return np.sum(grid)
    
def d6_p2_nm(input) -> int:
    grid = np.zeros((1000, 1000), int)
    for inst, x1, y1, x2, y2 in input:
        r = slice(x1, x2+1)
        c = slice(y1, y2+1)
        if inst == 'toggle':
            grid[r, c] += 2
        elif inst == 'turn on':
            grid[r, c] += 1
        elif inst == 'turn off':
            grid[r, c] -= 1
            grid[grid < 0] = 0

    return np.sum(grid)
    
    
if __name__ == '__main__':
    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day06\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]
    input2 = parse_input(input)

    p1 = d6_p1_nm(input2)
    p2 = d6_p2_nm(input2)
    
    
    print(f'Part1: Total Turned on lights = {(p1)}')
    print(f'Part2: Total Brightness = {(p2)}')