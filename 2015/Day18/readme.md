# Day 18: [Like a GIF For Your Yard](https://adventofcode.com/2015/day/18)

### Question Summary
- **Part 1** - Game of Life for 100x100 grid. Switch on if already on 2,3 neighbours are on else off. If off, and 3 neighbours on, then switch on. 
- **Part 2** - Corners always remain on

### Solution summary 

Two solutions:

Regular nested loops is slow. 
Using sets to store coordinates of points that are on and then updating set based on whether neighbour on count. 

Second method is to use numpy and scipy's ndimage generic_filter which allows us to apply a filter along an array at every point by taking a window of fixed size and using it for the function. For our function we naturally take a window of 3,3 (all neighbours and point itself) which gets passed to the function as a 1D array. We take the count and update accordingly. 

[Nested loops](./d18_solution.py)
[numpy + scipy](./d18_numpy.py)