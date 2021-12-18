# Day 18: Snailfish [Link](https://adventofcode.com/2021/day/18)

### Question Summary
- **Part 1** - Snailfish store numbers as pair [x,y]. Pairs can have pairs within them. Adding numbers makes new pairs [x,y] where x and y needed to be added. Do a bunch of reduction operations (explode + split). Add all snail numbers together and find the "magnitude", which has its own rule. 
- **Part 2** - For all permutations of the input numbers, find the two, whose sum has the greatest magnitude. Snailfish addition is not commutative. 

### Solution summary 

Parse it as a string. 
