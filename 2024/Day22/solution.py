# input = [int(x) for x in open('Day22\\example.txt').read().strip().split("\n")]
input = [int(x) for x in open('Day22\\input.txt').read().strip().split("\n")]

def one_round(num):
    num = (num ^ (num*64  )) % 16777216
    num = (num ^ (num//32 )) % 16777216
    num = (num ^ (num*2048)) % 16777216
    return num
  
def secret_number(initial, rounds):
    num =initial
    prices = [initial%10]
    for _ in range(rounds):
        num = one_round(num)
        prices.append(num % 10)
    return [num, prices]
    
def compute_changes(price_list):
    return [lead_val - val for val, lead_val in zip(price_list, price_list[1:])]
    
def pattern_score(price_list, change_list):
    scores = {}
    for i in range(len(change_list) - 3):
        pat = tuple(change_list[i:i+4])
        if pat not in scores:
            scores[pat] = price_list[i+4] 
    return scores


p1 = 0
prices = []
changes = []
all_scores = {}
for number in input:
    res = secret_number(number, 2000)
    prices.append(res[1])
    p1 += res[0]
    chg = compute_changes(res[1])
    changes.append(chg)
    # for each possible pattern present, compute the bananas that can be bought
    cur_score = pattern_score(res[1], chg)
    
    # maintain a full map of all possible patterns and their scores over all shops
    for key, item in cur_score.items():
        if key not in all_scores:
            all_scores[key] = item
        else:
            all_scores[key] += item
    
print(p1)
print(max(all_scores.values()))
