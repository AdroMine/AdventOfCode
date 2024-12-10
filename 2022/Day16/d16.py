import re 
from collections import defaultdict
from itertools import product

input = open('input.txt').read().strip().split('\n')

tunnels = {}
rates = {}

graph = []

# Valve XG has flow rate=0; tunnels lead to valves CR, OH
r = re.compile('Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)$')
for line in input:
    valve, rate, nxt = r.findall(line)[0]
    tunnels[valve] = nxt.split(', ')
    if rate != '0':
        rates[valve] = int(rate)
   

R = [rates[v] for v in V]
for i,v in enumerate(V):
    for k in tunnels[v]:
        j = V.index(k)
        graph[i, j] = 1

# precompute distances floyd-warshall
for k, i, j in product(V, V, V):
    graph[i, j] = min(graph[i,j], graph[i,k] + graph[k, j])


open_valves = [i for i, v in enumerate(R) if v > 0]
ids = {v: 1<<i for i,v in enumerate(R)}

max_flow = sum(R.values())

# Part 1
dp = {}
def max_rate2(time, cur_pos, on_off, other_players):
    if time <= 0: 
        if other_players > 0:
            return max_rate2(26, 0, tuple(on_off), other_players - 1)
        else:
            return 0

    key = (time, cur_pos, on_off, other_players)

    if key in dp:
        return dp[key]

    mp = 0
    press = sum(rates[x] for x in on_off)
    if(press >= max_flow):
        return press * time

    if time > 0 and not on_off[cur_pos] and R[cur_pos] > 0:
            new_on_off = on_off.copy()
            new_on_off[cur_pos] = True
            mp = max(mp, press + max_rate2(time - 1, cur_pos, new_on_off, other_players))
    if time > 0:
        for nxt_pos in open_valves:
            mp = max(mp, press + max_rate2(time - 1, nxt_pos, on_off, other_players))

    if(len(dp) % 10000 == 0):
        print(len(dp))
    dp[key] = mp

    return mp

full_on_off = 0

part1 = max_rate(30, 0, full_on_off, 0)
print(part1)

# part2 = max_rate(26, 0, set(), 1)
# print(part2)


# import re 
# lines = [re.split('[\\s=;,]+', x) for x in open('input.txt').read().splitlines()]
# tunnels = {x[1]: set(x[10:]) for x in lines}
# rates = {x[1]: int(x[5]) for x in lines if int(x[5]) != 0}
# ids = {x: 1<<i for i, x in enumerate(rates)}
# dists = {x: {y: 1 if y in tunnels[x] else float('+inf') for y in tunnels} for x in tunnels}
# for k in dists:
#     for i in dists:
#         for j in dists:
#             dists[i][j] = min(dists[i][j], dists[i][k] + dists[k][j])

import sys, re
lines = [re.split('[\\s=;,]+', x) for x in open('input.txt').read().splitlines()]
tunnels = {x[1]: set(x[10:]) for x in lines}
rates = {x[1]: int(x[5]) for x in lines if int(x[5]) != 0}
ids = {x: 1<<i for i, x in enumerate(rates)}
dists = {x: {y: 1 if y in tunnels[x] else float('+inf') for y in tunnels} for x in tunnels}
for k in dists:
    for i in dists:
        for j in dists:
            dists[i][j] = min(dists[i][j], dists[i][k]+dists[k][j])

def max_rate(pos, time, on_off, press, dp):
    dp[on_off] = max(dp.get(on_off, 0), press)
    for nxt in rates:
        new_time = time - dists[pos][nxt] - 1
        if ids[nxt] & on_off or new_time <= 0: continue
        max_rate(nxt, new_time, on_off | ids[nxt], press + new_time * rates[nxt], dp)
    return dp

total1 = max(max_rate('AA', 30, 0, 0, {}).values())
visited2 = max_rate('AA', 26, 0, 0, {})
total2 = max(v1+v2 for k1, v1 in visited2.items() 
                   for k2, v2 in visited2.items() if not k1 & k2)
print(total1, total2)