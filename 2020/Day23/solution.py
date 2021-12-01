input = [int(x) for x in '562893147']
input = input + list(range(10, 1000000+1))

# input = [3, 8,  9,  1,  2,  5,  4,  6,  7]
nxt = [*input[1:], input[0]]

nxt = dict(zip(input, nxt))

def print_list(x, f = 1):
    output = []
    output.append(f)
    for _ in range(2, len(x)+1):
        output.append(x[output[-1]])
    return output


def pick3(x, f):
    output = []
    output.append(x[f])
    output.append(x[output[-1]])
    output.append(x[output[-1]])
    return output

n = len(input)
cur = input[0]
for i in range(int(1e7)):
    if i % 100000 == 0:
        print(i)
    
    # Pick out next three
    pick = pick3(nxt, cur)
    
    target = n if cur == 1 else cur-1
    while target in pick:
        target = (target - 1) % n
        if target == 0:
            target = n
    
    tmp = nxt[pick[2]]
    nxt[cur] = tmp
    nxt[pick[2]]   = nxt[target]
    nxt[target]    = pick[0]
    cur = tmp
    
    


''.join(x for x in print_list(nxt, 1))
nxt[1] * nxt[nxt[1]]

# no language optimisations and still runs in under 10 seconds!
# what was the point of all that effort in R!! :'(
