import re 

input = open('input.txt').read().strip().split('\n')

tunnels = {}
rates = {}

# Valve XG has flow rate=0; tunnels lead to valves CR, OH
r = re.compile('Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)$')
for line in input:
    valve, rate, nxt = r.findall(line)[0]
    tunnels[valve] = nxt.split(', ')
    rates[valve] = int(rate)
    

from collections import defaultdict


def max_rate2(rates, tunnels):

    states = [(1, 'AA', 'AA', 0, set())]
    seen = {}
    best = 0

    max_flow = sum(x for x in rates.values())

    while states:
        time, hpos, epos, score, opened_s = states.pop()
        opened = {x for x in opened_s}

        key = (time, hpos, epos)
        if key in seen:
            if seen[key] >= score:
                continue

        seen[key] = score
        if(len(seen) % 10000 == 0):
            print(len(seen))

        if time == 26:
            best = max(best, score)


        press = sum(rates[x] for x in opened)
        if press >= max_flow:
            new_score = score + current_flow
            while time < 25:
                time += 1
                new_score += press

            new_state = (time + 1, hpos, epos, new_score, tuple(opened))
            continue

        # case 1: human opens a valve
        if rates[hpos] > 0 and hpos not in opened:
            opened.add(hpos)

            # elephant opens a valve:
            if rates[epos] > 0 and epos not in opened:
                opened.add(epos)
                new_score = score + sum(rates[x] for x in opened)
                new_state = (time + 1, hpos, epos, new_score, tuple(opened))
                states.append(new_state)

                opened.discard(epos)

            # elephant moves
            new_score = score + sum(rates[x] for x in opened)
            for ev in tunnels[epos]:
                new_state = (time + 1, epos, ev, new_score, tuple(opened))

            opened.discard(hpos)

        # case 2: human moves
        for hv in tunnels[hpos]:

            # elephant opens a valve
            if rates[epos] > 0 and epos not in opened:
                opened.add(epos)
                new_score = score + sum(rates[x] for x in opened)
                new_state = (time + 1, hv, epos, new_score, tuple(opened))
                
                states.append(new_state)
                opened.discard(epos)

            # elephant also moves
            new_score = score + sum(rates[x] for x in opened)
            for ev in tunnels[epos]:
                new_state = (time + 1, hv, ev, new_score, tuple(opened))
                states.append(new_state)

    return best

print(max_rate2(rates, tunnels))

