# Day 4: [Camp Cleanup](https://adventofcode.com/2022/day/4)

### Question Summary
- **Part 1** - Find how many ranges are subset
- **Part 2** - Find how many overlap

### Solution summary 

We can create ranges using `seq.int` and check if A-B or B-A is empty for subset, and use `intersect` for overlap. 

But this assumes that ranges are small enough that won't cause memory troubles. If we don't make assumptions about size of ranges, then we can manually check using the start and end point. 

For subset: A is subset of B if A.start is >= B.start and A.end is <= B.end
For overlap: A overlaps with B if A.start is between B.start and B.end or if B.start is between A.start:A.end

