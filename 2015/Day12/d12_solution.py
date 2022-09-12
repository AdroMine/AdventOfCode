import sys
from typing import List, Dict
import json
        

def add_nums(input: List | Dict | str | int, part2:bool = False) -> int:
    res = 0
    if isinstance(input, dict):
        if part2 and 'red' in input.values():
            pass
        else:
            res += sum(add_nums(it, part2) for _, it in input.items())
    elif isinstance(input, int):
        return input
    elif isinstance(input, str):
        return 0
    elif isinstance(input, list):
        for item in input:
            res += add_nums(item, part2)
    return res

def add_nums2(input, part2 = False):
    res = 0
    match input:
        case int():
            return input
        case str():
            return 0
        case list():
            res += sum(add_nums(item, part2) for item in input) 
        case dict():
            if part2 and 'red' in input.values():
                pass
            else: 
                res += sum(add_nums(item, part2) for key,item in input.items())
    return res
    
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day12\\input.txt'

    input = json.load(open(in_file))

    # print(f"Part1 = {add_nums(input)}")
    # print(f"Part2 = {add_nums(input, part2 = True)}")

    print(f"Part1 = {add_nums2(input)}")
    print(f"Part2 = {add_nums2(input, part2 = True)}")