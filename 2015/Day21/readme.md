# Day 21: [RPG Simulator 20XX](https://adventofcode.com/2015/day/21)

### Question Summary
- **Part 1** - RPG game, boss has stats (hp, dmg, armor), hero can buy stuff (1 weapon, 0-1 armour, 0-2 rings) to increase his stats. Find out the minimum gold required to still beat the boss
- **Part 2** - Max gold with which hero would still lose. 

### Solution summary 

Add 1 dummy armour (0 cost, 0 armour) and 2 dummy rings (0 cost, 0 dmg, 0 armour). Then run nested loop to check all combos (selecting dummy armour/ring counts as not having selected any armour/ring) and find best/worst cost. 