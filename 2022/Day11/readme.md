# Day 11: [Monkey in the Middle](https://adventofcode.com/2022/day/11)

### Question Summary
- **Part 1** - Multiple monkeys with multiple numbers. Each monkey goes through each item, performs arithemtic operation (\* / +) then divides by 3, then performs a divisibility test and on its basis throws the item to some other monkey. Repeat this for 20 rounds and find how many items each monkey handled through the 20 rounds. Multiply the largest two. 
- **Part 2** - Rounds = 10k. No more divisibility by 3. 

### Solution summary 

Part 1 is straightforward. 

In Part2, since we are no longer dividing by 3, so the numbers just keep on increasing and quickly reach the limit of integers, becoming Inf and rendering divisibility tests useless. For divisibility test, since we are just taking modulo of `A*B`, we can also use `((A mod m) * B) mod m) mod m` instead. This gives the same results. 

However, since we also need to pass the number to pass (A * B) to some other monkey and ensure that we get same results, so instead of taking modulo using the divisor, we instead find the product of the divisors from all monkeys and take the modulo of current worry using this super modulo number. 


