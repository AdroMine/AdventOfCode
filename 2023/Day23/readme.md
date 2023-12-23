# Day 23: [A Long Walk](https://adventofcode.com/2023/day/23)

### Question Summary
- **Part 1** - Grid, find longest path. Some points make you move in only one direction. 
- **Part 2** - Forget the condition about moving in only one direction at certain points. 

### Solution summary 

A dfs that checks in all possible directions gives solution easily for part1. 

Part 2, the search space is very large, an optimisation method is edge contraction, where if we have:

A -> B <-> C <-> D, a path where we can only go from A to D, then we remove intermediate nodes B and C and just keep A and D, and udpate the weights accordingly. 

Helps reduce the recursion. Still takes around 3-4 minutes for part 2 though. 
