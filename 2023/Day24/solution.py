import sys
import re
import os 
os.chdir('Day24')
D = open('input.txt').read().strip().splitlines()#.split(' @ |, ')

input = [tuple(map(int, re.split(' @ |, ', x))) for x in D]

from sympy import Symbol, solve_poly_system

x = Symbol('x')
y = Symbol('y')
z = Symbol('z')
vx = Symbol('ux')
vy = Symbol('uy')
vz = Symbol('uz')

equations = []
t_syms = []
#the secret sauce is that once you have three shards to intersect, there's only one valid line
#so we don't have to set up a huge system of equations that would take forever to solve. Just pick the first three.
for i,hail in enumerate(input[:3]):
  x0,y0,z0,ux,uy,uz = hail
  t = Symbol('t'+str(i)) #remember that each intersection will have a different time, so it needs its own variable

  #(x + vx*t) is the x-coordinate of our throw, (x0 + xv*t) is the x-coordinate of the shard we're trying to hit.
  #set these equal, and subtract to get x + vx*t - x0 - xv*t = 0
  #similarly for y and z
  eqx = x + vx*t - x0 - ux*t
  eqy = y + vy*t - y0 - uy*t
  eqz = z + vz*t - z0 - uz*t

  equations.append(eqx)
  equations.append(eqy)
  equations.append(eqz)
  t_syms.append(t)

result = solve_poly_system(equations,*([x,y,z,vx,vy,vz]+t_syms))
print(result[0][0]+result[0][1]+result[0][2]) 

import sys
sys.exit()

from z3 import * 

x, y, z, vx, vy, vz = Int('x'), Int('y'), Int('z'), Int('vx'), Int('vy'), Int('vz')
T = [Int(f't{i}') for i in range(len(input))]
solution = Solver()
for i, hailstone in enumerate(input[:3]):
  x0, y0, z0, ux, uy, uz = hailstone
  t = T[i]
  solution.add(x + vx*t - x0 - ux*t == 0)
  solution.add(y + vy*t - y0 - uy*t == 0)
  solution.add(z + vz*t - z0 - uz*t == 0)

solution.check()
M = solution.model()
print(M.eval(x + y + z))


