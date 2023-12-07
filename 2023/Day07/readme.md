# Day 7: [Camel Cards](https://adventofcode.com/2023/day/7)

### Question Summary
- **Part 1** - Poker with custom rules. Each card has some bid value. Rank the cards from weakest to strongest. Sum product of ranks and bids. 
- **Part 2** - Now joker can be any card. Repeat. 

### Solution summary 

Using table to get counts of each card in hand to generate ranks.

Using ordered factors to compare individual cards in a card. 

Sorting is bubble sort, but is really slow for now. 

# Solution using character replacements and `order` function. 

`order` function can take multiple arguments to sort on, so pass it rank and then the card but with face cards replaced with character values that enable correct comparison. In this case I replaced 'A' with 'Z' and 'K' with 'Y' and so on which makes A > K in character comparison (Z > Y).

Passing this replaced version of the hand enables easier comparison. 



# New solution enabling `sort` function

We can create a list of hands and their bids and assign a custom class to this list. For this custom class we need to define 3 functions: subset `[`, `>` and `==`. With these 3 functions defined, `sort` function will work. 

Much faster. 
