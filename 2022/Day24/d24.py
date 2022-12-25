import sys
from collections import deque

in_file = sys.argv[1] if len(sys.argv) > 1 else r'2022\Day24\input.txt'

input = [x.strip() for x in open(in_file).readlines()]

R = len(input)
C = len(input[0])

rr = 0
cc = 0
for cc in range(C):
    if input[rr][cc] == '.':
        break

all_winds = {}
for t in range(2000):
    cur_winds = set()
    for r in range(R):
        for c in range(C):
            if input[r][c] == '>':
                cur_winds.add((r, (c - 1+ t) % (C-2) + 1))
            elif input[r][c] == '<':
                cur_winds.add((r, (c - 1 - t) % (C-2) + 1))
            elif input[r][c] == '^':
                cur_winds.add(((r - 1 - t) % (R-2) + 1, c))
            elif input[r][c] == 'v':
                cur_winds.add(((r - 1 + t) % (R-2) + 1, c))
    all_winds[t] = cur_winds


def bfs(start_r, start_c):
    Q = deque()
    Q.append((start_r, start_c, 0, False, False))

    seen = set()

    p1 = False
    while Q:
        r, c, t, s1, s2 = Q.popleft()
        # if len(seen) % 10000 == 0:
        #     print(len(seen))
        if not r in range(R) or not c in range(C) or input[r][c] == '#':
            continue
        if r == R-1 and not p1:
            print(f"Part 1 = {t}")
            p1 = True 
            print(len(seen))
            s1 = True
        if r == 0 and s1:
            s2 = True
        if r == R-1 and s1 and s2:
            print(f"Part 2 = {t}")
            print(len(seen))
            break
        key = (r, c, t, s1, s2)
        if key in seen:
            continue
        seen.add(key)
        
        nxt_wind = all_winds[t+1]
        
        if (r, c) not in nxt_wind:
            Q.append((r, c, t + 1, s1, s2))
        if (r + 1, c) not in nxt_wind:
            Q.append((r + 1, c, t + 1, s1, s2))
        if (r - 1, c) not in nxt_wind:
            Q.append((r - 1, c, t + 1, s1, s2))
        if (r, c + 1) not in nxt_wind:
            Q.append((r , c + 1, t + 1, s1, s2))
        if (r, c - 1) not in nxt_wind:
            Q.append((r , c - 1, t + 1, s1, s2))
            
            
bfs(rr, cc)
        
        