# Day 15: [Science for Hungry People](https://adventofcode.com/2015/day/15)

### Question Summary
- **Part 1** - Given a set of ingredients and the value of their properties, find a combination of these ingredients (integer amounts, total = 100) that has highest food score. Score is calculated by multiplying the count of ingredients used in recipe with their property and summing over all ingredients used in recipe. Total score is product of scores across the various properties
- **Part 2** - Only consider recipes that have a calorie count of 500

### Solution summary 

Use itertools.combinations with replacements to generate all possible combinations of ingredients that sum to 100. For each combination compute score and find max. 