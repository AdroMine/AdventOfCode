# Day 20: [Race Condition](https://adventofcode.com/2024/day/20)

### Question Summary
- **Part 1** - Race from start to finish on 2D grid. Only one possible path.
  But allows 'cheating', that is skipping through obstacles for up to 2 units
  of time, after which car should be back on "track". How many cheats can we
  use to save more than 100 steps?
- **Part 2** - Allows cheating for up to 20 seconds. 

### Solution summary 

Pre compute distances from start to end. Then for each point on path, see if
they are 2 distance apart for part 1 (or up to 20 for part2) and if jumping
between them can save more than 100 steps. 