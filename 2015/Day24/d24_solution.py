import sys 
from itertools import combinations
from math import prod

def filter_list(orig, remove_elem):
    return [elem for elem in orig if elem not in remove_elem]
    # return list(filter(lambda elem: elem not in remove_elem, orig))


def qe(partitions: list[list[int]]):
    return min(prod(x) for x in partitions)
    

def find_group(group, left: list, goal) -> list[int] | None:
    """
    Given a goal and existing group of numbers, find which numbers to 
    add from `left` so that sum of elements in group reaches goal

    Recursive implementation. If left is in decreasing order, we find 
    the least number of elements required to reach goal
    """
    if sum(group) == goal:
        return group
    
    # iterate through each possible element
    for i in range(len(left)):
        elem = left[i]
        if sum(group) + elem > goal:
            continue
        # is it possible to reach goal after adding this element?
        new_group = find_group(group + [elem], left[0:i] + left[i+1:], goal)
        if new_group:
            return new_group
    return None


def find_all_partitions(weights, n, goal, first = []) -> list[list[int]]:
    """ 
    Given a set of weights, and a required number of partitions and some goal
    divide weights into n partitions such that sum of each partition is equal to
    goal
    If we already have first partition, then only find the rest n-1 partitions
    """
    partitions = [[]] * n
    left = weights
    loop = range(0, n - 1)
    if first:
        partitions[0] = first
        loop = range(1, n - 1)
        left = filter_list(weights, first)
    for i in loop:
        res = find_group([], left, goal)
        if not res: 
            break
        partitions[i] = res
        left = filter_list(left, partitions[i])
    partitions[-1] = left
    return partitions 



def gen_configs(weights: list[int], n_groups = 3) -> tuple[int | None, list]:
    """ 
    Given a set of weights and number of reqd partitions, 
    divide weights into n_groups partitions of equal weight, 
    such that one group has the least possible number of weights as well
    as the least product of all items within it
    """
    total_weight = sum(weights)
    per_group = total_weight // n_groups 

    # first attempt for partitions by adding all the biggest weights to the first group
    partitions = find_all_partitions(weights, n_groups, per_group)
    
    if not all(partitions):
        print("No Partitions Found")
        return None, [None]

    # find quantle entanglement for group with least elements
    min_qe = qe(partitions)

    # find no of items in group with least elements
    min_length = len(min(partitions, key = len))

    while True:
        # generate all combinations of min length
        for comb in combinations(weights, min_length):
            if sum(comb) != per_group:
                continue
            # another possible combination that results in required sum
            # check if other groups can be formed?
            comb = list(comb)
            new_partitions = find_all_partitions(weights, n_groups, per_group, comb)
            if all(new_partitions):
                new_qe = qe(new_partitions)
                if new_qe < min_qe:
                    min_qe = new_qe
                    partitions = new_partitions
        # did we find a set of partition with even lesser amount of elements?
        # if yes repeat
        temp = len(min(partitions, key = len))
        if temp < min_length:
            min_length = temp
        else: 
            break
        
    return min_qe or False, partitions
    
    
# Another method 
# Just generate combinations of different lengths 1..2..3..
# for each such combination that has correct sum, check if other partitions can be formed
# if yes, find min QE for all correct combinations of such size 
# once we have found min QE for all combinations of certain length, no need to check further
def gen_config2(weights, n_groups):
    goal = sum(weights) // n_groups 
    
    res = 1000000000000
    found = False
    for k in range(1, len(weights)//n_groups):
        for comb in (x for x in combinations(weights, k) if sum(x) == goal):
            partitions = find_all_partitions(weights, n_groups, goal, comb)
            if all(partitions):
                found = True
                res = min(res, qe(partitions))
        if found:
            break
    return res
    

# for given input, we don't really need to check if other partitions can be
# formed, we can obtain answer in following way as well
# this condition might not be true for all user's inputs though
# we don't really get any noticeable speedup either
def gen_config3(weights, n_groups):
    goal = sum(weights) // n_groups 
    
    res = 1000000000000
    for k in range(1, len(weights)//n_groups):
        ans = min(prod(comb) if sum(comb) == goal else res for comb in combinations(weights, k))
        if ans < res:
            return ans
    return res    
    

if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day24\\input.txt'
    input = [int(line.strip()) for line in open(in_file).readlines()]

    input.sort(reverse = True)
    part1 = gen_configs(input, 3)
    print(f"Part 1: Min QE = {part1[0]}, partitions = {part1[1]}")
    part2 = gen_configs(input, 4)
    print(f"Part 2: Min QE = {part2[0]}, partitions = {part2[1]}")

    print(gen_config2(input, 3))
    print(gen_config2(input, 4))