# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
all_spells = [
    # cost, dmg, hp, turn, eff_index
    [53,  4, 0, 0, None],   # magic missile
    [73,  2, 2, 0, None],   # drain
    [173, 0, 0, 6, 0],      # poison
    [113, 0, 0, 6, 1],      # shield 
    [229, 0, 0, 5, 2]       # recharge
]
from functools import lru_cache

@lru_cache(None)
def best_path(mhp: int, bhp: int, mana: int, active_effects: tuple, used: int, hero_turn: bool, part2):
    bdmg = 9
    armour = 0
    global best_cost 

    # active spells = [0, 0, 0] -> poison, shield recharge
    if active_effects[0] > 0: # poison
        bhp -= 3
    if active_effects[1] > 0: # shield
        armour = 7
    if active_effects[2] > 0: # recharge
        mana += 101
    new_active_spells = [max(0, x - 1) for x in list(active_effects)]
    if bhp <= 0:
        best_cost = min(best_cost, used)
        return True
    if used > best_cost:
        return False
    
    if not hero_turn:
        mhp -= max(1, bdmg - armour)
        if mhp <= 0:
            return False
        best_path(mhp, bhp, mana, tuple(new_active_spells), used, not hero_turn, part2)
    else:
        if part2:
            mhp -= 1
            if mhp <= 0:
                return False
        for spell in all_spells:
            if spell[0] > mana or (spell[-1] is not None and new_active_spells[spell[-1]] > 0):
                continue
            cost = spell[0]
            nas = new_active_spells.copy()
            if spell[-1] is None: # not effect
                pass
            else: 
                nas[spell[-1]] = spell[-2]
            best_path(mhp + spell[2], bhp - spell[1], mana - cost, tuple(nas), used + cost, not hero_turn, part2)
        return False
    return False
            

if __name__ == '__main__':

    # in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day22\\input.txt'
    # input = [line.strip() for line in open(in_file).readlines()]
    boss = {'hp': 58, 'dmg': 9}
    hero = {'hp': 50, 'mana': 500, 'dmg': 0, 'arm': 0, 'effects_name': [], 'effects': []}
    best_cost = 100000000000
    best_path(50, 58, 500, (0,0,0), 0, True, False)
    print(f"Part 1 = {best_cost}")
        
    best_path.cache_clear()
    best_cost = 100000000000
    best_path(50, 58, 500, (0,0,0), 0, True, part2 = True)
    print(f"Part 2 = {best_cost}")
