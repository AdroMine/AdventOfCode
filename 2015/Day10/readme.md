# Day 10: [Elves Look, Elves Say](https://adventofcode.com/2015/day/10)

### Question Summary
- **Part 1** - Look and say game. Given 211 we convert to one two, two one (1221) which gets converted to one one, two two, one one (112211). Do this 40 times and find length of resulting string
- **Part 2** - Do it 50 times

### Solution summary 

Use itertools.groupby to split characters into consecutive characters. Then join them together