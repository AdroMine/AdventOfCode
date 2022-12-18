# Day 18: [Boiling Boulders](https://adventofcode.com/2022/day/18)

### Question Summary
- **Part 1** - Find surface area of all cubes (by counting how many sides have adjacent cubes)
- **Part 2** - Cube has holes. Only count internal surface area when we can reach outside from there. 

### Solution summary 

use `fastmatch::match` (`%fin%`), which creates a hash table and speeds up matches by quite a significant margin. 

For each point, look if 6 neighbours (up/down in x-y-z direction) are present in input. If not count 1. Do this for all points. 

For part 2, for each point use flood fill with termination condition of having reached outside the box. Precompute the min/max x,y,z in input (extend by one in each direction for safety) and while performing flood-fill for each point's 6 neighbour, check if we can reach outside the limits. 

To speed up flood-fill, cache the points from which we can reach outside and those from which we can't. 

Method 2

Instead of flood filling from inside to outside, flood fill from outside (min point) to inside. In this case we need to flood fill only once. Same speed as method1 with cache. 
