# Day 10: [Pipe Maze](https://adventofcode.com/2023/day/10)

### Question Summary
- **Part 1** - 2D Grid of pipes. Given starting point. Find farthest point from starting point that can be reached via pipe. 
- **Part 2** - Find number of tiles enclosed within. 

### Solution summary 

Use dijkstra to generate distance matrix and find max distance for part1. 

For part2, Take graph and

- Replace non-loop components (distance = Inf) with '.'
- Scan through the grid. Everytime you see a pipe symbol that goes upward, switch a boolean
- When boolean is TRUE and current point is '.' increment counter. 
