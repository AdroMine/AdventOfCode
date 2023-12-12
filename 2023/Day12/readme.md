# Day 12: [Hot Springs](https://adventofcode.com/2023/day/12)

### Question Summary
- **Part 1** - Nonogram. 1D strings with '#', '.' and '?'. Question mark can be either. Given that contiguous groups of '#' have a particular runs, what are the total possible ways of creating valid strings. Sum over all inputs. 
- **Part 2** - Expand each string 5 times.

### Solution summary 

For each line scan character by character using a recursive function. If current character is a '#', increment counter for contiguous '#'. If reach either a '.', we need to end '#' run. If we have already completed our current required run, then move to the next character and start counter for next run. If the counter was zero, then just move onto the next character. 

This is recursive, with end condition that all letters are exhausted. In such a case, if we have already completed all required runs, return 1 else 0. 
Use cache for speed up, keeping a record of where we are in the string, which group of run we are on, and how far we have reached in that run. 

Part 2 still takes 5-6 seconds, with 90% time spent on dictionary retrieval and setting. 
