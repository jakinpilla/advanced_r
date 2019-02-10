Advanced\_R(chap\_3\_subsetting)
================
jakinpilla
2019-02-09

-   [Subsetting](#subsetting)
    -   [Data types](#data-types)
        -   [Atomic vectors](#atomic-vectors)
        -   [Lists](#lists)
        -   [Matrices and arrays](#matrices-and-arrays)
        -   [Data frames](#data-frames)
        -   [S3 objects](#s3-objects)
        -   [S4 objetcs](#s4-objetcs)
        -   [Exercise](#exercise)
    -   [Subsetting operators](#subsetting-operators)
        -   [Simlifying vs. preserving subsetting](#simlifying-vs.-preserving-subsetting)
        -   [`$`](#section)
    -   [Missing / out of bounds indices](#missing-out-of-bounds-indices)
        -   [Exercise](#exercise-1)
    -   [Subsetting and assignment](#subsetting-and-assignment)
    -   [Applications](#applications)
        -   [Lookup tables (character subsetting)](#lookup-tables-character-subsetting)
        -   [Matching and mersing by hand (integer subsetting)](#matching-and-mersing-by-hand-integer-subsetting)
        -   [Random samples/bootstrap (integer subseting)](#random-samplesbootstrap-integer-subseting)
        -   [Removing columns from data frames (character subsetting)](#removing-columns-from-data-frames-character-subsetting)
        -   [Selectig rows based on a condition (logical subsetting)](#selectig-rows-based-on-a-condition-logical-subsetting)
        -   [Boolean algebra vs. sets (logical & integer subsetting)](#boolean-algebra-vs.-sets-logical-integer-subsetting)

### Subsetting

#### Data types

##### Atomic vectors

``` r
x <- c(2.1, 4.2, 3.3, 5.4)
x[c(3, 1)]
```

    ## [1] 3.3 2.1

``` r
x[order(x)]
```

    ## [1] 2.1 3.3 4.2 5.4

``` r
x[c(1, 1)]
```

    ## [1] 2.1 2.1

``` r
x[c(2.1, 2.9)]
```

    ## [1] 4.2 4.2

``` r
x[-c(3, 1)]
```

    ## [1] 4.2 5.4

``` r
x[c(T, T, F, F)]
```

    ## [1] 2.1 4.2

``` r
x[x > 3]
```

    ## [1] 4.2 3.3 5.4

``` r
x[c(T, F)]
```

    ## [1] 2.1 3.3

``` r
x[c(T, T, NA, F)]
```

    ## [1] 2.1 4.2  NA

``` r
x[]
```

    ## [1] 2.1 4.2 3.3 5.4

``` r
y <- setNames(x, letters[1:4])
y
```

    ##   a   b   c   d 
    ## 2.1 4.2 3.3 5.4

``` r
y[c("d", "c", "a")]
```

    ##   d   c   a 
    ## 5.4 3.3 2.1

``` r
y[c("a", "a", "a")]
```

    ##   a   a   a 
    ## 2.1 2.1 2.1

``` r
z <- c(abc = 1, def = 2)
z[c("a", "d")]
```

    ## <NA> <NA> 
    ##   NA   NA

##### Lists

##### Matrices and arrays

``` r
a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a[1:2, ]
```

    ##      A B C
    ## [1,] 1 4 7
    ## [2,] 2 5 8

``` r
a[c(T, F, T), c("B", "A")]
```

    ##      B A
    ## [1,] 4 1
    ## [2,] 6 3

``` r
a[0, -2]
```

    ##      A C

``` r
val <- outer(1:5, 1:5, FUN = "paste",
             sep = ",")
val
```

    ##      [,1]  [,2]  [,3]  [,4]  [,5] 
    ## [1,] "1,1" "1,2" "1,3" "1,4" "1,5"
    ## [2,] "2,1" "2,2" "2,3" "2,4" "2,5"
    ## [3,] "3,1" "3,2" "3,3" "3,4" "3,5"
    ## [4,] "4,1" "4,2" "4,3" "4,4" "4,5"
    ## [5,] "5,1" "5,2" "5,3" "5,4" "5,5"

``` r
val[c(4, 15)]
```

    ## [1] "4,1" "5,3"

``` r
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")

select <- matrix(ncol =2, byrow = T, 
                 c(1, 1,
                   3, 1, 
                   2, 4))

vals[select]
```

    ## [1] "1,1" "3,1" "2,4"

##### Data frames

``` r
df <- data.frame(x = 1:3, y = 3:1, 
                 z = letters[1:3])
df[df$x == 2, ]
```

    ##   x y z
    ## 2 2 2 b

``` r
df[c("x", "z")]
```

    ##   x z
    ## 1 1 a
    ## 2 2 b
    ## 3 3 c

``` r
df[, c("x", "z")]
```

    ##   x z
    ## 1 1 a
    ## 2 2 b
    ## 3 3 c

There is an important difference if you select a single column : matrix subsetting simplifies by default, list subsetting does not.

``` r
str(df["x"]) # data.frame
```

    ## 'data.frame':    3 obs. of  1 variable:
    ##  $ x: int  1 2 3

``` r
str(df[, "x"]) # vector
```

    ##  int [1:3] 1 2 3

##### S3 objects

##### S4 objetcs

There are also two additional subsetting operators that are needed for S4 objects : `@` (equivalent `$`) and `slot()` (equivalent to `[[`). `@` is more resrictive than `$` in that it will return an error if the slot dose not exist.

##### Exercise

1.  Fix data frame sbsetting errors

``` r
mtcars[mtcars$cyl == 4, ]
```

    ##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
mtcars[1:4, ]
```

    ##                 mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4      21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag  21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710     22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1

``` r
mtcars[mtcars$cyl <= 5, ]
```

    ##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]
```

    ##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4      21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Valiant        18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280       19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C      17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

1.  What dose `x <- 1:5; x[NA]` yield five missing values?

``` r
x <- 1:5; 
x[NA]
```

    ## [1] NA NA NA NA NA

``` r
x[NA_real_]
```

    ## [1] NA

1.  What does upper.tri() return? How does subsetting a matrix with it work? Do we need any additional subsetting rules to describe its behaviour?

``` r
x <- outer(1:5, 1:5, FUN = "*")
upper.tri(x)
```

    ##       [,1]  [,2]  [,3]  [,4]  [,5]
    ## [1,] FALSE  TRUE  TRUE  TRUE  TRUE
    ## [2,] FALSE FALSE  TRUE  TRUE  TRUE
    ## [3,] FALSE FALSE FALSE  TRUE  TRUE
    ## [4,] FALSE FALSE FALSE FALSE  TRUE
    ## [5,] FALSE FALSE FALSE FALSE FALSE

``` r
x[upper.tri(x)]
```

    ##  [1]  2  3  6  4  8 12  5 10 15 20

1.  Why does `mtcars[1:20]`return error? (Error in `[.data.frame`(mtcars, 1:20) : undefined columns selected)

``` r
mtcars[1:20, ]
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1

1.  Implement your own function that extract the diagonal entries from a matrix.

2.  What dose `df[is.na(df)] <- 0` do?

#### Subsetting operators

``` r
b <- list(a = list(b = list(c = list(d = 1))))
b[["a"]][["b"]][["c"]][["d"]]
```

    ## [1] 1

##### Simlifying vs. preserving subsetting

**Atomic** vector

``` r
x <- c(a=1, b=2)
x[1] # preserving
```

    ## a 
    ## 1

``` r
x[[1]] # simpifying 
```

    ## [1] 1

**List**

``` r
y <- list(a=1, b=2)
str(y[1]) # preserving
```

    ## List of 1
    ##  $ a: num 1

``` r
str(y[[1]]) # simpifying 
```

    ##  num 1

**Factor** : drop any unused levels

``` r
z <- factor(c("a", "b"))
z[1] # preserving
```

    ## [1] a
    ## Levels: a b

``` r
z[1, drop = T] # simpifying 
```

    ## [1] a
    ## Levels: a

**Matrix or array** : if any of the dimension has length 1, drops that dimension

``` r
a <- matrix(1:4, nrow =2)
a[1, , drop = FALSE] # preserving
```

    ##      [,1] [,2]
    ## [1,]    1    3

``` r
a[1, ] # simpifying 
```

    ## [1] 1 3

**Data frame** : if output is a single column, returns a vector instead of a data frame

``` r
df <- data.frame(a =1:2, b = 1:2)
df
```

    ##   a b
    ## 1 1 1
    ## 2 2 2

``` r
str(df[1])
```

    ## 'data.frame':    2 obs. of  1 variable:
    ##  $ a: int  1 2

``` r
str(df[[1]]) # simpifying 
```

    ##  int [1:2] 1 2

``` r
str(df[, "a", drop = F])
```

    ## 'data.frame':    2 obs. of  1 variable:
    ##  $ a: int  1 2

``` r
str(df[, "a"]) # simpifying 
```

    ##  int [1:2] 1 2

##### `$`

x$y is equivalent to x\[\["y", exact = F\]\]

``` r
var <- "cyl"
mtcars$var
```

    ## NULL

``` r
mtcars[[var]]
```

    ##  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4

``` r
x <- list(abc =1)
x$a
```

    ## [1] 1

``` r
x[["a"]]
```

    ## NULL

#### Missing / out of bounds indices

``` r
x <- 1:4 
str(x[5])
```

    ##  int NA

``` r
str(x[NA_real_])
```

    ##  int NA

``` r
str(x[NULL])
```

    ##  int(0)

##### Exercise

`mod <- lm(mpg ~ wt, data = mtcars)`, Extract the residual degrees of freeom, Extract the R squared from the model summary

``` r
mod <- lm(mpg ~ wt, data = mtcars)
summary(mod)
```

    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = mtcars)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4.5432 -2.3647 -0.1252  1.4096  6.8727 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  37.2851     1.8776  19.858  < 2e-16 ***
    ## wt           -5.3445     0.5591  -9.559 1.29e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 3.046 on 30 degrees of freedom
    ## Multiple R-squared:  0.7528, Adjusted R-squared:  0.7446 
    ## F-statistic: 91.38 on 1 and 30 DF,  p-value: 1.294e-10

#### Subsetting and assignment

``` r
x <- 1:5
x[c(1, 2)] <- 2:3
x
```

    ## [1] 2 3 3 4 5

``` r
x[-1] <- 4:1
x
```

    ## [1] 2 4 3 2 1

``` r
x[c(1, 1)] <- 2:3
x
```

    ## [1] 3 4 3 2 1

``` r
x[c(T, F, NA)] <- 1
x
```

    ## [1] 1 4 3 1 1

``` r
mtcars[] <- lapply(mtcars, as.integer)
```

return a data.frame

``` r
mtcars <- lapply(mtcars, as.integer)
```

return list

With list, you can use `subsetting + assignment + NULL` to remove components from a list

``` r
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)
```

    ## List of 1
    ##  $ a: num 1

``` r
y <- list(a = 1)
y["b"] <- list(NULL)
str(y)
```

    ## List of 2
    ##  $ a: num 1
    ##  $ b: NULL

#### Applications

##### Lookup tables (character subsetting)

Character matching provides a powerful way to make lookup tables.

``` r
x <- c("m" ,"f", "u", "f", "f", "m", "m")
lookup <- c(m= "Male", f = "Female", u = NA)

lookup[x]
```

    ##        m        f        u        f        f        m        m 
    ##   "Male" "Female"       NA "Female" "Female"   "Male"   "Male"

``` r
unname(lookup[x])
```

    ## [1] "Male"   "Female" NA       "Female" "Female" "Male"   "Male"

``` r
c(m = "Known", f = "Known", u = "Unknown")[x]
```

    ##         m         f         u         f         f         m         m 
    ##   "Known"   "Known" "Unknown"   "Known"   "Known"   "Known"   "Known"

##### Matching and mersing by hand (integer subsetting)

``` r
grades <- c(1, 2, 2, 3, 1)

info <- data.frame(
  grade = 3:1, 
  desc = c("Excellent", "Good", "Poor"),
  fall = c(F, F, T)
)

id <- match(grades, info$grade)
info[id, ]
```

    ##     grade      desc  fall
    ## 3       1      Poor  TRUE
    ## 2       2      Good FALSE
    ## 2.1     2      Good FALSE
    ## 1       3 Excellent FALSE
    ## 3.1     1      Poor  TRUE

Using rownames...

``` r
rownames(info) <- info$grade
info[as.character(grades), ]
```

    ##     grade      desc  fall
    ## 1       1      Poor  TRUE
    ## 2       2      Good FALSE
    ## 2.1     2      Good FALSE
    ## 3       3 Excellent FALSE
    ## 1.1     1      Poor  TRUE

##### Random samples/bootstrap (integer subseting)

``` r
df <- data.frame(x = rep(1:3, each  =2), 
                 y = 6:1, 
                 z = letters[1:6])

set.seed(2019)

sample(nrow(df))
```

    ## [1] 5 4 2 6 1 3

``` r
df[sample(nrow(df)), ]
```

    ##   x y z
    ## 5 3 2 e
    ## 1 1 6 a
    ## 6 3 1 f
    ## 2 1 5 b
    ## 3 2 4 c
    ## 4 2 3 d

``` r
df[sample(nrow(df), 3), ]
```

    ##   x y z
    ## 2 1 5 b
    ## 1 1 6 a
    ## 3 2 4 c

Select 6 bootstrap replicates

``` r
df[sample(nrow(df), 6, rep =T), ]
```

    ##     x y z
    ## 4   2 3 d
    ## 1   1 6 a
    ## 5   3 2 e
    ## 3   2 4 c
    ## 3.1 2 4 c
    ## 3.2 2 4 c

Ordering (integer subsetting)

``` r
x <- c("b", "c", "a"); x
```

    ## [1] "b" "c" "a"

``` r
order(x)
```

    ## [1] 3 1 2

``` r
x[order(x)]
```

    ## [1] "a" "b" "c"

By default, any missing values will be put at the end of the vector; however, you can remove them with `na.last = NA` or put at the front with `na.list = FALSE`.

``` r
df2 <- df[sample(nrow(df)) , 3:1]
df2
```

    ##   z y x
    ## 4 d 3 2
    ## 5 e 2 3
    ## 1 a 6 1
    ## 6 f 1 3
    ## 3 c 4 2
    ## 2 b 5 1

``` r
df2[order(df2$x), ]
```

    ##   z y x
    ## 1 a 6 1
    ## 2 b 5 1
    ## 4 d 3 2
    ## 3 c 4 2
    ## 5 e 2 3
    ## 6 f 1 3

``` r
df2[, order(names(df2))]
```

    ##   x y z
    ## 4 2 3 d
    ## 5 3 2 e
    ## 1 1 6 a
    ## 6 3 1 f
    ## 3 2 4 c
    ## 2 1 5 b

``` r
df <- data.frame(x = c(2, 4, 1), 
                 y = c(9, 11, 6), 
                 n = c(3, 5, 1))

df[rep(1:nrow(df), df$n), ]
```

    ##     x  y n
    ## 1   2  9 3
    ## 1.1 2  9 3
    ## 1.2 2  9 3
    ## 2   4 11 5
    ## 2.1 4 11 5
    ## 2.2 4 11 5
    ## 2.3 4 11 5
    ## 2.4 4 11 5
    ## 3   1  6 1

##### Removing columns from data frames (character subsetting)

``` r
df <- data.frame(x = 1:3, 
                 y = 3:1, 
                 z = letters[1:3])
df$z <- NULL
df[setdiff(names(df), "z")]
```

    ##   x y
    ## 1 1 3
    ## 2 2 2
    ## 3 3 1

##### Selectig rows based on a condition (logical subsetting)

``` r
data("mtcars")
mtcars
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
mtcars[mtcars$gear == 5, ]
```

    ##                 mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2
    ## Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.5  0  1    5    4
    ## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.5  0  1    5    6
    ## Maserati Bora  15.0   8 301.0 335 3.54 3.570 14.6  0  1    5    8

``` r
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]
```

    ##                mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa  30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2

``` r
subset(mtcars, gear = 5)
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
subset(mtcars, gear == 5 & cyl == 4)
```

    ##                mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa  30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2

##### Boolean algebra vs. sets (logical & integer subsetting)

``` r
set.seed(2019)
sample(10)
```

    ##  [1]  8  7  3  5  1  6  4  9 10  2

``` r
x <- sample(10) <4
x
```

    ##  [1] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE

``` r
which(x)
```

    ## [1] 3 7 8

`which()` allows you to convert a boolean representation to an integer representation. There's no reverse operation in base in R but we can easily creat one.

``` r
unwhich <- function(x, n) {
  out <- rep_len(FALSE, n)
  out[x] <- T
  out
}

unwhich(which(x), 10)
```

    ##  [1] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE
