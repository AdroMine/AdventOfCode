import sys
from collections import defaultdict

dir = {
    '>' : (1, 0),
    '<' : (-1, 0), 
    'v' : (0, -1), 
    '^' : (0, 1)
}

# Part 1
def d3part1(input: str) -> int:
    
    grid = defaultdict(int)

    R,C  = 0,0

    grid[(R, C)] = 1

    for inst in input:
        r, c = dir[inst]
        R += r
        C += c
        grid[(R,C)] += 1
        
    return len(grid)
    

# Part 2 

def d3part2(input: str) -> int:
    
    R1,C1 = 0,0 # santa start point
    R2,C2 = 0,0 # robo santa start point

    houses = defaultdict(int)
    houses[(0,0)] = 2

    for in1, in2 in zip(*[iter(input)]*2):  # type: ignore
        # Santa
        r, c = dir[in1]
        R1 += r
        C1 += c
        houses[(R1,C1)] += 1

        r, c = dir[in2]
        R2 += r
        C2 += c
        houses[(R2,C2)] += 1
        
    return len(houses)
    

if __name__ == '__main__':
    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day03\\input.txt'

    # read input, split on x
    input = open(in_file).readline()
    print(f'Part1: Houses visited = {d3part1(input)}')
    print(f'Part2: Houses visited = {d3part2(input)}')