# Day 2: [Rock Paper Scissors](https://adventofcode.com/2022/day/2)

### Question Summary
- **Part 1** - Find total score if you play by strategy
- **Part 2** - Again find total score. This time second column in input is match result you need to obtain. 

### Solution summary 

Use switch statement for now. 

Another solution is to convert both players moves to numbers, 
ABC to 123
XYZ to 123
which depict Rock Paper Scissors
In this, P2 wins when p2 is one ahead of p1, draws when p2 == p1 and p2 loses when p2 is 2 ahead of p1 (using modular to circle around). 

Using these tricks to compute the differences in moves for part1 to determine win/lose/draw. 
For part2 we do the reverse, use the given win/lose/draw to compute move for part 2 using above logic and then compute the answer
