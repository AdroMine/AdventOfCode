# Day 06: [Guard Gallivant](https://adventofcode.com/2024/day/6)

### Question Summary
- **Part 1** - Traverse grid until exit and find number of steps visited. 
- **Part 2** - At how many points can we put some block to force a loop. 

### Solution summary 

Part 1 is simple traversal until exceed boundaries. 

For part 2, start with the visited locations in step 1 and try introducing a block at each location and see if it results in a loop. If you visit the same place again with the same direction, it is a loop. 
