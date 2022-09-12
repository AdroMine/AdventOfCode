import sys
from typing import List, DefaultDict
from collections import defaultdict
import re 

def parse_input(input: List[str]) -> List[str]:
    s = re.compile(r"(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)")
    output = []
    for line in input:
        inst, *coords = s.search(line).groups()
        coords = [int(x) for x in coords]
        output.append((inst, *coords))
    return output

def d6_p1(input) -> int:
    grid: DefaultDict = defaultdict(int)

    for inst, x1, y1, x2, y2 in input:
        for r in range(x1, x2+1):
            for c in range(y1, y2+1):
                match inst:
                    case 'toggle': 
                        grid[(r,c)] = 1 - grid[(r,c)]
                    case 'turn on':
                        grid[(r,c)] = 1
                    case 'turn off':
                        grid[(r,c)] = 0

    return sum(1 for x in grid.values() if x == 1)
    
    
def d6_p2(input) -> int:
    grid: DefaultDict = defaultdict(int)

    for inst, x1, y1, x2, y2 in input:
        for r in range(x1, x2+1):
            for c in range(y1, y2+1):
                match inst:
                    case 'toggle': 
                        grid[(r,c)] += 2
                    case 'turn on':
                        grid[(r,c)] += 1
                    case 'turn off':
                        if grid[(r,c)] > 0:
                            grid[(r,c)] -= 1

    return sum(grid.values())
    
    
if __name__ == '__main__':
    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day06\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]
    input2 = parse_input(input)

    p1 = d6_p1(input2)
    p2 = d6_p2(input2)
    
    
    print(f'Part1: Total Turned on lights = {(p1)}')
    print(f'Part2: Total Brightness = {(p2)}')

    input[0].rsplit(' ', 3)