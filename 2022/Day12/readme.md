# Day 12: [Hill Climbing Algorithm](https://adventofcode.com/2022/day/12)

### Question Summary
- **Part 1** - Shortest distance from Start to End
- **Part 2** - Shortest distance from multiple starts to same end

### Solution summary 

Apply dijkstra's algorithm for part 1 and 2. 

~~For part2, currently apply dijkstra for all start points. Need to find better method for this~~

For part2, start at 'E' and search for 'a'. Reverse path finding. 

We could also just use BFS since weights are constant. For part1, we start off with a Deque containing c('S', 0) while for part2 the Deque is initialised with all points that are 'a'


