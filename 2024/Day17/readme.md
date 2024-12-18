# Day 17: [Chronospatial Computer](https://adventofcode.com/2024/day/17)

### Question Summary
- **Part 1** - Given program operation, run given input and find output
- **Part 2** - Find what value should A be so that final output is the same as the original program!

### Solution summary 

Looking at the instructions, the first instruction is always `B = A % 8`. So at
any given step, which will generate one digit of output, we are only looking at
3 bits of A (meaning value is 0-7). So we run the program in reverse, trying to find 
what number between 0-7 will generate one part of the program. At each stage, if multiple
options are available, we branch off of all paths. 

Part 2 solution in python since R by default doesn't seem to have 64 bit bitwise XOR. Neither in 
`bitops` package or `bit64` package. 
