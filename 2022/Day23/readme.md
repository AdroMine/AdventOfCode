# Day 23: [Unstable Diffusion](https://adventofcode.com/2022/day/23)

### Question Summary
- **Part 1** - Game of life, where rules follow a cycle of four. Repeat for 10 rounds. 
- **Part 2** - Repeat game until stability. Find when stability reached 

### Solution summary 

Use complex numbers to store coordinates of elves positions, this allows easy duplicate checking. Using `fastmatch` to create hash for faster lookups for neighbours. 


