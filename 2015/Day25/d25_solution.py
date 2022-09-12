def find_code(row, col, mul=252533, div=33554393, init=20151125) -> int:
    # max row to reach given row,col = row + col - 1, we also subtract another 1, since we already have (1,1)
    # at the start of any given row, we have gone through (1 + 2 + ... + n) numbers
    # also to reach row, column, we need to determine where this diagonal starts, it starts at row + column - 1
    # (we need to go column - 1 numbers)
    # given these two, we determine max_row, the one where our diagonal of interest starts
    # and then the number of computations to reach this state from (1,1)
    # then we go ahead column numbers to reach our goal
    max_row = row + col - 1 - 1
    n = (max_row + 1) * max_row // 2 + col - 1
    ans = init
    for _ in range(n):
        ans = (ans * mul) % div
    return ans


def find_code_mod_exp(row, col, mul=252533, div=33554393, init=20151125) -> int:
    # use modular exponentiation
    # we are essentially raising mul to power N using modular exponentiation
    # then multiply by init and take another mod
    max_row = row + col - 1 - 1
    N = (max_row + 1) * max_row // 2 + col - 1
    return init * pow(mul, N, div) % div


if __name__ == "__main__":

    # To continue, please consult the code grid in the manual.  Enter the code at row 2978, column 3083.
    row = 2978
    column = 3083

    mul = 252533
    div = 33554393

    print(find_code_mod_exp(row, column, mul, div))
    # print(20151125 * pow(mul, sum(range(row + column - 1)) + column - 1, div) % div)
