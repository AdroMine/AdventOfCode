# Day 5: [Doesn't He Have Intern-Elves For This?](https://adventofcode.com/2015/day/5)

### Question Summary
- **Part 1** - Tell if string satisfies some criteria (3 vowels (can repeat)), one letter than appears twice in row, and does not contain given substrings
- **Part 2** - Different criteria. Contains a pair of two letters that repeats, and a letter that repeats with exactly one other letter in between

### Solution summary 

Part1 - Use Counter to count vowels, simple loops for other criteria
Part2 - simple loops for both criteria

Another solution uses regex and is much simpler

[Solution 1 - Counter](./d5_solution.py)
[Solution 2 - regex](./d5_solution_regex.py)