def lowest_house(reqd_num: int, N: int) -> tuple[int, int]:
    # find all divisors up to N
    divisors1 = [[] for k in range(N)]
    divisors2 = [[] for k in range(N)]
    for i in range(2, N):
        count = 0
        for j in range(i, N, i):
            divisors1[j].append(i)
            count += 1
            if count <= 50:
                divisors2[j].append(i)

    # Part 1
    i = 0
    for i in range(N):
        presents = sum(divisors1[i])*10 + 10
        if presents > reqd_num:
            break
    part1 = i

    # Part 2
    for i in range(N):
        presents = sum(divisors2[i])*11 + 11
        if presents > reqd_num:
            break
    part2 = i
    
    return part1, part2


if __name__ == '__main__':

    # in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day19\\input.txt'
    puzzle_input = 36000000

    part1, part2 = lowest_house(puzzle_input, int(1e6))
    print(f"Part 1 = {part1}")
    print(f"Part 2 = {part2}")

