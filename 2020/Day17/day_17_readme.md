# Day 17: Conway Cubes  - [Link](https://adventofcode.com/2020/day/17)

### Question Summary
3D grid
active vs inactive. 
all cell change simultaneously :
	- if cell is active and surrounded by 2/3 active, then remains active, else becomes inactive
	- if cell is unactive and surrounded by 3 active, becomes active, else remains inactive


- **Part 1** - find number of active cells after 6 cycles
- **Part 2** - same, but 4D grid

### Solution summary 
just loop