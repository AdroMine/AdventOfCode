import re 
            
pairs = re.compile("([a-z])\\1")
def inc_str(s: str) -> str:
    """
    Increment string by one
    so abc -> abd
    xy -> xz
    abz -> aca
    xzz -> yaa
    """
    s_num = [ord(c) for c in s]
    i = len(s_num) - 1
    while True:
        s_num[i] += 1
        if s_num[i] != 123:
            break
        s_num[i] = 97
        i -= 1
    return "".join(chr(x) for x in s_num)

def three_letters(s: str) -> bool:
    """
    Check for 3 consecutive letters, 
    abcd -> True (abc)
    abde -> False 
    abdef -> True (def)
    abxyz -> True (xyz)
    """
    o = [ord(x) for x in s]
    for x, y, z in zip(o, o[1:], o[2:]):
        if z - y == 1 and y - x == 1:
            return True
    return False

def rep_pairs(s: str) -> bool:
    """
    Two unique pairs of same letters. 
    'aabb' - True (aa and bb)
    'aabaa' - False (only aa)
    'aabcc' - True (aa, cc)
    """
    return len(set(pairs.findall(s))) >= 2
    
def inc_str_at_pos(s: str, pos: int) -> str:
    """
    In case of i/o/l at any point in string, increment string at that point
    Don't need to worry about z, since this will only be called for i/o/l
    """
    return s[:pos] + chr(ord(s[pos]) + 1) + 'a' * (len(s) - pos - 1)
    

def find_nxt_pwd(input: str) -> str:
    c1, c2, c3 = [False] * 3
    while not all([c1, c2, c3]):
        input = inc_str(input)
        c1 = three_letters(input)                  # 3 consecutive letters
        c2 = re.search('[iol]', input) is None     # no i/o/l in string
        c3 = rep_pairs(input)                      # 2 unique repeating pairs

        # if i, o, or l is present
        if not c2:
            for m in re.finditer('[iol]', input):
                input = inc_str_at_pos(input, m.start())
    return input
    
    
if __name__ == '__main__':

    # in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day10\\input.txt'
    input = 'hxbxwxba'

    # Part 1
    input = find_nxt_pwd(input)
    print(f"Part1 password = {input}")

    # Part 2
    print(f"Part2 password = {find_nxt_pwd(input)}")

    