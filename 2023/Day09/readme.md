# Day 9: [Mirage Maintenance](https://adventofcode.com/2023/day/9)

### Question Summary
- **Part 1** - List of numbers. For each, keep differencing until we get all zero. Then take the sum of all last differences (which would be the next value in the list)
- **Part 2** - Predict first value. Compute the differences and from last diff to first, keep subtracting. 

### Solution summary 


First two are simple methods. 

A mathematical solution involves using [Lagrange Interpolation](https://mathworld.wolfram.com/LagrangeInterpolatingPolynomial.html). The given problem can be solved using this. [Video explanation](https://www.youtube.com/watch?v=4AuV93LOPcE)

