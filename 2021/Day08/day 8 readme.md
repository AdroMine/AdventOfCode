# Day 8: Seven Segment Search [Link](https://adventofcode.com/2021/day/8)

### Question Summary
- **Part 1** - Digital clocks with 7 segment displays. Letters are all scrambled up. Need to determine how many are 1, 4, 7 and 8 (which have unique number of segments lighting up)
- **Part 2** - Need to decode multiple displays with multiple orientations

### Solution summary 

The 7 segment display is in the following form (have assigned number to each position arbitrariliy)

```
#     1
#   -----
#  |     |  
# 6|     | 2
#  |  7  | 
#   -----
#  |     | 
# 5|     | 3
#  |     |  
#   -----
#     4
# 
```

Starting with the example input: acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab

Here we know that:

- 1 = ab based on length (but we don't know where is a & b)
- 7 = dab (and now we know in the display above '1' = d)
- 4 = eafb (and now we know positions 6,7 have the characters ef, but not sure where they
  individually fall)
- 8 = acedgfb (doesn't tell us much about where each character falls)

Thus we have:

```
#        d
#      -----
#     |     |  
#   fe|     | a, b
#     | ef  | 
#      -----
#     |     | 
#    5|     | b, a
#     |     |  
#      -----
#        4
#    
```

Next, we know that 2, 3, 5 are all have 5 segments. Thus 2, 3, 5 must be in cdfbe, gcdfa & fbcad

3 is the one that contains both digits of 1, thus it must have ab, so:
- 3 = fbcad

Now that we know 3, we know that it contains position 7, that it has common with 4. Thus position 7
must be f, and therfore position 6 will be e

```
#        d
#      -----
#     |     |  
#    e|     | a, b
#     |  f  | 
#      -----
#     |     | 
#    5|     | b, a
#     |     |  
#      -----
#        4
#    
```


Next, 5 contains both digits of 4 that are not in 1 (i.e. ef), so:
- 5 = cdfbe

Also, 5 contains only one digit of one in common, which is b, thus b must be in position 3, and
therefore position 2 must be a. Also, the last remaining character in 5 is c, which must be position
4. Thus we now have:


```
#        d
#      -----
#     |     |  
#    e|     | a
#     |  f  | 
#      -----
#     |     | 
#    5|     | b
#     |     |  
#      -----
#        c
#    
```

Only position 5 is left, which must be the remaining letter left, which is g. 


```
#        d
#      -----
#     |     |  
#    e|     | a
#     |  f  | 
#      -----
#     |     | 
#    g|     | b
#     |     |  
#      -----
#        c
```

Thus, we have now found where all these characters go. The remaining inputs can thus be identified
either by combining the positions here:
for instance, 0 = combination of positions 1 to 6 (everything except position 7), thus it will have
    characters deagbc. Similary we compute, 6 and 9
