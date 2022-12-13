# Day 13: [Distress Signal](https://adventofcode.com/2022/day/13)

### Question Summary
- **Part 1** - Check if pairs are in correct order based on given rules. Add the indices of those in correct order
- **Part 2** - Add two packets, and then sort all. 

### Solution summary 

For Part1, first parse as json to convert to lists of list. Then recursively go down the two pairs and compare using the given rules. 

For part2, realise that we just need to 'sort' the packets, where comparison between two items is using the provided rules. So just use bubble sort, while comparing using the function created in part 1.


### Solution 2

This uses S4 method dispatch system where it overloads a function `compare` to handle [list, list], [number, number], [list, number], and [number, list]. Then we can just call compare function on two packets without having to write if/else to check type. 

[Solution2](./d13_S4.R)

