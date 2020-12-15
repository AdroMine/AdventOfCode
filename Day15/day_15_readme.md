# Day 15: Rambunctious Recitation - [Link](https://adventofcode.com/2020/day/15)

### Question Summary
Van eck Sequence. 
Start with some numbers here. Then next number will be:
- if the last number was never seen before (only once in the starting numbers), then 0
- else it will be the difference between the index positions of the last two occurences of the last two numbers


- **Part 1** - find 2020th number of the series given input
- **Part 2** - find 3e7 th number of the series given input

### Solution summary 
Keep a vector of size `n` (if we have to find the nth element) which stores if a number was seen before. Then loop till `n` and go by rules. Use 1L instead of 1 everywhere to optimise.