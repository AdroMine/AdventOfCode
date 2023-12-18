# Day 18: [Lavaduct Lagoon](https://adventofcode.com/2023/day/18)

### Question Summary
- **Part 1** - Instructions to dig (fill infinite grid with '#'). Fill 'interior' points with '#' as well. Get total count of '#'
- **Part 2** - Same, but instructions make much bigger movements in the thousands now

### Solution summary 

Earlier used a big matrix (2000 X 2000) to fill points and then flood fill from 4 corners to fill exterior points with 'O'. Then just take the sum in the matrix of all points that are not 'O'. But very slow. 

Instead, use shoelace formula to compute area of a polygon using its vertices and then Pick's formula which relates area to number of interior points and perimeter points to find sum of all '#' in grid. 

While going through instructions, just store end points after movement in a dictionary and keep track of points on the perimeter (using movement size). 
