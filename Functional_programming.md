Advanced\_R(chap\_2)
================
jakinpilla
2019-03-04

-   [Anonymous functions](#anonymous-functions)

``` r
set.seed(1014)

df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep =T)))
names(df) <- letters[1:6]

df
```

    ##    a  b c   d   e f
    ## 1  1  6 1   5 -99 1
    ## 2 10  4 4 -99   9 3
    ## 3  7  9 5   4   1 4
    ## 4  2  9 3   8   6 8
    ## 5  1 10 5   9   8 6
    ## 6  6  2 1   3   8 5

``` r
df$a[df$a == -99] <- NA
df$b[df$b == -99] <- NA
df$c[df$c == -98] <- NA
df$d[df$d == -99] <- NA
df$e[df$e == -99] <- NA
df$f[df$g == -99] <- NA
```

do not repeat yourself : DRY

``` r
fix_missing <- function(x) {
  x[x == -99] <- NA
  x
}

df$a <- fix_missing(df$a)
df$b <- fix_missing(df$b)
df$c <- fix_missing(df$c)
df$d <- fix_missing(df$d)
df$e <- fix_missing(df$e)
df$f <- fix_missing(df$e)

fix_missing <- function(x) {
  x[x == -99] <- NA
  x
}

df[] <- lapply(df, fix_missing)

df[1:5] <- lapply(df[1:5], fix_missing)


missing_fixer <- function(na_value) {
  function(x) {
    x[x == na_value] <- NA
    x
  }
}


fix_missing_99 <- missing_fixer(-99)
fix_missing_999 <- missing_fixer(-999)

fix_missing_99(c(-99, -999))
```

    ## [1]   NA -999

``` r
fix_missing_999(c(-99, -999))
```

    ## [1] -99  NA

``` r
fix_missing <- function(x, na.value) {
  x[x == na.value] <- NA
  x
}

summary <- function(x) {
  funs <- c(mean, median, sd, mad, IQR)
  lapply(funs, function(f) f(x, na.rm = T))
}

lapply(df, summary)
```

    ## $a
    ## $a[[1]]
    ## [1] 4.5
    ## 
    ## $a[[2]]
    ## [1] 4
    ## 
    ## $a[[3]]
    ## [1] 3.72827
    ## 
    ## $a[[4]]
    ## [1] 4.4478
    ## 
    ## $a[[5]]
    ## [1] 5.5
    ## 
    ## 
    ## $b
    ## $b[[1]]
    ## [1] 6.666667
    ## 
    ## $b[[2]]
    ## [1] 7.5
    ## 
    ## $b[[3]]
    ## [1] 3.204164
    ## 
    ## $b[[4]]
    ## [1] 2.9652
    ## 
    ## $b[[5]]
    ## [1] 4.5
    ## 
    ## 
    ## $c
    ## $c[[1]]
    ## [1] 3.166667
    ## 
    ## $c[[2]]
    ## [1] 3.5
    ## 
    ## $c[[3]]
    ## [1] 1.834848
    ## 
    ## $c[[4]]
    ## [1] 2.2239
    ## 
    ## $c[[5]]
    ## [1] 3.25
    ## 
    ## 
    ## $d
    ## $d[[1]]
    ## [1] 5.8
    ## 
    ## $d[[2]]
    ## [1] 5
    ## 
    ## $d[[3]]
    ## [1] 2.588436
    ## 
    ## $d[[4]]
    ## [1] 2.9652
    ## 
    ## $d[[5]]
    ## [1] 4
    ## 
    ## 
    ## $e
    ## $e[[1]]
    ## [1] 6.4
    ## 
    ## $e[[2]]
    ## [1] 8
    ## 
    ## $e[[3]]
    ## [1] 3.209361
    ## 
    ## $e[[4]]
    ## [1] 1.4826
    ## 
    ## $e[[5]]
    ## [1] 2
    ## 
    ## 
    ## $f
    ## $f[[1]]
    ## [1] 6.4
    ## 
    ## $f[[2]]
    ## [1] 8
    ## 
    ## $f[[3]]
    ## [1] 3.209361
    ## 
    ## $f[[4]]
    ## [1] 1.4826
    ## 
    ## $f[[5]]
    ## [1] 2

Anonymous functions
-------------------

``` r
lapply(mtcars, function(x) length(unique(x)))
```

    ## $mpg
    ## [1] 25
    ## 
    ## $cyl
    ## [1] 3
    ## 
    ## $disp
    ## [1] 27
    ## 
    ## $hp
    ## [1] 22
    ## 
    ## $drat
    ## [1] 22
    ## 
    ## $wt
    ## [1] 29
    ## 
    ## $qsec
    ## [1] 30
    ## 
    ## $vs
    ## [1] 2
    ## 
    ## $am
    ## [1] 2
    ## 
    ## $gear
    ## [1] 3
    ## 
    ## $carb
    ## [1] 6

``` r
Filter(function(x) !is.numeric(x), mtcars)
```

    ## data frame with 0 columns and 32 rows

``` r
integrate(function(x) sin(x)^2, 0, pi)
```

    ## 1.570796 with absolute error < 1.7e-14

``` r
formals(function(x = 4) g(x) + h(x))
```

    ## $x
    ## [1] 4

``` r
body(function(x = 4) g(x) + h(x))
```

    ## g(x) + h(x)

``` r
environment(function(x = 4) g(x) + h(x))
```

    ## <environment: R_GlobalEnv>
