# Day 9: Seven Segment Search [Link](https://adventofcode.com/2021/day/9)

### Question Summary
- **Part 1** - 2D grid. Find points that are lower than all its adjacent points. Adjacent points only include up, down, left and right. Find the sum of all these points + 1. 
- **Part 2** - This time need to find the 3 largest basins. A basin is a set of points that "flow to the low point". Every low point has its own basin. 9's separate basins. 

### Solution summary 

Use matrix with extra padding around it. For part 1 find adjacent candidates, subtract the point and then check if they are all greater than 0, if yes, it is low point. 

For Part 2, once we have found a low point, then create an empty list. Add low point to it, find its adjacent points, then for each of these points, add them to the basin and then find its next candidates. Repeat until have all possible points (9 is boundary). 

