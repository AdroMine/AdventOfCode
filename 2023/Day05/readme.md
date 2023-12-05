# Day 5: [If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)

### Question Summary
- **Part 1** - Go through a list of mappings and find the lowest final mapped value. 
- **Part 2** - Initial list of numbers to map are not numbers but ranges of numbers. Again find the lowest final mapped value. 

### Solution summary 

Part 1 is simple. Just iterate through the mapping rules. 

For Part2, the total number of initial seeds turns out to be 21 billion. Not something to iterate one by one. 

Brute force solution that takes around 10 min involves creating a reverse mapping, from final mapped to original seed number. Then iterate from 0 to infinity, do reverse mapping and check if obtained seed is actually within obtained seeds. Break at first found. 


For part 2, non brute force, take the numbers as ranges, so if we have first seed and range of 10, 5, covering 10-15, 
we take this range, compare with the first mapping rules. Depending on the range we can now divide our seed range into 3 parts, 2 parts that are before and after the mapping rule range, and one that overlaps it. The first 2, if present can become extra ranges to check over, while the seed range with the overlap can be mapped to the next stage. We do this for each mapped stage and get a list of range outputs. From here we take the min value. 
