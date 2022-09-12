# Day 22: [Wizard Simulator 20XX](https://adventofcode.com/2015/day/22)

### Question Summary
- **Part 1** - Wizard vs boss. Wizard can cast different spells with immediate and lasting effects. Find min mana required to win
- **Part 2** - You lose one health at start of your turn. 

### Solution summary 

Two ways:

One way is to do a DFS and keep simulating one turn after another for all possible turns and whenever we reach a winning state, use some global variable to store the minimum cost spent to reach that state. Used recursive function with memoisation. 

Another approach is to consider that we want to find the shortest path between nodes, with mana spent as the edge weight and a node represented as a game state consisting of player hp, boss hp, player mana left, mana spent and any spells in effect. Use Djikstra with priority Q to solve this. Also print the path taken to reach here.  


[Manual Search](./d22_solution.py)
[Djikstra](./d22_path_find.py)