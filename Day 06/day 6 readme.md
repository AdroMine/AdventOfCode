# Day 6: Custom Customs - [Link](https://adventofcode.com/2020/day/6)

### Question Summary
Input is groups of lines and with characters (detailing what question they answered on a form with 26 questions represented by a-z)
If a question is answered, it is present in input. 

- **Part 1** - find the no of questions answered by each group and sum them (find unique characters in each group)
- **Part 2** - For each group, find the no of questions which everyone answered, and then sum the group counts

### Solution summary 
after parsing, we have a list with each list consisting of one string for each person in group. 
Each string has the questions answered by one person. 

So split strings into characters and then for each group take **`union`** for part 1 and **`intersection`** for part 2.