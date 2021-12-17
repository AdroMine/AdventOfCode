# Day 17: Trick Shot[Link](https://adventofcode.com/2021/day/17)

### Question Summary
- **Part 1** - We fire a probe with some velocity (x,y). Both directional velocities reduce by one at each step. x goes down to zero, while y continues going down. Given a range of x-y coordinates, find which velocities are possible. For part 1, we want the greatest height the probe can go while still landing within the desired area.  
- **Part 2** - Find the number of possible velocities (x,y)

### Solution summary 

First find the possible x velocities, then possible y velocities. Then for every combination of the two, find which lead to the target area. 
