# Day 20: [Infinite Elves and Infinite Houses](https://adventofcode.com/2015/day/20)

### Question Summary
- **Part 1** - For a given number find sum of divisors * 10. Find the lowest number for which sum of divisors x 10 exceeds puzzle input
- **Part 2** - Assume that any divisor only divides the first possible numbers. (example 2 divides from 2,4,6, till 100, but doesn't divide 102)

### Solution summary 

Create a list of all divisors for both parts. Find divisors without performing divisions and testing for 0 remainder. 

Example, need to find divisors of all numbers from 1 to 10. 
2 will be divisor of 2, 4, 6, 8, 10. 

So run two loops

i from 2 to N
    j from i to N, with steps of i (2 in our example)
        divisors[j].add (i) 

for i = 2
j becomes 2, 4, 6, 8, 10
for each of these we add 2 as a divisor

For part2, we add divisors for only the first 50 numbers. 