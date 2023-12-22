# Day 22: [Sand Slabs](https://adventofcode.com/2023/day/22)

### Question Summary
- **Part 1** - 3d space, falling cubes. Each cube can extend in either x/y/z direction only. Can fall if not blocked by other cube below it. When it settles down, find cubes that can be removed without toppling the structure (i.e. nothing on top of it, or the ones on top of a cube are also supported by some other cube)
- **Part 2** - For removing each cube, how many cubes will topple as a chain reaction. Sum over all cubes. 

### Solution summary 

1. Create a list of matrices. Each list item represents the z-index and contains a matrix of x-y points (1:x_range x 1:y_range)
2. Go through each cube, setting the x-y-z coordinates in the above list of matrices. If above ground (z > 1) and no other cube directly below any of its points, then make it 'fall'. 
3. After cube settles, use the matrix above to see which cubes are below the current cube and update lists which store:
    - Cubes that a cube depends on
    - Cubes that a cube supports
4. Once the cubes have settled, go through each cube, if it doesn't support anything add 1, or if it does support, but the dependent has other supports as well, add one. 
5. For part 2, go through list of supports/dependents, marking those as broken for which all supports have broken. Count at end. 
