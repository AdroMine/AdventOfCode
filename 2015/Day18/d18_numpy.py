import sys
from typing import List, Dict
import numpy as np
import numpy.typing as npt
from scipy.ndimage import generic_filter

def lights_count(input: npt.NDArray, steps:int = 100, part2: bool = False) -> int:
    # generic filter takes the window of given size and returns it as a 1D vector
    # sum(x) - 1 (since element itself is True)
    fn = lambda x: sum(x) - 1 in [2,3] if x[4] else sum(x) == 3
    for _ in range(steps):
        input = generic_filter(input, size=(3,3), function = fn, mode = 'constant', cval=False)

        # add corners
        if part2:
            input[0,0] = True
            input[0, -1] = True
            input[-1, 0] = True
            input[-1, -1] = True
        
    return np.sum(input) 

        
if __name__ == '__main__':

    in_file = sys.argv[1] if len(sys.argv) > 1 else '2015\\Day18\\input.txt'

    # create 2D array (list of list)
    input = [[1 if c == '#' else 0 for c in line.strip()] for line in open(in_file).readlines()]
    
    # convert to numpy array
    input = np.array(input, dtype = bool)

    # Part 1 
    print(f"Part 1 = {lights_count(input, 100)}")

    # Part 2 
    print(f"Part 2 = {lights_count(input, 100, True)}")
