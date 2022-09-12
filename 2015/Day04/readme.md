# Day 4: [The Ideal Stocking Stuffer](https://adventofcode.com/2015/day/4)

### Question Summary
- **Part 1** - Find smalles positive number that when added to string produces an MD5 that starts with 5 zeros
- **Part 2** - Find smalles positive number that when added to string produces an MD5 that starts with 6 zeros

### Solution summary 

Use hashlib library to generate hash. Use a loop to keep trying positive numbers until we reach condition
