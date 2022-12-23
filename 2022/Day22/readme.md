# Day 22: [Monkey Map](https://adventofcode.com/2022/day/22)

### Question Summary
- **Part 1** - Tiles with blanks and rocks and path given. Directions on movement given. Move n steps and then turn direction. Find end position. Wrap around when crossing boundaries. 
- **Part 2** - The map is not 2D but 3D! It is actually a cube! Now wrap around doesn't wrap around lines, but wraps around cube edges resuling in very different coordinates and direction. Follow instructions and find end position. 

### Solution summary 

I am probably never going to look at this again, so this is probably not needed, but in any case, part 1 is easy enough. 
For part2, hard code for the given input on how cube edges map to each other and how those would affect the coordinate change. Then follow the steps. 

