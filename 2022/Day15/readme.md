# Day 15: [Beacon Exclusion Zone](https://adventofcode.com/2022/day/15)

### Question Summary
- **Part 1** - Given beacons and sensors. Sensors detect closest beacon by manhattan distance, meaning no other beacon within same manhattan distance. For a given y coordinate and provided sensor/beacon data, find how many points cannot contain a beacon?
- **Part 2** - x,y are in range 0 to 4M. Find the one point where no sensor detects. 

### Solution summary 

Given a sensor and beacon, we know the manhattan distance D of detection for the beacon. For a given y coordinate, we find if we can reach it from the given sensor and if yes, then how much can we travel along the x-axis on that y-coordinate. 

If it takes n steps to reach y, and we are currently at x,y', then sensor can detect on y-axis (D-n) from x in either direction. 

If we perform the same for each sensor, we can find for any given y coordinate the coordinates that are detectable by all sensors. If there's a point that is not detectable, that is our answer. 

For part2, try to determine the intervals by start and end points using above approach. Only find the start and end points. Then merge all the intervals together. 

To merge multiple intervals, first sort them by their x-axis coordinate, then given two intervals, P and Q, they can merge if:

P[y] <= Q[x], and merged interval becomes c(P[x], max(P[y], Q[y]))

We merge all intervals for a given y-coordinate. If two intervals cannot be merged, we have found our solution. 

For part2, we run the above procedure for each possible y. 

