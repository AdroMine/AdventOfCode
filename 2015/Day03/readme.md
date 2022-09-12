# Day 3: [Perfectly Spherical Houses in a Vacuum](https://adventofcode.com/2015/day/3)

### Question Summary
- **Part 1** - Infinite Grid. Find points visited
- **Part 2** - Infinite Grid. Two people start from init point. Find total points visited

### Solution summary 
Create a dictionary (defaultdict) and parse instructions to move locations and add their coordinates as keys to dict. 

For part 2, read instructions one by one for santa and robo-santa and then add the locations visited to the same dictionary (both could visit the same place, so either use one dictionary or use two and then find unique of the keys of two)
