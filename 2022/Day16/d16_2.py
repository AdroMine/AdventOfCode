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
    
max_flow = sum(x for x in rates.values())
dp = {}

# Part 2
def max_rate(time, on_off, e_pos, h_pos):
    if time <= 0: 
        return 0

    key = (time, e_pos, h_pos, tuple(on_off))

    if key in dp:
        return dp[key]

    mp = 0
    press = sum(rates[x] for x in on_off)
    if(press >= max_flow):
        return press * time

    # Elephant moves and human switches on 
    if time > 0 and not h_pos in on_off and rates[h_pos] > 0:
        new_on_off = set(on_off)
        new_on_off.add(h_pos)
        for ev in tunnels[e_pos]:
            mp = max(mp, press + max_rate(time-1, new_on_off, ev, h_pos))

    # elephant switches on, human moves
    if time > 0 and not e_pos in on_off and rates[e_pos] > 0:
        new_on_off = set(on_off)
        new_on_off.add(e_pos)
        for hv in tunnels[h_pos]:
            mp = max(mp, press + max_rate(time-1, new_on_off, e_pos, hv))

    # both move
    if time > 0:
        for hv in tunnels[h_pos]:
            for ev in tunnels[e_pos]:
                mp = max(mp, press + max_rate(time-1, on_off, ev, hv))

    # both switch on
    if time > 0 and not e_pos in on_off and not h_pos in on_off and rates[h_pos] > 0 and rates[e_pos] > 0 and e_pos != h_pos:
        new_on_off = set(on_off)
        new_on_off.add(h_pos)
        new_on_off.add(e_pos)
        mp = max(mp, press + max_rate(time - 1, new_on_off, e_pos, h_pos))

    if(len(dp) % 10000 == 0):
        print(len(dp))
    dp[key] = mp

    return mp

part2 = max_rate(26, set(), 'AA', 'AA')
print(part2)



