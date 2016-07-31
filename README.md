# views_stats

## Solution to the Linear Regression with OLS task in main.m
Solved in matlab.

### 1. 
I subtracted first column (of string format) from csv data by hand, needs to be done automatically later
    Basic statistics of v(168):
    
    n     | range       | mean      | standard deviation  | variance        | min      |  max
    24.00 | 15263466.00 | 376765.52 | 923646.74           | 853123300284.21 | 21173.00 | 15284639.00
    72.0  | 22890539.00 | 613303.34 | 1653969.42          | 2735614853263.51| 26162.00 | 22916701.00
    168.00| 27871098.00 | 743209.84 | 2007963.83          | 4031918747457.98|27139.00  | 27898237.00
  
### 2.
Distribution of v(168) in file lognorm_dist.png. Distribution of v(168) is a log-normal distribution, what can be seen by plotting this distribution on logscale in x axis - which is a gaussian curve
	
### 3
Log-transforming x axis on a v(168) gives a gaussian curve, therefore, as gaussian curve is informally called bell curve - it indeed rings a bell.
  
### 5.
Correlation coefficients saved to results.txt file, (with bad formatting, needs to be improved)
  

### 10.
Final plot of mRSE in mRSE.png file. The multiple-input linear regression doesn't exactly look like expected,
	 therefore solution needs a double check. One of the possibilities of such behaviour can be normal equation,
	as elements in the matrix can be ~10^6, which makes inverting prone to numerical errors.
    
