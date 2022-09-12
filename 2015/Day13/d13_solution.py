import sys
from typing import List, Dict, Tuple
from collections import defaultdict
import re 
from itertools import permutations


def parse_input(input: List[str]) -> Dict[str, Dict]:
    output = defaultdict(dict)
    r = re.compile("[+\-]?\\d+")
    for line in input:
        l = line.split()
        p1, p2 = l[0], l[-1][:-1]
        num = int(r.search(line).group(0))
        num = -1 * num if 'lose' in line else num
        output[p1][p2] = num
    return output


def all_arrangements(people):
    """
    Given a list of people generate all seating arrangements
    Need to keep in mind that since we have a circular table, 
    so many cyclic shifts are not different, i.e. Alice/Bob/Charles is same as
    Bob/Charles/Alice

    To this, we can fix the first person and then generate all permutations for
    the others
    """
    for perm in permutations(people[1:]):
        yield [people[0], *perm]


def arr_hap(arrangement: List, rules: Dict[str, Dict]) -> int:
    """
    Calculate the happiness of a given arrangement of people
    """
    # since circular, add first to end as well
    arrangement.append(arrangement[0])
    return sum(rules[p1][p2] + rules[p2][p1] for p1, p2 in zip(arrangement, arrangement[1:]))
    
        
def best_arr(rules: Dict) -> int:
    """
    Find the best seating arrangement for a given list of people
    """
    people = [*rules.keys()]
    happiness = [arr_hap(list(arr), rules) for arr in all_arrangements(people)]
    return max(happiness)


if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day13\\input.txt'

    input = [line.strip() for line in open(in_file).readlines()]
    rules = parse_input(input)

    print(f"Part1 = {best_arr(rules)}")

    # add me
    rules['me'] = {}
    for k in rules.keys():
        rules[k]['me'] = 0
        rules['me'][k] = 0
    
    print(f"Part2 = {best_arr(rules)}")
    