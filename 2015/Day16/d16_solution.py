import sys
from typing import List, Dict
from itertools import compress
import re 


def parse_input(input: List[str]) -> List[Dict]:
    r = re.compile(r"(\w+): (-?\d+)") 
    return [{prop: int(val) for prop, val in r.findall(line)} for line in input]


def find_sue_p1(input: List[Dict[str, int]], target: Dict[str, int]) -> List[int]:
    # check if each aunt is a subset of target
    res = [aunt.items() <= target.items() for aunt in input]
    # return the index+1 of those which are true
    return list(compress(range(1, len(input) + 1), res))


def find_sue_p2(input, target):
    possible = []
    f_list = {'cats': int.__le__, 
              'trees': int.__le__, 
              'pomeranians': int.__ge__,
              'goldfish': int.__ge__,
    }
    special = ['cats', 'trees', 'pomeranians', 'goldfish']
    for i,aunt in enumerate(input):
        res = True
        for k in aunt:
            f = f_list[k] if k in special else int.__ne__
            if f(aunt[k], target[k]):
                res = False
                break
        if res:
            possible.append(i + 1)
    return possible


if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day16\\input.txt'

    input = [line.strip() for line in open(in_file).readlines()]
    pinput = parse_input(input)

    tgt_sue = """
        children: 3
        cats: 7
        samoyeds: 2
        pomeranians: 3
        akitas: 0
        vizslas: 0
        goldfish: 5
        trees: 3
        cars: 2
        perfumes: 1
    """
    tgt_sue = {name.strip(): int(value) for name,value in (line.split(": ") for line in tgt_sue.strip().split("\n"))}
    
    print(f"Part 1 = {find_sue_p1(pinput, tgt_sue)}")
    print(f"Part 2 = {find_sue_p2(pinput, tgt_sue)}")
