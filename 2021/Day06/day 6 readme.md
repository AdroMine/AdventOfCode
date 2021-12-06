# Day 6: Lanternfish [Link](https://adventofcode.com/2021/day/6)

### Question Summary
- **Part 1** - Simulate exponential growth of fish for 80 days and find the total number of fishes afterwards. Fishes double every 7 days. But new fish "rests" for 2 days and then goes into the cycle
- **Part 2** - Same, but for 256 days

### Solution summary 

Store the number of fishes in a certain state, i.e., the no of fishes with 3 days remaining, 2 days remaining, etc. 