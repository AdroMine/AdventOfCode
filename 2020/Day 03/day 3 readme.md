# Day 3: Toboggan Trajectory - [Link](https://adventofcode.com/2020/day/3)

### Question Summary
Input is a rectangle of . and # (empty and trees resp.). Travel from top rigth to bottom. 
<br>
Assume pattern repeats on right (loop back to first).

Travel according to directions provided. 
- **Part 1** - travel 3 right and 1 down, find # of trees hit during travel
- **Part 2** - travel according to 5 different styles, find product of # of trees hit in each

### Solution summary 
Assume matrix, create Row and Column IDs person will travel through according to directions. For Row ID, should not exceed max, for Col ID, should loop back from right to left. Then do a vectorised subset of given row and column ids and find # of trees. 