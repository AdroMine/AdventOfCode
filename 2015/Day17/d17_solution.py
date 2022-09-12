from collections import defaultdict
import sys
from typing import List, Dict


def min_pack(containers: List[int], left: int, contains:int = 0) -> Dict:
    """
    Given a set of containers and amount to fill, find the number of ways to fill it
    along with the number of containers required to fill it
    """
    if left == 0:
        return {contains: 1}
    composition = defaultdict(int)
    for i, container in enumerate(containers):
        if container > left:
            continue
        res = min_pack(containers[i+1:], left - container, contains + 1)
        for pos in res:
            composition[pos] += res[pos]
    return composition
    
        
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day17\\input.txt'

    input = [int(line.strip()) for line in open(in_file).readlines()]

    # fit 150 litres

    # Part 1 
    res = min_pack(input, 150)
    print(f"Part 1 = {sum(x for x in res.values())}")

    # Part 2 
    print(f"Part 2 = {res[min(res)]}")
