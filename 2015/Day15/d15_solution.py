import sys
from typing import List, Dict, Tuple
from collections import Counter
from itertools import combinations_with_replacement
import re 
from math import prod

def parse_input(input: List[str]) -> Dict:
    r = re.compile(r"(\w+) (-?\d+)") # search for 'property number'
    output = {}
    for line in input:
        name, value = line.split(": ")
        output[name] = {prop: int(val) for prop, val in r.findall(value)}
    return output 
    # could also be writen as the following one-liner
    # return {name: {prop: int(val) for prop, val in r.findall(value)} for name, value in (line.split(": ") for line in input)}


def food_score(ingredients: Dict[str, Dict[str, int]], comb: Tuple[str], part2:bool = False) -> int:
    """
    Generate food score total for a given combination
    Param Ingredients: A dictionary of ingredients, where each member is itself
    a dictionary with score for different properties
    Param comb: A given combination of ingredients. of the form (I1, I2, I1, I2, I3, I4, I1)
    Param part2: bool, Part2 or Part1
    """
    counts = Counter(comb)
    properties = ['capacity', 'durability', 'flavor', 'texture', 'calories']

    # compute score for each property
    score = {prop: sum(counts[ing] * ingredients[ing][prop] for ing in counts) for prop in properties}

    # compute total score for food
    res = prod(max(0, score[prop]) for prop in properties[:-1])

    # return score (0 if doing part2 and calories count is not 500)
    return 0 if part2 and score['calories'] != 500 else res


def find_best_score(ingredients, part2 = False):
    possible = combinations_with_replacement(ingredients.keys(), r = 100)
    return max(food_score(ingredients, comb, part2) for comb in possible)


if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day15\\input.txt'

    input = [line.strip() for line in open(in_file).readlines()]

    pinput = parse_input(input)

    print(f"Part 1 = {find_best_score(pinput, False)}")
    print(f"Part 2 = {find_best_score(pinput, True)}")
