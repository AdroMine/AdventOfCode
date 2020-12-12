# Day 11: Seating System - [Link](https://adventofcode.com/2020/day/11)

### Question Summary
Hall has seats. People come and sit according to rules. People keep changing seats until system stabilises.
In part 1, people only look at adjacent seats to determine whether to sit/move.
In part 2, people look at adjacent seats but ignore floors in computing adjacent seats.


- **Part 1** - find number of people sitting
- **Part 2** - find number of people sitting

### Solution summary 
Long nested loops. 
For part 2 need to find first or last non NA number. `Position` function is faster than `is.na` and technique is overall much faster than `na.omit`. Using 3rd nested loop for finding adjacent seats was very slow in `R`.
