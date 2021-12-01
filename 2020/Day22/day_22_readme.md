# Day 22: Crab Combat  - [Link](https://adventofcode.com/2020/day/22)

## Question Summary
### Card game


1. Game 1 - play top card from deck. Greater number wins. Winner gets both cards and they go to the bottom (winning card above losing card)
2. Game 2 - with extra rules (let p1 and p2 be the value of the two card drawns)
	- before drawing card, if deck layout matches any previous layout, player 1 wins.
	- check if number drawn matches card left in deck. If yes, recurse into another game with the p1 and p2 cards frome each deck resp. Winner of recursive game is winner of round in parent game.
	- same as Game 1

Play until one deck is emptied.             


- **Part 1** - play game 1 multiply cards with n to 1 (bottom card by 1, top card by n) and take sum
- **Part 2** - same but play game 2

### Solution summary 
Use a queue to keep track of cards (cleaner). Since queue is not a native part of `R` neither any `push` or `pop` features, used package `dequer`. 