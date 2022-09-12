from collections import defaultdict
import sys
from typing import List, Dict
from copy import deepcopy

def lights_count(input: List[str], steps:int = 100, part2: bool = False) -> int:
    # set containing coordinates for points that are on , always only keep the coordinates that are on
    lights = {(r,c) for r, line in enumerate(input) for c, char in enumerate(line) if char == '#'}
    corners = {(0,0), (0, 99), (99, 0), (99, 99)}

    # given a pair of coordinate, find how many neighbours are on
    neighbours = lambda r,c: sum((dr, dc) in lights  # return set inclusion (true/false)
                                 for dr in [r - 1, r, r + 1] 
                                 for dc in [c-1, c, c + 1] 
                                 if (dr, dc) != (r,c))
    
    for s in range(steps):
        # print(s)
        lights = {(r,c) for r in range(100) for c in range(100)
                  if (r,c) in lights and 2 <= neighbours(r,c) <= 3
                  or (r,c) not in lights and neighbours(r,c) == 3}
        if part2:
            lights = lights | corners
        
    return len(lights)



def print_grid(input):
    for line in input:
        print("".join(line))
        
    
        
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day18\\input.txt'

    input = [line.strip() for line in open(in_file).readlines()]

    # Part 1 
    print(f"Part 1 = {lights_count(input, 100)}")

    # Part 2 
    print(f"Part 2 = {lights_count(input, 100, True)}")


# This is slow
# def lights_animate(input: List[List], steps: int, part2:bool = False) -> int:
#     """
#     A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
#     A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
#     """
#     R = len(input)
#     C = len(input[0])
#     for i in range(steps):
#         print(i)
#         nxt = deepcopy(input)
#         for r in range(R):
#             for c in range(C):
#                 surr = 0
#                 for dr in [-1, 0, 1]:
#                     for dc in [-1, 0, 1]:
#                         if r + dr in range(R) and c + dc in range(C) and input[r + dr][c + dc] == '#' and not (dr == 0 and dc == 0):
#                             surr += 1
#                 if input[r][c] == '#' and surr not in [2,3]:
#                     nxt[r][c] = '.'
#                 elif input[r][c] == '.' and surr == 3:
#                     nxt[r][c] = '#'
#         if part2:
#             nxt[0][0] = '#'
#             nxt[0][C - 1] = '#'
#             nxt[R - 1][0] = '#'
#             nxt[R - 1][C - 1] = '#'
#         input = nxt
#     return sum(1 for line in input for x in line if x == '#')
