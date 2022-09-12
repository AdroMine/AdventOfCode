from itertools import groupby
        
def look_and_say(input: str) -> str:
    return "".join(["".join([str(len(list(g))), k]) for k,g in groupby(input)])

def solve(input:str, n:int) -> int:
    for _ in range(n):
        input = look_and_say(input)
    return len(input)
    
if __name__ == '__main__':

    # in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day10\\input.txt'
    input = '3113322113'
    
    print(f"Part1 = {solve(input, 40)}")
    print(f"Part2 = {solve(input, 50)}")