# Day 3: Binary Diagnostic[Link](https://adventofcode.com/2021/day/3)

### Question Summary
- **Part 1** - 1000 binary numbers of 12 digits. Find the most common 1st digit, 2nd digit, etc. and form a binary number. Form a second binary number by using the least common (inverse of most common since binary). multiply these number together after converting to decimal
- **Part 2** - Look at the most common 1st digit, then remove all numbers that don't start with this, repeat for all columns until left with only one number. For the second number, use the less common digits for each

### Solution summary 
read as a fixed width table so that each digit is a column, and then perform column operations. 
