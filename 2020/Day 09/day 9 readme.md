# Day 9: Encoding Error - [Link](https://adventofcode.com/2020/day/8)

### Question Summary

Long list of numbers where any number should be the sum of any two previous 25 numbers. 

- **Part 1** - find the first number which is not the sum of any previous 25 numbers
- **Part 2** - for the `num` obtained from part1, find out if any contiguous set of preceding numbers sum up to `num`

### Solution summary 
1. start from 26th number. For any ith number take the n choose 2 combinations of previous 25 numbers and see if they sum to the ith num. Break if not and print (use `Rfast::comb_n` for fast combinations)
2. compute rolling sums of increasing lengths from 2 (use `data.table::frollsum` for fast rolling sums), find if sum obtained for any length, and then find which.