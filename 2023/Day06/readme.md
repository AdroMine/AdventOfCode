# Day 6: [Wait For It](https://adventofcode.com/2023/day/6)

### Question Summary
- **Part 1** - Given time available and distance to be travelled. Speed is number of seconds you wait at the start. Find how many ways you can win for each race and multiply these together. 
- **Part 2** - Combine the times and distance into one large time and distance and repeat. 

### Solution summary 

Uses vectorised method. 

Part 2 also uses the same method and doesn't run into any problem. 


For non brute force method, we can generate the following equation:


We have equation for distance travelled:  $x * (T - x)$

where $x$ is time we pause in the beginning (and therefore the spped)

while $T$ is the total time available for the given race. 

If we have $D$ as the previous distance that needs to be beaten, then we want:


 $xT - x^2 > D$

or 

$-x^2 + xT - D > 0$

We can thus solve for $-x^2 + xT - D = 0$ which is a quadratic equation and gives a parabola that opens downward. The two solutions for this equationi will be the two `speeds` for which we reach the previous recorded distance. Any valid speed between these points will take us further than the previous record. 

The solution for quadratic equation is:

$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

Which for our case becomes:

$$ 
x = \frac{-T \mp \sqrt{(-T)^2 - 4 \times (-1) \times (-D)}}{2 \times -1}
$$

or

$$
x = \frac{T \mp \sqrt{T^2 - 4D}}{2}
$$

Once we get two values of `x` here, we find the integers between these, which is the number of ways that can be used to win. 
