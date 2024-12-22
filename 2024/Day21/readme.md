# Day 21: [Keypad Conundrum](https://adventofcode.com/2024/day/21)

### Question Summary
- **Part 1** - Number keypad on which we need to enter digits. But a robot does this which we can control via a direcitonal keypad, but this robot is controlled via another robot using a directional keypad and this robot is controlled by you using a directional keypad. Find the length of the sequence that you need to enter for each number, multiplied by the number and sum. 
- **Part 2** - Instead of 2 robots, we have 25. 

### Solution summary 

For part 2, since the sequence will be in billions, what we can do instead is break the sequence required at any stage to groups of two letters and find out what sequence they will generate and their length. Doing this recursively with memoisation leads to fast outcomes since we don't have that many patterns (~256). 


