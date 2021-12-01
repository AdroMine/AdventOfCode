# Day 2: Password Philosophy - [Link](https://adventofcode.com/2020/day/2)

### Question Summary
password policy and passwords are provided in the form of 
> num1-num2 char: password
- **Part 1** - find if count of char is between num1 and num2
- **Part 2** - find if char is present at position num1 or num2 (only at one not both)

### Solution summary 
Use tidyr and stringi packages to separate input into components and then simple count for part1 and XOR for part2 of characters at the two positions.