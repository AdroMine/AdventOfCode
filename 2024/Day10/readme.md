# Day 10: [Hoof It](https://adventofcode.com/2024/day/10)

### Question Summary
- **Part 1** - 2D graph. Multiple start and end points. From each start point, how many end points can be reached. Answer is sum of all these. 
- **Part 2** - Find the distinct number of paths from each start to each end. For each start-end pair, take the sum of these distinct paths. 

### Solution summary 

Use bfs for part 1 from each start point. 

For part 2, maintain a list of parents for each node. Once we have done bfs,
use this list to find out how many ways to go from end to start. Essentially
count the number of parents and if more than one, it implies multiple paths.

