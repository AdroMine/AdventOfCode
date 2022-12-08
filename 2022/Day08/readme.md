# Day 8: [Treetop Tree House](https://adventofcode.com/2022/day/8)

### Question Summary
- **Part 1** - In grid, find no of points that are larger than every point along left/right/up/down
- **Part 2** - In grid, find points along left/right/up/down that are smaller, find their product for each point. Find max

### Solution summary 

matrix of input. 

For part 1, create matrix of visibilities (could have also kept just a counter as well). Go through each non-edge point and look in 4 directions. If visible in either, mark as visible. (Can do early stopping)

For part 2, create a matrix of distances (could have also kept a counter and taken max at each turn). Go through each non-edge point and look in 4 directions to determine no of trees visible. 
