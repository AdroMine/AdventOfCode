# Day 3: [Gear Ratios](https://adventofcode.com/2023/day/3)

### Question Summary
- **Part 1** - In 2D grid, find numbers that are surrounded by symbols. Numbers not digits. So 123.. will be treated as '123' not 1, 2 and 3. Find the sum of all such numbers.
- **Part 2** - Find '*' that are surrounded by 2 numbers, multiply those 2 numbers and sum. 

### Solution summary 

Create a matrix. Pad with dots (.). Scan through each row, if found a number keep going right until end of number. Once found the x, y:end_y coordinates for number, look at their neighbours, including diagonals for presence of any character other than digit and '.'. If yes, add this number. 

For part 2, when we find a number and get neighbours, look if a '*' is present in neighbours. If yes, add the current number for the given position of star to some list. At the end, iterate over this list of coordinates of stars that gives the numbers present in its neighbourhood. If it has 2 numbers, multiply them and add them all up. 
