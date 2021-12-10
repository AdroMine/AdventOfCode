# Day 10: Syntax Scoring [Link](https://adventofcode.com/2021/day/10)

### Question Summary
- **Part 1** - Multiple lines with different types of brackets opening and closing. Find lines that have incorrect closing bracket. 
- **Part 2** - Find the lines that have incomplete closing brackets. Generate the proper closing sequence. 

### Solution summary 

Use a stack. Push opening brackets in. For a closing bracket, pop one, if match, okay, if not then incorrect. For part 2, after going through the input line, if there are still characters left in the stack, then it is incomplete. Pop everything out to get the closing sequence. 
