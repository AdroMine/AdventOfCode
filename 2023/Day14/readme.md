# Day 14: [Parabolic Reflector Dish](https://adventofcode.com/2023/day/14)

### Question Summary
- **Part 1** - 2D grid of rocks/obstackles and empty spaces. Till north and slide until stable. Find number representing state.
- **Part 2** - Tilt north, then west, then south and finally east. Repeat this cycle 1 billion times!

### Solution summary 

For part2, the matrix states cycle through a given sequence. So run until sequence found, then extrapolate on the state at 1 billionth turn. 
