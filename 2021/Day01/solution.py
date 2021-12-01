import os 
os.chdir("D:\\Programming\\AdventOfCode\\2021\\Day01\\")

input = [int(x) for x in open('input.txt')]    

# Part 1
sum(x > y for x,y in zip(input[1:], input))


# Part 2 
rolling_sums = [sum(x) for x in list(zip(input, input[1:], input[2:]))]

sum(x > y for x,y in zip(rolling_sums[1:], rolling_sums))

# Part 2 optimised
sum(x > y for x,y in zip(input[3:], input))