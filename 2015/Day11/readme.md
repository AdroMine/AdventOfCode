# Day 11: [Corporate Policy](https://adventofcode.com/2015/day/11)

### Question Summary
- **Part 1** - Increment string one by one (abc -> abd, xyz -> xza), check for 3 conditions and then find next possible string that satisfies all conditions
- **Part 2** - Do it again

### Solution summary 

Custom function to increment string. 

For 3 consecutive letters, run a loop
For 2 pairs, use regex.findall to find all pairs, then check if distinct pairs are of length 2 or more
For 3rd, not only check if i/o/l is present, but if it is present, then increment that letter right then and there (and make all successive letters to 'a') to speed up things