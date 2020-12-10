# Day 10: Adapter Array - [Link](https://adventofcode.com/2020/day/10)

### Question Summary

List of voltages of adapters. Adapter can only take input of something 1-3 volt below it. Add 0 and max + 3 to the list. 

- **Part 1** - find distribution of differences between adapters if all are used at once and multiple # of differences with 1 with # of differences with 3
- **Part 2** - find total number of combinations in which we can connect the adapters

### Solution summary 
1. Sort list and then take difference with list lagging by 1. Use table to get count and then multiply 
<br> <br>
2. **Part 2**
    - Traverse from beginning to end-1. For any num n, see the next possible numbers (any number <= n+3, distribution 1 to 3). Including n, there can be either 2 or 3 or 4 numbers (nothing in between, 1 num in between, 2 num in between). Store 1, 2, 4 respectively for these.
	- Traverse backwards through the results of above and replace patterns of [4, 2] with [4, 1] and [4, 4] with [7, 1] to remove duplicate counts
 
