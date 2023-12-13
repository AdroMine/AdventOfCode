# Day 13: [Point of Incidence](https://adventofcode.com/2023/day/13)

### Question Summary
- **Part 1** - Grid containing `#` and `.`. Find point of reflection either horizontally or vertically. Now all rows/cols might be reflected due to where the line of reflection might be. Compute answer according to formula. 
- **Part 2** - Find point of reflection after switching one point somewhere in the grid. This should be a new reflection line, not the old one. 

### Solution summary 

Go across rows and columns, find number of differences if current row/col is taken as line of reflection. If number of differences equal zero, we find our point of reflection for part 1. If number of differences is exactly 1, then we have found line of reflection for part 2. 

Earlier method of brute forcing involving changing each cell one by one and then determining the line of reflection had the issue that sometime, after switching the cell, the new line of reflection might be after the original line of reflection, while the reflection finding function finds the first one. Could send it the row/col number to ignore though. 
