import sys

in_file = sys.argv[1] if len(sys.argv) > 1 else r'2015\Day01\input.txt'

input = open(in_file).readlines()[0]

# Part 1 alone
# print(sum(1 if x == '(' else -1 for x in input))

# Part 1 & 2 
cur = 0
reached = False
for i, c in enumerate(input):
    cur += 1 if c == '(' else -1 
    if not reached and cur == -1:
        print(i+1)
        reached = True
print(cur)