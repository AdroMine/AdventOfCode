# Day 9: [All in a Single Night](https://adventofcode.com/2015/day/9)

### Question Summary
- **Part 1** - Shortest distance to cover all nodes. 
- **Part 2** - Largest distance to cover all nodes.

### Solution summary 

Create a graph and look at all the permutations to find min max. 

Same with approach 2 of using `networkx`. 

Can't use something like floyd-warshall, since we would be violating the rule of visiting any city only once. 

[Custom Graph Class](./d9_solution.py)
[Using {networkx}](./d9_solution_nx.py)