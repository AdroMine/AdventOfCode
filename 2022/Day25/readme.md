# Day 25: [Full of Hot Air](https://adventofcode.com/2022/day/25)

### Question Summary
- **Part 1** - Convert numbers to base 5, add them together, then convert back to base 5. Digits consist of -2, -1, 0, 1, 2. (no 3,4)
- **Part 2** - No Part 2

### Solution summary 

For conversion, multiply by subsequent powers of 5 and then sum. 

For conversion back to base 5, keep dividing by 5 and taking the remainder. If the remainder is 3 or 4, convert to -2, -1, respectively and add one to quotient. 

