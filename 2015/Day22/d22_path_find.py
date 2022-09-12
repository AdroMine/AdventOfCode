# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
from collections import namedtuple
from dataclasses import dataclass
from functools import reduce
from heapq import heappop, heappush
from itertools import count
from typing import Any, Iterator

Spell = namedtuple(typename    = 'BaseSpell',
                   field_names = 'name cost effect turns damage heal armour mana',
                   defaults    = [False, 0, 0, 0, 0, 0])

all_spells = (
    Spell('Magic Missile', 53, damage = 4),
    Spell('Drain', 73, damage = 2, heal = 2),
    Spell('Shield',113, effect = True, turns = 6, armour = 7),
    Spell('Poison', 173, effect = True, turns = 6, damage = 3),
    Spell('Recharge', 229, effect = True, turns = 5, mana = 101),
)
Effect = namedtuple('Effects', 'Poison Shield Recharge', defaults=[0, 0, 0])

@dataclass
class GameState():
    my_hp      : int
    my_mana    : int
    mana_spent : int
    boss_hp    : int
    boss_dmg   : int = 9
    effects    : Effect = Effect(0,0,0)
    spell_cast : str | None = None
    parent     : Any = None
    part2      : bool = False

    # for == and hash
    def __iter__(self) -> Iterator[int | Effect]:
        yield self.my_hp
        yield self.my_mana 
        yield self.mana_spent 
        yield self.boss_hp 
        yield self.effects

    def __eq__(self, other) -> bool:
        return (isinstance(other, GameState) and tuple(self) == tuple(other))
            
    def __hash__(self) -> int:
        return hash(tuple(self))

    def play_effects(self) -> tuple[int, int, int, Effect]:
        """ 
        Play effects, return boss hp, player armour and mana and new effects
        """
        bhp, armour, mana = self.boss_hp, 0, self.my_mana

        # play effects
        bhp -= 3 if self.effects.Poison else 0
        armour = 7 if self.effects.Shield else 0
        mana += 101 if self.effects.Recharge else 0

        # reduce timers
        new_effects = Effect(*[max(0, x - 1) for x in self.effects])

        return bhp, armour, mana, new_effects
        

    def boss_turn(self) -> None:
        """ 
        Play effects and then play boss turn
        """
        self.boss_hp, armour, self.my_mana, self.effects = self.play_effects()
        if self.boss_hp > 0:
            self.my_hp -= max(1, self.boss_dmg - armour)
    
    def spell_in_effect(self, spell: Spell, effects) -> bool:
        return spell.effect and (getattr(effects, spell.name) > 0)
    
    def get_path(self) -> Iterator[str | None]:
        if self.parent is None:
            return 
        yield from self.parent.get_path()
        yield self.spell_cast

            
    def new_states(self): # -> Iterator[GameState]
        """
        Play turn and see possible states where player doesn't lose
        first play effects, then find a new spell to play that can be played
        and doesn't result in player losing
        Create a new state for the result of playing this spell (so that we can
        cancel if this doesn't work) then play boss turn (including playing effects)
        """
        # Player turn first, first play effects
        bhp, _, mana, effects = self.play_effects()
        # find a spell
        for spell in all_spells:
            if spell.cost > mana or self.spell_in_effect(spell, effects):
                continue # no mana for spell or spell already in effect
            # create a new possible state
            new_state = GameState(my_hp      = self.my_hp - int(self.part2),
                                  my_mana    = mana - spell.cost, 
                                  mana_spent = self.mana_spent + spell.cost, 
                                  boss_hp    = bhp, 
                                  boss_dmg   = self.boss_dmg, 
                                  effects    = effects, 
                                  spell_cast = spell.name, 
                                  parent     = self, 
                                  part2      = self.part2)
            # play the spell in this new state
            if not spell.effect:
                new_state.my_hp += spell.heal
                new_state.boss_hp -= spell.damage
            else:
                # add new effect
                new_state.effects = effects._replace(**{spell.name: spell.turns})

            # play boss turn in new state
            new_state.boss_turn()
            # if player has not lost, consider this state as possible next move
            if new_state.my_hp > 0:
                yield new_state

                
# Find shortest path to goal
def find_min_path(start: GameState) -> GameState | None:
    # set of states to visit
    open_states = {start}

    # priority queue
    Q = [(0, 0, start)]  # priority  enter_id  item

    visited = set()      # already visited
    unique = count()     # unique id of when visited to handle ties in heapq

    # djikstra with priority Q
    while open_states: 
        current = heappop(Q)[-1]
        # reached end goal? Hero won?
        if current.boss_hp < 1:
            return current
        open_states.remove(current)
        visited.add(current)
        for state in current.new_states():
            if state in visited or state in open_states:
                continue
            open_states.add(state)
            heappush(Q, (state.mana_spent, next(unique), state))


if __name__ == "__main__":
    
    # Part 1
    init_state = GameState(my_hp = 50, my_mana = 500, mana_spent = 0, boss_hp = 58, boss_dmg = 9)

    # find shortest path to goal
    goal = find_min_path(init_state)
    if isinstance(goal, GameState):
        print(f"Part 1 = {goal.mana_spent} ; Path: ", end = "")
        print(*goal.get_path(), sep = ' -> ')
    else: 
        print("Fail")
    
    # Part 2
    init_state = GameState(my_hp = 50, my_mana = 500, mana_spent = 0, boss_hp = 58, boss_dmg = 9, part2 = True)
    goal = find_min_path(init_state)
    if isinstance(goal, GameState):
        print(f"Part 2 = {goal.mana_spent} ; Path: ", end = "")
        print(*goal.get_path(), sep = ' -> ')
    else: 
        print("Fail")
