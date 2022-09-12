# Day 24: [](https://adventofcode.com/2015/day/24)

### Question Summary
- **Part 1** - Divide a set of integers into 3 groups of equal weights, such that one group contains least number of elements and product of elements within this group is minimum
- **Part 2** - Divide into 4 groups

### Solution summary 

Go through the list of input numbers in descending order, keep adding numbers until reach goal. skip those numbers which cannot be added (exceed goal). This is likely the smallest partition (not 100%). Now find the other partitions in similar fashion from remaining numbers. 

Once we have found a single set of partitions, we can find the length of the smallest group and then generate all combinations of same length which result in goal, then check if other partitions can be formed. If yes, we again check for the min product condition. 


Another technique is to directly generate combinations of different lengths, 1, 2, 3, ... length(input)/num groups and see if any combination has required sum and then if other partitions can be found. 
