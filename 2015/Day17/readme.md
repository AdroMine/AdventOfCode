# Day 17: [No Such Thing as Too Much](https://adventofcode.com/2015/day/17)

### Question Summary
- **Part 1** - Given set of containers, find how many subsets can contains exactly 150
- **Part 2** - Find the min number of containers required to fill up to 150. How many such combinations of min number of containers are present. 

### Solution summary 

Use recursive function to generate the successful combinations. 
Return a dictionary that stores the length of container mapped to number of ways of successful combination
