# Day 22: [Monkey Market](https://adventofcode.com/2024/day/22)

### Question Summary
- **Part 1** - Do some bit operations 2000 times on each input number and sum the last value from each. 
- **Part 2** - Take the last digit of 2000 operations as the 2000 prices.
  Compute changes. For each possible pattern of 4 changes, see the amount that
  comes. Sum over all numbers. Find the pattern which maximises this and use
  the max value as answer

### Solution summary 

For part 2, instead of all possible pattern (-9:9^4), see the patterns that are actually present and keep a map of what that pattern will achieve. 
Do this for each number. Combine the dictionaries and find the max value. 




