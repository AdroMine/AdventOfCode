# Day 15: [Warehouse Woes](https://adventofcode.com/2024/day/15)

### Question Summary
- **Part 1** - Move robot according to instructions. Move boxes on grid if pushed by robot. 
- **Part 2** - Everything is of two tiles and robot can push a box that has 2 edges and can therefore further push two boxes. 

### Solution summary 

For part 2 since there could be any number of boxes above, use a queue to keep
checking in the given direction for either side of box. If found add to queue
to explore further and add all boxes discovered. Then move them all one by one. 