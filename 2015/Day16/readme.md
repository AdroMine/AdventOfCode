# Day 16: [Aunt Sue](https://adventofcode.com/2015/day/16)

### Question Summary
- **Part 1** - Find which provided dictionary is a subset of given target dictionary. (Use exact matches for values)
- **Part 2** - For a couple of keys, instead of equal matching, use inequality

### Solution summary 

We can check if a dictionary is a subset of another by:
`dict1.items() <= target.items()` # this returns True/False

For part2, we can manually check for equality/inequality based on key. 
