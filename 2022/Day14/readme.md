# Day 14: [Regolith Reservoir](https://adventofcode.com/2022/day/14)

### Question Summary
- **Part 1** - Simulate falling sand in grid with rocks. Sand falls down/down-left/down-right. Keep simulating until sand just keeps on falling (goes down abyss) and then count number of sand particles in grid
- **Part 2** - Grid is not bottomless but has a floor. Simulate until sand filled till start point.

### Solution summary 

Use a 1000x1000 boolean grid. Mark rocks/sands as TRUE. 

Find x axis coordinate of left and right most rock, as well as y axis coordinate of bottom most rock present in input. Anytime a rock crosses any of these boundaries, it has fallen into abyss. 

