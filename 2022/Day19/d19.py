import re
import sys
from collections import deque

in_file = sys.argv[1] if len(sys.argv) > 1 else r'2022\Day19\input.txt'

# in_file = 'sample.txt'
reg = re.compile('\d+')

input = open(in_file).read().strip().split('\n')
blueprints = [[*map(int, reg.findall(x))] for x in input]

def next_states(blueprint, state):
    o1, o2, o3, o4, r1, r2, r3, r4, t = state
    _, or1, oc1, obc1, obc2, ogc1, ogc2 = blueprint

    max_ore = max(or1, oc1, obc1, ogc1)

    # one geode robo
    if o1 >= ogc1 and o3 >= ogc2:
        yield (o1-ogc1+r1, o2+r2, o3-ogc2+r3, o4+r4, r1, r2, r3, r4+1, t-1)
        return 

    # no new robo
    yield (o1+r1, o2+r2, o3+r3, o4+r4, r1, r2, r3, r4, t-1)

    # one ore robo, if haven't exceed max ores that are needed at any step
    if o1 >= or1 and r1 < max_ore:
        yield (o1-or1+r1, o2+r2, o3+r3, o4+r4, r1 + 1, r2, r3, r4, t-1)

    # one clay robo
    if o1 >= oc1  and r2 < obc2:
        yield (o1-oc1+r1, o2+r2, o3+r3, o4+r4, r1, r2 + 1, r3, r4, t-1)

    # one obsidian robo
    if o1 >= obc1 and o2 >= obc2 and r3 < ogc2:
        yield (o1-obc1+r1, o2-obc2 + r2, o3+r3, o4+r4, r1, r2, r3+1, r4, t-1)



def max_geodes(blueprint, time):
    _, ore_c, clay_c, obs_co, obs_cc, geo_co, geo_cb = blueprint 
    # bfs
    # state 9 values - 4 ore amounts + 4 robo counts + time (order = ore, clay, obsidian, geode)
    start = (0, 0, 0, 0, 1, 0, 0, 0, time)
    Q = deque([start])
    seen = set()
    
    best = 0
    while Q:
        state = Q.popleft()
        ore, clay, obs, geo, rb1, rb2, rb3, rb4, t = state 
        best = max(best, geo)
        if t == 0 or t*geo + max((t-2) *(t-1)//2, 0) < best: 
            continue

        # if(len(seen) % 100000 == 0):
        #     print(len(seen))
        
        mc_ore = max(ore_c, clay_c, obs_co, geo_co)
        
        # if there are more ores than can be consumed, those are wastes, so we can cap them
        # this allows more states to be SEEN. 
        # max ores that can be consumed = max_ore in any step can be consumed for robot creation
        # times time left minus any ores that will be created in remaining time by existing robots
        ore  = min(ore , t * mc_ore - rb1 * (t-1))
        clay = min(clay, t * obs_cc - rb2 * (t-1))
        obs  = min(obs , t * geo_cb - rb3 * (t-1))

        state = (ore, clay, obs, geo, rb1, rb2, rb3, rb4, t)
        if state in seen:
            continue
        seen.add(state)

        for item in next_states(blueprint, state):
            Q.append(item)

    return best


p1 = 0
p2 = 1
for i, blueprint in enumerate(blueprints):
    sp = max_geodes(blueprint, 24)
    print(sp)
    score = (i+1) * sp
    p1 += score
    if i < 3:
        score2 = max_geodes(blueprint, 32)
        p2 *= score2

print(f"Part1 = {p1}")
print(f"Part2 = {p2}")
        
    
def f(inp):
    yield 1
    if inp:
        yield 10
        return 
    yield 2
    yield 3
    yield 4
    