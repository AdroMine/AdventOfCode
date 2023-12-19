# Day 19: [Aplenty](https://adventofcode.com/2023/day/19)

### Question Summary
- **Part 1** - List of instructions that chain together to end in accept/reject. Parse list of parts through them and for those accepted, add the numbers of all parts and sum them. 
- **Part 2** - Ignore provided parts. Instead parts can range from 1 to 4000. Determine the number of combinations that will be accepted. 

### Solution summary 

Part 1 is easy, especially using eval and parse to run the operations. 

For part 2, we run a recursive function starting at the first instruction to go through
with limits set to 1-4000 for all 4 variables. Then for each instruction we update the
limits and recurse with these updated limits until accepted or rejected. Add them all
together. 
