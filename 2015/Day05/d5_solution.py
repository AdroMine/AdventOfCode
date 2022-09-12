import sys
from collections import Counter
from typing import List


# Part 1 ---------------------------------------
def mult_letters(word: str) -> bool:
    for i in range(len(word)-1):
        if word[i] == word[i+1]:
            return True
    return False

def p1_nice(word: str) -> bool:
    '''
    Part 1: Is word nice or naughty?!
     - Nice word has at least 3 vowels (vowel can repeat)
     - has two consecutive same letters
     - does not have 'ab', 'cd', 'pq', or 'xy' anywhere
    '''
    c = Counter(word)
    p1 = sum(c[x] for x in 'aeiou') >= 3
    p2 = mult_letters(word)
    p3 = all(not x in word for x in ['ab', 'cd', 'pq', 'xy'])
    return all([p1, p2, p3])
    
# Part 1
def d5part1(input: List[str]) -> int:
    return sum(p1_nice(word) for word in input)

# Part 2 ---------------------------------------
def p2_pair(word: str) -> bool:
    '''
    Given a word, is there a pair of letters that repeats without overlap   
    '''
    for i in range(len(word)-1):
        sub = word[i:(i+2)]
        if sub in word[(i+2):]:
            return True
    return False

def p2_repeat(word: str) -> bool:
    '''
    Given a word, is there at least one letter which repeats with exactly one
    letter between them
    '''
    for i in range(len(word) - 2):
        if word[i] == word[i+2]:
            return True
    return False

    
def p2_nice(word: str) -> bool:
    p1 = p2_pair(word)
    p2 = p2_repeat(word)
    return p1 and p2 
    

def d5part2(input: List[str]) -> int:
    return sum(p2_nice(word) for word in input)
    

if __name__ == '__main__':
    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day05\\input.txt'

    # read input, split on x
    input = [line.strip() for line in open(in_file).readlines()]
    print(f'Part1: Nice Strings = {d5part1(input)}')
    print(f'Part2: Nice Strings = {d5part2(input)}')