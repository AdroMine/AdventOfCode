# Day 8: [Matchsticks](https://adventofcode.com/2015/day/8)

### Question Summary
- **Part 1** - given some strings, count how many characters to write strings in code - actual len of string in memory
- **Part 2** - consider given strings as strings represented in variables. Convert to code representation and then find difference of length between this and length of string

### Solution summary 

For Part 1, use `len(string)` to get length of 'code representation' and use `len(eval(string))` to get length of string in memory
For Part 2, use replace to replace " with \" and \ with \\. For each string also add two for the quotes at start and end. 
For Part 2, another way would be to count the number of " and \ in each line and add 2 (for quotes at start/end)


