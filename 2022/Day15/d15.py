import re 
def get_nums(line): return [int(d) for d in re.findall("(-?\d+)", line)]

def man_d(p1, p2): return abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])

dat = [get_nums(line) for line in open('input.txt').read().strip().split("\n")]
rads = {(a,b): man_d((a,b), (c,d)) for (a,b,c,d) in dat}

scanners = rads.keys()

ac, bc = set(), set()

for ((x,y),r) in rads.items():
    ac.add(y-x+r+1)
    ac.add(y-x-r-1)
    bc.add(x+y+r+1)
    bc.add(x+y-r-1)

bound = int(4e6)
print(len(ac))
print(len(bc))

for a in ac:
    for b in bc:
        p = ((b-a)//2, (a+b)//2)
        if all(0 < c < bound for c in p):
            if all(man_d(p, t) > rads[t] for t in scanners):
                print(int(4e6)*p[0]+p[1])




