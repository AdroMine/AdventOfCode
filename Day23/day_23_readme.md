# Day 23: Crab Combat  - [Link](https://adventofcode.com/2020/day/23)

## Question Summary
Game of rotating cups

- Start with the first cup as selected cup. 
- Pick up the next three. The ones afterward move to take its place (keeping circle)
- Destination cup is the cup with the label one minus the label of the current cup. If such cup is in picked up cells, then keep counting backward (looping back) until we get a valid cup.
- Place the picked up cells after the destination. 

- **Part 1** - find final order after 100 moves
- **Part 2** - same but there are a 1e6 cups and 1e7 moves!!

### Solution summary 
For part 2, the main bottleneck is that array indexing for single elements is too slow. Instead of a single array pointing towards next element, use environment instead which has much faster access time. 