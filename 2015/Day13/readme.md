# Day 13: [Knights of the Dinner Table](https://adventofcode.com/2015/day/13)

### Question Summary
- **Part 1** - Given dinner table and preferences of people for sitting next to others, what is the most optimal solution. 
- **Part 2** - Add yourself as a person who doesn't cause any change in happiness for others and nobody affects you either. 

### Solution summary 

Store as a dictionary of dictionary so that I can get happiness change for seating x and y together as `rules[x][y]` and `rules[y][x]`. 
Then generate all permutations (ignore circular shifts, or don't since we have very few people anyway) and calculate happiness for all. 