# Day 9: [Rope Bridge](https://adventofcode.com/2022/day/9)

### Question Summary
- **Part 1** - Simulate moving of rope with head and tail. Tail must follow head in such a way that it is never more than one step away from head. Find number of points visited by tail. 
- **Part 2** - Instead of just head and tail, the rope now has 10 parts - head and then 9 knots. Each knot follows the part in front of it. Find the number of points visited by the last knot (tail)

### Solution summary 

Use complex numbers to represent grid (x + iy). 

Move one step at a time. Check if the distance between head and tail (or two knots for part2) is more than one step away (distance can be 1 or 1i for movement along x/y direction, but 1+1i diagonally which will be equal to √2). If yes, move those points in the correct direction. 
