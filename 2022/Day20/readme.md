# Day 20: [Grove Positioning System](https://adventofcode.com/2022/day/20)

### Question Summary
- **Part 1** - Shift number right/left based on its value. Do this for each number in the order they appear. 
- **Part 2** - Multiply by big number and repeat above 10 times. 

### Solution summary 

We need to keep track of positions. We can do this easily by using names of the vector and storing the actual positions as character names for the vector. We will thus have:

> `1  2  3  4  5` -> names
 `n1 n2 n3 n4 n5` -> values

Then even when the values have shifted, the names shift with them, so we can use them to identify which needs to be rotated next. 

For rotation, instead of performing modulus with N, use N-1, since it is a circular array and start and end are adjacent to each other. 


