def f(x):
    return (2 * (105161115450707 - ((649 + ((425 + (((((((((2 * (((854 + ((((464 + (87 + (((((2 *
        ((11 * (((((((((((723 + (((660 + ((2 * ((((((2 * (((((515 + ((955 + (2 * ((93 * (((220 +
            ((797 + (((8 * (505 + x)) - 704) / 8)) + 990)) / 3) - 147)) - 178))) / 5)) / 6) - 322)
            * 20) + 692)) - 631) + 420) + 213) / 2) + 696)) - 919)) + 110) / 3)) * 2) - 343) / 3) +
            112) * 2) - 522) / 3) - 331) / 3) + 78)) + 508)) - 542) / 4) - 564) * 2))) / 3) - 687) /
        2)) * 2) + 698)) - 954) / 2) - 210) * 2) + 28) / 3) - 744) / 11)) * 43)) / 2))) - 89661494901968


rng = (-89661494901968, 89661494901968)

import math
from scipy import optimize

sol = optimize.brentq(f, rng[0], rng[1])


# while True:
#     x1 = f(rng[0])
#     x2 = f(rng[1])
#     if x1 < 0 and x2 > 0 or x1 > 0 and x2 < 0:
#         new_rng = [x // 2 for x in rng]


#         pass
#     else:
#         print("redefine range! Both have same sign for {rng}")
#         break
