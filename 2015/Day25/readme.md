# Day 25: [](https://adventofcode.com/2015/day/25)

### Question Summary
- **Part 1** - Grid where numbers are filled diagonally (from bottom to top). Next number = previous number multiplied by some given number modulus some divisor. Find number in grid at given location
- **Part 2** - No Part 2

### Solution summary 

Given r, c location of desired coordinate in grid, we can determine which row this diagonal starts on: row + column - 1

In the grid:
- first diagonal has only 1 number
- second diagoanl has 2 numbers
- third diagoanl has 3 numbers
and so on. 
This any diagonal n has 1 + 2 + 3 + ... + n-1 numbers before it. 

Using above two points we can determine the index of our desired number as sum until (row + column - 1) + column
This is the number of times we need to repeat the operation for. We can run a loop to perform this many operations. 

Another way is to realise that we are essentially performing modular exponentiation above number of times. 


