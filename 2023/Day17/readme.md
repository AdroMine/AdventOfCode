# Day 17: [Clumsy Crucible](https://adventofcode.com/2023/day/17)

### Question Summary
- **Part 1** - Run through 2d grid with costs/heat loss. At any given step we cannot move back, and we can only move in a given direction for 3 consecutive steps before turning to either left/right. Find min path to end. 
- **Part 2** - Same, but now we must move at least 4 steps before turning and at most 10 steps before we need to turn. Also can only step after having moved 4 consecutive steps. 

### Solution summary 

Use Dijkstra to find shortest path. However, this isn't just 2d grid of coordinates and distance to reach there, but must also include the direction we came from and the consecutive number of steps taken to reach this point. Thus each point is represented by :

(x, y, direction coming from, consecutive steps taken)

Use this with dijkstra. At end we will have multiple ways to reach end node (from multiple directions and with different consecutive number of steps). Find the one with the shortest distance. 


