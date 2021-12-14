# Day 14: Extended Polymerization[Link](https://adventofcode.com/2021/day/14)

### Question Summary
- **Part 1** - Given a list of initial starting polymers (one line of letters, with every two consecutive letters form a polymer). In every step, every polymer has an insertion rule, where it inserts a new letter between it, (thereby creating two new polymers and "deleting" itself). Simulate 10 steps and the resulting count of individual letters in the ending string. Take the difference of letter with highest occurrence and least. 
- **Part 2** - Simulate for 40 steps

### Solution summary 

Similar to lantern fish problem. The number of polymers double every step, so in 40 steps, we will need to store 2^40. So we can't grow the actual list. Instead, we compute the count of each polymer type (which is limited) at every step and increment it. 

## Alternative Solution

Using transition matrices

[Link](./solution2.R)



