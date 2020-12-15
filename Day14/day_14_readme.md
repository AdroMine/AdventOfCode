# Day 14: Docking Data - [Link](https://adventofcode.com/2020/day/14)

### Question Summary
Program with instructions of following form:
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
A 36 bit mask and instructions to write to memory

Find sum of all values in memory at end in both parts. In part1
- **Part 1** - apply mask to value to be stored to memory. (If mask 1 or 0 at certain place, those particular bits become 1|0 in val as well). store in memory (there will be overwriting). 
- **Part 2** - apply mask to memory address. If bit 1 in mask, set bit to 1 in address as well. If bit X in mask, then it can be both 0 and 1, and so we save to more than one memory address

### Solution summary 
create functions to convert from decimal to binary and vice versa. (36 bits, so strtoI doesn't work). 
Create empty list for memory addresses for now and use `modifyList` to add to memory.

For part 2, create a recursive function to generate all possible memory addresses after applying mask and then repeat the same procedure. 