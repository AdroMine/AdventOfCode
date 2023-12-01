# Day 01: [Trebuchet?!](https://adventofcode.com/2023/day/1)

### Question Summary
- **Part 1** - List of strings with digits. Take first and last digit, combine and sum over all.
- **Part 2** - Strings also have words from one to nine in words. Consider them too

### Solution summary 

Use regex to extract digits, combine to single number, repeat digit if only one in line. 

For part2, use regex to replace one with 1 and so on. However, since we can have eighttwo which should become 82, if we replace normally we would only get 8wo, so instead of replacing with eight with 8, add first and last letter as well, so replace 'eight' with 'e8t'. Do for all letters and then solve as in part 1. 


Alternatively, scan line letter by letter. If digit, add to digits, if a number word starts from this letter, add that number to digits. Take first and last digit for each line as before. 