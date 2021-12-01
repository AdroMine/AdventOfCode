# Day 7: Handy Haversacks - [Link](https://adventofcode.com/2020/day/7)

### Question Summary
Airport custom rules. There are different types of bags and each bag contain only certain types and numbers of bags, and the inside bags have their own rules, so there can be bags within bags within bags. 

- **Part 1** - How many bags can directly/indirectly contain a `shiny gold` bag
- **Part 2** - How many bags total can a `shiny gold` bag contain inside it

### Solution summary 
Rules like below
> [1] "pale turquoise bags contain 3 muted cyan bags, 5 striped teal bags."
> [2] "light tan bags contain 5 posh tomato bags."                         
> [3] "shiny coral bags contain 2 muted bronze bags."                      
> [4] "wavy orange bags contain 4 faded tomato bags."                      
> [5] "light plum bags contain 3 drab orange bags, 4 faded coral bags."    
> [6] "pale purple bags contain 5 bright crimson bags." 

Use regex to parse
1. split on contain to get container bag and contents bag part
2. on contents part use regex with `str_match_all` from `stringr` to get counts and types of bags as list
3. create container_bag[content_bags] style named list
4. Use recursion for both parts. 