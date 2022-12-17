# Day 17: [Pyroclastic Flow](https://adventofcode.com/2022/day/17)

### Question Summary
- **Part 1** - Simulate tetris with winds moving rocks right/left and then rocks falling down one unit. There are 5 types of rocks. Winds and rocks keep repeating. Find total height reached after 2022 rocks have settled.
- **Part 2** - Simulate for 1e12 rocks. 

### Solution summary 

First part is simple enough. I used a boolean matrix of height 10k, and created rocks as boolean matrices as well. Then while cycling through rocks and winds, the following is done:

- to check if piece can move to new position, first remove rock from current position in grid using xor(grid[cur_cords], rock), then check if can be moved to new position by using AND 

`grid[new_cords] & rock`

Finally to move a rock, we use OR, `grid[new_cords] <- grid[new_cords] | rock`

For Part 2, we can't run simulation for 1e12 times, so we look for cycles of repetition in falling rocks structure. If we see the same new rock, same wind and same structure in grid for last N y positions, we can safely say that the same pattern will repeat over and over. So if we are at current height H and last saw these same conditions at height h, r rounds ago, then in another r rounds, the height will increase from H to (H + (H-h)). We can then simulate how many times we can repeat this till we reach 1e12, and simulate for any remainder rocks. 

