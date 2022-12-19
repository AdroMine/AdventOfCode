# Day 19: [Not Enough Minerals](https://adventofcode.com/2022/day/19)

### Question Summary
- **Part 1** - Given 4 types of ores and 4 robots that extract them and a factor to make robots, and different blueprints on robots that require different amounts of ores for construction, determine the max number of ore type 4 that can be extracted for each blueprint in 24 minutes. In one minute we can construct one robot, and each existing robot can extract one unit of ore. 
- **Part 2** - We have 32 minutes and only first three blueprints. 

### Solution summary 

Both R and Python solution. [Python solution](d19.py) runs in around 10 seconds with pypy. 

R solution takes a couple of minutes. Part 2 runs slower on it. 

For both, we run a graph search with state represented by time, qty of ores collected and count of robots. From each state we have 5 options: don't create any robot, or create a robot of each type given we have enough resources. This can be very slow, so we use following optimisations:

- We can only construct one robot at any given time. So if we have more robots than the max resource required for construction of any robot, we don't try to create a new robot. (If no robot requires more than 10 ore in its construction, then having 11 robots that can extract ore is meaningless). 
- If we can construct robot of type 4 (which collects geode, which is what we want to maximise), then only create that robot. Don't branch out into other 4 possibility states
- If at any given time we have more resources that can be consumed in the remaining time, then we cap them at max that can be used. This helps get more cache hits. 
- If at any given time, we cannot exceed the best geode number we have in the remaining time, then we skip going down that branch. For example, if we have max geodes collected as let's say 15, and we are at time 20 with only 5 geodes, then in the remaining 4, if we construct a geode collecting robot each minute and they all collect we still won't exceed 15. 

In Python, I used a BFS. 

The same didn't work in R (`collections::queue`) was probably a bottleneck? (Profiler suggested length function that probably corresponds to checking if Queue has items). So used a recursive DFS in R with `utils::hashtab` as cache (this is only available in R > 4.2)

