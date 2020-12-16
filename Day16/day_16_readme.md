# Day 16: Ticket Translation  - [Link](https://adventofcode.com/2020/day/16)

### Question Summary
Have a ticket with values, but don't know which value belongs to which field. Have access to the rules for tickets (ticket value lies in certain range) and the tickets of everyone else. 
Some of the tickets (of others) are invalid (they don't follow the rules)

- **Part 1** - find out which are the invalid tickets, and in those which are the invalid values. Get the sum of all these invalid values
- **Part 2** - find out which the order of fields and get the product of the values of your ticket with fields starting with departure

### Solution summary 
Part 1 - Convert tickets to matrix. Check for each element if it satisfies at least one rule. We get the valid tickets in this fashion.
Part 2 - For each rule class, find out which fields of tickets satisfy them. This way we get a list of possible candidates for each rule class. Then iterate through this list of possibilities and remove one by one. (Start with the rule class that has only one possible candidate and remove this candidate from all other rule classes. Repeat as many times as there are rules)