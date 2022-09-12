import re 
import sys
from typing import List

def p1_r_nice(word: str) -> bool | None:
    p1 = re.compile('(.*[aeiou]){3}')
    p2 = re.compile(r'(.)\1')
    p3 = re.compile(r'ab|cd|pq|xy')
    return p1.search(word) and p2.search(word) and not p3.search(word)

def p2_r_nice(word: str) -> bool | None:
    p1 = re.compile(r'(..).*\1')
    p2 = re.compile(r'(.).\1')
    return p1.search(word) and p2.search(word)  # type: ignore

def d5_p1_regex(input: List[str]) -> int:
    return sum(1 if p1_r_nice(word) else 0 for word in input)

def d5_p2_regex(input: List[str]) -> int:
    return sum(1 if p2_r_nice(word) else 0 for word in input)

if __name__ == '__main__':
    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day05\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]
    print(f'Part1: Nice Strings = {d5_p1_regex(input)}')
    print(f'Part2: Nice Strings = {d5_p2_regex(input)}')
    
