from collections import defaultdict
from functools import lru_cache
import sys
from typing import Match
import re 


def read_input(in_file: str) -> tuple:
    mapping, molecule = open(in_file).read().split("\n\n")
    mapping = [line.split(' => ') for line in mapping.split("\n")]
    molecule = molecule.strip()

    output = defaultdict(set)
    for item in mapping:
        output[item[0]].add(item[1])
    rev_map = {y[::-1]: x[::-1] for x,y in mapping}
    return output, molecule, rev_map
        
    
def n_mols(input: str, mapping: dict[str, set]) -> int:
    res_str = set()
    for key in mapping:
        for m in re.finditer(key, input):
            for repl in mapping[m.group(0)]:
                res_str.add(molecule[:m.start()] + repl + molecule[m.end():])
    return len(res_str)


def gen_molecule_steps(molecule: str, rev_map) -> int:
    molecule = molecule[::-1]
    count = 0
    r = re.compile('|'.join(rev_map.keys()))

    replace = lambda m: rev_map[m.group()]
    
    while molecule != 'e':
        molecule = r.sub(replace, molecule, 1)
        count += 1
        
    return count
        

        
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day19\\input.txt'
    # in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day19\\sample.txt'
    mapping, molecule, rev_mapping = read_input(in_file)

    print(f"Part 1 = {n_mols(molecule, mapping)}")
    print(f"Part 2 = {gen_molecule_steps(molecule, rev_mapping)}")
