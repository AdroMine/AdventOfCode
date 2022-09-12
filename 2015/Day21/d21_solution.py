import sys
import re
import math
from itertools import combinations

# read boss details
def read_boss(in_file: str) -> dict:
    input = [line.strip() for line in open(in_file).readlines()]
    return {'hp': int(input[0].split(": ")[1]),
            'dmg': int(input[1].split(": ")[1]),
            'arm': int(input[2].split(": ")[1]),
    }


def hero_wins(hero: dict[str, int], villain: dict[str, int]) -> bool:
    """
    Returns True if hero wins given hero & villain stats
    """
    dmh = max(1, hero['dmg'] - villain['arm'])
    dmv = max(1, villain['dmg'] - hero['arm'])

    villain_zero = math.ceil(villain['hp'] / dmh) # steps for villain to reach 0 health
    hero_zero = math.ceil(hero['hp'] / dmv)       # steps for hero to go down

    return villain_zero <= hero_zero



def min_max(shop: str, boss: dict) -> tuple[int, int]:
    weapons, armours, rings = open(shop).read().strip().split('\n\n')


    # for each, find numbers on line, convert to int, and remove empty lists
    # ignore first line
    weapons = [[*map(int, re.findall(r'(\d+)', line))] for line in weapons.split('\n')[1:]]
    armours = [[*map(int, re.findall(r'(\d+)', line))] for line in armours.split('\n')[1:]]
    # insert empty armour for optional armour
    armours.append([0,0,0])
    rings   = [[*map(int, re.findall(r'(\d+)', line)[1:])] for line in rings.split('\n')[1:]]

    # add two empty rings since we can have 0 rings as well (2 empty since we
    # will be taking two rings)
    rings.append([0,0,0])
    rings.append([0,0,0])

    hero_stats = {'hp': 100, 'dmg': 0, 'arm': 0}
    worst, best = 0, 10000
    for weapon in weapons:
        for armor in armours:
            for r1, r2 in combinations(rings, 2):
                cost = weapon[0] + armor[0] + r1[0] + r2[0]
                hero_stats['dmg'] = weapon[1] + r1[1] + r2[1]
                hero_stats['arm'] = armor[2] + r1[2] + r2[2]
                if hero_wins(hero_stats, boss):
                    best = min(best, cost)
                else:
                    worst = max(worst, cost)
                
    return best, worst


    

if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day21\\input.txt'
    # input = [line.strip() for line in open(in_file).readlines()]
    villain_stats = read_boss(in_file)

    shop = '2015\\Day21\\shop.txt'

    best, worst = min_max(shop, villain_stats)
    print(f"Part1 = {best}")
    print(f"Part2 = {worst}")
