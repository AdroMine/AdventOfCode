# Day 10: [Cathode-Ray Tube](https://adventofcode.com/2022/day/10)

### Question Summary
- **Part 1** - Run instructions, increase cycles based on instructions. Take register value at required intervals and find sum
- **Part 2** - Draw pixels on 2D grid based on cycles and register. Find letters displayed

### Solution summary 

For each line in input, determine the number of cycles to increase. Run a loop for that many cycles and keep drawing pixel and checking if we need to add.

