from hashlib import md5

# in_file = sys.argv[1] if len(sys.argv) > 1 else 'Day02\\input.txt'
# input = [map(int, line.strip().split('x')) for line in open(in_file).readlines()]
input = 'ckczppom'

def d4part1(input: str, start_zeros:int = 5) -> int:
    
    res = False
    num = 1
    while(not res):
        inp = input + str(num)
        hash:str = md5(inp.encode()).hexdigest()

        # check first 5 letters should be zero for success
        if hash[0:start_zeros] == '0'*start_zeros:
            res = True
            break

        num += 1
    return num

if __name__  == '__main__':
    print(f"Part 1 = {d4part1('ckczppom')}")
    print(f"Part 2 = {d4part1('ckczppom', 6)}")
