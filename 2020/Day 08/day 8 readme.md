# Day 8: Handheld Halting - [Link](https://adventofcode.com/2020/day/8)

### Question Summary

Handheld game console with 3 types of instructions - 
1. acc - adds value to global variable
2. jmp - goto statement
3. nop - does nothing 
Game console stuck in infinite loop

- **Part 1** - find value of global variable when any line is executed twice
- **Part 2** - find which instruction should be changed to resolve infinite loop

### Solution summary 
Input statements are read as a table with 2 columns. Create function to simulate program run until program either completes or executes a same line twice.
Function returns a list with 
- input table along with extra column specifying at which step were the statements executed
- bool on whether program ran until end successfully
- global variable value on program termination

1. run program for part 1, 
2. for part 2 use input table returned in part 1 and use the column specifying order execution to go in reverse switching jmp and nop statements to see if program runs successfully. 