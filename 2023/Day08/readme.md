# Day 8: [Haunted Wasteland](https://adventofcode.com/2023/day/8)

### Question Summary
- **Part 1** - Travel from one node to another. From each node we can travel to 2 places, and we keep switching directions based on initial input. Find number of steps to reach end. 
- **Part 2** - Travel from multiple starting nodes to some end nodes. Keep going until all reach end simultaneously. 

### Solution summary 

First part is simple. 

For second part, we need to realise that there are cycles from each start to end. Once we discover the size of these cycles for each starting point, we find the LCM of all these. 

Normally running a loop is not practical since the final number is in 10^13 range. 
