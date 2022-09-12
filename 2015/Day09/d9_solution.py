import sys
from typing import List, Tuple
from itertools import permutations
from collections import defaultdict

class Graph:
    def __init__(self, input: List[List[str]]):
        """
        Input is a list of lists, with each sublist containing:
        [source, target, distance]
        """
        self.nodes = set()
        self.distances = defaultdict(int)
        # create distance matrix
        for src, tgt, dist in input:
            self.nodes.add(src)
            self.nodes.add(tgt)
            self.distances[(src,tgt)] = int(dist)
            self.distances[(tgt,src)] = int(dist)

    def path_wt2(self, path: Tuple[str]) -> float:
        """
        Compute the cost of a path from start to end, visiting nodes in the
        given order in path
        """
        # from 0 to N-1 and 1 to N, essentially find distance from one point to next
        return sum(self.distances[(x,y)] for x,y in zip(path, path[1:]))
                
    def min_max_paths(self):
        costs = [self.path_wt2(path) for path in permutations(self.nodes)]
        return [min(costs), max(costs)]
        
        
    
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day09\\input.txt'

    # read input, split on x
    input = [line.strip().split()[::2] for line in open(in_file).readlines()]

    G = Graph(input)
    res = G.min_max_paths()

    print(f"Part 1 = {res[0]}")
    print(f"Part 2 = {res[1]}")
