# Day 11: [Cosmic Expansion](https://adventofcode.com/2023/day/11)

### Question Summary
- **Part 1** - Grid of `#` and `.`. Find distance between all `#` and sum it. Any row or column without `#` needs to be `expanded` or repeated 1 time. 
- **Part 2** - Repeat empty rows/columns 1 million times

### Solution summary 

Distance between two points is the manhattan distance. Find the rows/columns without `#` and if such rows/columns are in the path, count extra distance for them depending on how much repetition there needs to be. 

