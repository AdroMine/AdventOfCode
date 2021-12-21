# Day 21: Dirac Dice[Link](https://adventofcode.com/2021/day/21)

### Question Summary
- **Part 1** - Two players take turn throwing a 100 sided dice that gives 1,2,3,... till 100 and then back to 1. Each player throws dice 3 times, takes the sum and moves that many positions on a circular track from 1 to 10. The first to reach 1000 wins. Find the number of times dice rolled multiplied by the score of the loser. 
- **Part 2** - Now we use a 3 sided dice that creates 3 "new universes" each time it is thrown, with each universe seeing one of the results [1,2,3]. The rest of the rules remain same. Find the number of times each player wins in all the universes. Answer is the max of these. 

### Solution summary 

Part 1 is straightforward. 

Part 2 requires recursive calls. Memoization is vital, however, package {memoise} somehow failed to help, even after manually setting the cache size to Inf, it still just ran on and on. Instead, manually created a cache using dictionary from {collections} package. 

Another optimisation is that while there are 27 combinations of the die thrown (1:3, 1:3, 1:3), the sum of these (we need the sum of 3) only has seven unique values. So instead of branching out into 27 universes, we can only branch out in 7 and multiply the win number by the amount of times that sum comes in the 27 permutations. 


