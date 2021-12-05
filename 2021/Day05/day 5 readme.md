# Day 5: Hydrothermal Venture[Link](https://adventofcode.com/2021/day/5)

### Question Summary
- **Part 1** - Pair of coordinates for lines. Given a grid, find number of points where at least 2 lines intersect. Only consider horizontal and vertical lines
- **Part 2** - Consider diagonal lines as well

### Solution summary 
Use a matrix for grid. For each pair of coordinate, find the points that lie on the line and increment the matrix at that position by one. 
