# Day 22: Reactor Reboot[Link](https://adventofcode.com/2021/day/22)

### Question Summary
- **Part 1** - Given a set of coordinates (that represent 1x1x1 cubes), with instructions of switching on and off, find out how many cubes are on after the instructions. 
- **Part 2** - Same, but now we need to consider all the cubes instead of just those that are within a range. The full range is now from -100k to +100k. 

### Solution summary 

Keep a dictionary of cubes. Add 'on' cubes to it. After adding a cube, for each existing cube, find the intersection with the new cube. Intersection comes as a new smaller cube. Store this cube but mark it so that we know we need to subtract the volume of this. 
