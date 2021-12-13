# Day 13: Dumbo Octopus[Link](https://adventofcode.com/2021/day/13)

### Question Summary
- **Part 1** - Given a 2D grid, with instructions to fold along particular axis (x = some_num) or (y = some_num). Values are either # or . After folding, if either part was # make it #. (OR). Count total no of # after one folding. 
- **Part 2** - Fold as per the instructions (12 foldings). Then read the resulting grid as a word containing 8 chars.

### Solution summary 

Take a logical matrix (# - TRUE, . - FALSE). Find position of fold and then take the either side of matrices and do an OR to create a new matrix of smaller size. 

For printing the characters, replace TRUE with █ and FALSE with . Set locale to Chinese to enable printing of these characters and then print. 


