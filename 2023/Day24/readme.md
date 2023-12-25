# Day 24: [Never Tell Me The Odds](https://adventofcode.com/2023/day/24)

### Question Summary
- **Part 1** - Given position of points in 3d space and their velocities. Ignore z-axis and find the number of points that collide in future within given boundaries. 
- **Part 2** - We need to throw a rock from some given position and velocity so that it hits every other hailstone. Find the position/velocity of this rock. 

### Solution summary 

For part1, use line intersection formula. Avoid overflow since positions can be upto 15 digits, so multiplying them together will lead to incorrect results. 

For part2, use scipy and solve system of non-linear equations for 9 variables (position 3, velocity 3, and the time it hits at least 3 stones at different times). Just doing it for first 3 suffices. 
