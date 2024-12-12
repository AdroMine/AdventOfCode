# Day 12: [Garden Groups](https://adventofcode.com/2024/day/12)

### Question Summary
- **Part 1** - 2D grid. Multiple possible letters in each position. Find regions with same letters. Find "perimeter" and "area" and multiply for each region and sum. 
- **Part 2** - Instead of perimeter find number of "sides", consecutive sides. 

### Solution summary 

Use flood fill / dfs to find all members of a region. Then find perimeter and area is just number of items in region. 

For part2, for each position, check if it is a corner and add sides for each possible corner direction. Essentially, 
look at each of the four directions, and then the ones at the orthogonal directions. There are only 8 possible cases 
for a corner case.  

Orthogonal directions -> Up right, down left. At each point, check the neighbour in one direction and the next orthogonal direction. 
If they are both not the same character, this is a corner. However, if they are both the same, but the diagonal in that direction is not, 
then again it is a corner. 


```
X.   .X    .   .
.     .   .X   X.

XX   XX   .X   X.
X.   .X   XX   XX
```
