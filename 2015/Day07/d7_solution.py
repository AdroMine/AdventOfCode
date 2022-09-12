import sys
from typing import List, Dict
import re 
from functools import lru_cache

int_reg = re.compile(r'^[+-]?\d+$')
def is_int(s: str) -> bool:
    return int_reg.match(s) is not None

def parse_input(input: List[str]) -> Dict[str, str]:
    output = {}
    for line in input:
        op, out = line.split(' -> ')
        output[out] = op
    
    return output


@lru_cache(None)
def bitgame(k: str):
    """
    Recursive function to perform bitwise operations
    If received key is integer, return it (as integer)
    Else perform operation
    """
    if is_int(k):
        return int(k)
    match D[k].split(' '):
        case [op1, 'AND', op2]:
            return bitgame(op1) & bitgame(op2)
        case [op1, 'OR', op2]:
            return bitgame( op1) | bitgame(op2)
        case [op1, 'LSHIFT', op2]:
            return bitgame(op1) << bitgame(op2)
        case [op1, 'RSHIFT', op2]:
            return bitgame(op1) >> bitgame(op2)
        case ['NOT', op2]:
            return (1 << 16) - 1 - bitgame(op2)
        case [op1]:
            return bitgame(op1)

    
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day07\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]
    D = parse_input(input)
    

    # Part 1 
    p1 = bitgame('a')
    print(f'Part1: {(p1)}')

    # Part 2 

    # Set new value for b
    D['b'] = str(p1)

    # clear cache since previous cache is now useless
    bitgame.cache_clear()

    p2 = bitgame('a')

    print(f"Part 2 : {p2}")