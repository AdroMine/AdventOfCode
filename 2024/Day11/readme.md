# Day 11: [Plutonian Pebbles](https://adventofcode.com/2024/day/11)

### Question Summary
- **Part 1** - Stones change/split according to criteria. Find number of stones after 25 blinks
- **Part 2** - after 75 blinks

### Solution summary 

25 can still be brute forced. However, 75 is not possible. 

Use a recursive function with memoisation to solve for a single number at a
time, since one stone doesn't affect other stones. So run down from step N to 1
for a given number with cache. Sum the output of this function for all numbers
in the input. 