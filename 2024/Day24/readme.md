# Day 24: [Crossed Wires](https://adventofcode.com/2024/day/24)

### Question Summary
- **Part 1** - Implement given sequence of gates and initial values and compute final result, a 45 bit integer. 
- **Part 2** - Part 1 is actually a machine to add numbers (45 bit ripple carry adder) but 8 output wires have been incorrectly swapped. Find which.

### Solution summary 

45 bit ripple carry adder chaining 45 1-bit adders each bit connected to carry bit of
all previous adders. 

Each output bit is computed using a, b and carry bit c. 

output = a xor b xor c

nxt carry bit = (a AND b) OR ((a XOR b) AND c)

Rule 1 - if output gate is z, operation has to be xor unless last z gate
Rule 2 - if output gate is not z, and inputs are not x,y, then it should be AND/OR not XOR

After these 6 there are still 2 gates left. 

One carry bit got messed up somewhere, so we need to find a x## and y##
operation that is incorrect. We can search through the 0-44 gates and swap
their outputs one by one until we get the result

All from https://www.reddit.com/r/adventofcode/comments/1hla5ql/2024_day_24_part_2_a_guide_on_the_idea_behind_the/