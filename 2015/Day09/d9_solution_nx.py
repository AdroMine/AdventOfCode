import sys
import networkx as nx
import networkx.algorithms.approximation as nx_app
from networkx.classes.function import path_weight
from itertools import permutations


if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day09\\input.txt'

    # read input, split on x
    input = [line.strip().split()[::2] for line in open(in_file).readlines()]

    G2 = nx.Graph()
    [G2.add_edge(src, tgt, weight = int(dist)) for src, tgt, dist in input]
    
    paths = []
    true_path = None
    res = float('infinity')
    costs = [path_weight(G2,path, 'weight') for path in permutations(G2.nodes)]

    print(f"Part 1 answer = {min(costs)}")
    print(f"Part 2 answer = {max(costs)}")
            