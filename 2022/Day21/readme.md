# Day 21: [Monkey Math](https://adventofcode.com/2022/day/21)

### Question Summary
- **Part 1** - input of form var1: var2 op var3 or varn: num. Need to find value of variable root after solving all
- **Part 2** - root line is root: var1 == var2, and humn: X (variable). Need to find value of X which solves root. 

### Solution summary 

Regex to replace numbers into lines and then eval to solve them. Repeat until root becomes number. 

For part2, after replacing numbers into lines and eval, we will be left with an equation in X. We could solve with uniroot in R, however, the resulting equations has bracket nesting of ~70, while R only allows nesting depth of 50. So extracted equation from R and put into Python and solved via scipy optimise. Could also use binary search. 

