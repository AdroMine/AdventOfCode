import os 
os.chdir("D:/Programming/AdventOfCode/2021/Day04/")

import numpy as np 
n, *boards = open("input.txt")

nums = list(map(int, n.split(",")))

boards = np.loadtxt(boards, int).reshape(-1, 5, 5)

scores = []
for n in nums:
    boards[boards == n] = -1
    m = (boards == -1)
    win = (m.all(1) | m.all(2)).any(1)
    if(win.any()):
        scores.append(((boards * ~m)[win].sum() * n))
        boards = boards[~win]
        
print(f"Part1 = {scores[0]}")
print(f"Part2 = {scores[-1]}")