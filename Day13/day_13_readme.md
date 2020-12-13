# Day 13: Shuttle Search - [Link](https://adventofcode.com/2020/day/13)

### Question Summary
Lots of buses departing at every t minute. 


- **Part 1** - find earliest bus you can catch given you have to wait until time n
- **Part 2** - find the earliest time when buses will depart in a give order (bus 1 leaves at t0, then bus 1 after t1 minutes, bus 2 after t2 minutes and so on)

### Solution summary 
part 1 simple enough
part 2 use Chinese Remainder theorem. 
Also R has accurate results only upto 16 digits, even if you are using type double. used package `Rmpfr`