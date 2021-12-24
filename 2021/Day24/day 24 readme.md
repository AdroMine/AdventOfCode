# Day 24: Arithmetic Logic Unit[Link](https://adventofcode.com/2021/day/24)

### Question Summary
- **Part 1** - Given a VM type program that runs multiple instructions, find the largest 14 digit number that leads the program to return 0
- **Part 2** - Find the smallest 14 digit number that leads the program to success

### Solution summary 

Need to reverse engineer the code. The following code repeats 14 times:

| op   | var1 | var2 |
| :--- | :--  | :--  | 
| inp  | w    |      | 
| mul  | x    | 0    | 
| add  | x    | z    | 
| mod  | x    | 26   | 
| div  | z    | 1    | 
| add  | x    | 13   | 
| eql  | x    | w    | 
| eql  | x    | 0    | 
| mul  | y    | 0    | 
| add  | y    | 25   | 
| mul  | y    | x    | 
| add  | y    | 1    | 
| mul  | z    | y    | 
| mul  | y    | 0    | 
| add  | y    | w    | 
| add  | y    | 14   | 
| mul  | y    | x    | 
| add  | z    | y    | 

We have four registers, w, x, y, and z. w is used to store the current input. x and y are for temporary calculations. z is used for storing all results. It stores numbers by converting them to base 26 (sort of). So after storing the first number, to store the second number, it would multiply the first number by 26 and then add the 2nd number to it. To extract, it would take the mod of z by 26. 


1. Take a digit.
2. Clear x register. Take the last number added to z. 
3. Add some number to x. This number changes in each cycle (and for input). 
4. Divide z by 1 or 26. 
    * Here, in case the divisor is 1, then we are essentially only 'peeking' at the top value (in step 2 above),
    * However, if divisor is 26, then we are 'popping' from z, thus the value is no longer present in z after this. 
5. We check if x is not equal to the current input (which will always be a single digit from 1 to 9). (x = 1 if it is not equal to the current digit)
    * If x!=current digit, then x becomes 1, and z becomes z\*26 + current digit + new number (14 in above). 
    * Else z remains as is
    - The ALU code is written in such a manner, that when z is divided by 1 (similar to peeking from stack), then x turns to be one (by adding a large number). Else, when division is by 26 (a pop), x = 0, and we are able to put a constraint on what digits are possible for 2 positions.
6. If x!=1, then we add to stack. 

There are 14 such codes. There are exactly 7 pushes to stack and 7 pops. To get a zero value for z at end, we need the stack to become empty. Thus every time z is to be divided by 25 in instruction 5 of a cycle, we want x to become 0. 
