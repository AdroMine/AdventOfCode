# Day 07: [Bridge Repair](https://adventofcode.com/2024/day/7)

### Question Summary
- **Part 1** - Given numbers and 2 operations, plus or minus, figure out if we can put the operations in such a way to get desired number. 
- **Part 2** - We also have a concatenation operation

### Solution summary 

Generate permutations and check one by one. If found success, stop at that permutation, no need to check all. 

For part2, generate permutations with all 3 operations but only check ones with the concatenation operation (we have already checked the ones without). 

#### Optimised appraoch

Rather than checking forward with all permutations, instead check from reverse. Is the target divisible by the last number? Has the same digits as the last number (concatenation)?
Addition always works. If yes, then continue down that chain until we reach the end to see if the target is approachable using these numbers. 

Works instantaneously. 
