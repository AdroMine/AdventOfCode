# Day 12: Rain Risk - [Link](https://adventofcode.com/2020/day/12)

### Question Summary
Instructions to move ship and ship/waypoint. Direction plus number given, move or rotate.


- **Part 1** - find manhattan distance of ship, instructions move ship only
- **Part 2** - find manhattan distance of ship, instructions move ship and a waypoint relative to ship, Ship moves in direction of waypoint

### Solution summary 
~~Keep track of east and north. West and South are negative of these.
Keep track of current direction with a named vector~~
<br>Rotate left by x degrees is equivalent to rotating right by 360-x degrees.

#### Learned new trick of using complex number plane!
Use complex number plane where X axis is represented by the real part and Y-axis by the imaginary part. 
<br>
Multiplication by i results in a counterclockwise rotation by 90 degrees.

Also combine part1 and part2 in one function.