# Day 16: [Reindeer Maze](https://adventofcode.com/2024/day/16)

### Question Summary
- **Part 1** - Find shortest path from start to end
- **Part 2** - Find all tiles on all shortest paths

### Solution summary 

Dijkstra for part1 . 

For part2, run Dijkstra from end to start. Then for each point on grid, check
if distance from start to that point + distance from that point to end is the
shortest distance. If yes, then that point is on some shortest path. 
