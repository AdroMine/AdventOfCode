# Day 19: [Medicine for Rudolph](https://adventofcode.com/2015/day/19)

### Question Summary
- **Part 1** - Given molecule transformations (X -> Y; X -> PQ, etc.), then given these transformations and a molecule (string), how many distinct molecules can be created by using one replacement anywhere in the molecule
- **Part 2** - In how many steps can we go from start to given molecule

### Solution summary 

In part 1, replace and keep adding to set. Then count length of set. 

In part 2, instead of going from start to finish, try to go back from finish to start by reverse replacements. For this reverse the rules (A -> B becomes B -> A and so on). Also need to reverse the string and rules, so that A -> BCD becomes DCB -> A. This ensures that we don't get stuck in the middle. 

Technically, the rules are CFG, and we might be able to use a parser as well. 