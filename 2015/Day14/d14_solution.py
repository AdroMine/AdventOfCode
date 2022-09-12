import sys
from typing import List, Dict, Tuple
from collections import defaultdict
import re 


def parse_input(input: List[str]) -> List[Tuple[int, int, int]]:
    """
    extract the speed, move time and rest time and convert to int and then
    return as a tuple for each line
    """
    r = re.compile("[+\-]?\\d+")
    return  [tuple(map(int, r.findall(x))) for x in input]

def dist(reindeer: Tuple[int, int, int], time:int = 2503) -> int:
    """
    Find out distance travelled by a reindeer for a given time duration
    """
    speed, run, rest = reindeer 
    d = (time // (run + rest)) * speed * run
    d += speed * min(time % (run+rest), run)
    return d 

def max_distance_travelled(input: List[Tuple[int, int, int]], time: int = 2503) -> int:
    return max([dist(reindeer, time) for reindeer in input])


def max_ind(l: List) -> List[int]:
    """
    Find indexes of max in a list of integers
    """
    a = max(l)
    return [i for i,j in enumerate(l) if j == a]

def dist_points(reindeers: List[Tuple[int, int, int]], time: int = 2503) -> int:
    """
    Find scores for reindeers at a given time and return the max points
    """
    scores = [0] * len(reindeers)
    for t in range(1, time + 1):
        lead = max_ind([dist(r, t) for r in reindeers])
        for k in lead:
            scores[k] += 1
    return max(scores)


if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day14\\input.txt'

    input = [line.strip() for line in open(in_file).readlines()]

    pinput = parse_input(input)

    print(f"Part 1 = {max_distance_travelled(pinput)}")
    print(f"Part 2 = {dist_points(pinput)}")