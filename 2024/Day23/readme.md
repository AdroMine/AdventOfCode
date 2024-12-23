# Day 23: [LAN Party](https://adventofcode.com/2024/day/23)

### Question Summary
- **Part 1** - Given graph of nodes, find how many of size 3 have at least one node with name starting with t
- **Part 2** - Find the largest possible subgraph (maximaal clique)

### Solution summary 

We only have 520 nodes and each node has only 13 connections. So for part 1, focus on nodes that start with 't',
get their neighbours, look at two at a time and see if they are connected to each other. If yes, add 1 to answer. 

For part 2, take each node and do a BFS. Start with the node itself as a clique
and take all its adjacents. For each adjacent, check if this adjacent is connected 
to each member of the current clique. If yes, add to the current clique. And add all
the nodes connected to the currently considered node as possible next nodes to look at. 
Keep a dictionary of subgraph for each node and a running track of longest. 

