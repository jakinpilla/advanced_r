Advanced\_R(chap\_3\_subsetting)
================
jakinpilla
2019-12-21

  - [Subsetting](#subsetting)
      - [Data types](#data-types)
          - [Atomic vectors](#atomic-vectors)
          - [Lists](#lists)
          - [Matrices and arrays](#matrices-and-arrays)
          - [Data frames](#data-frames)
          - [S3 objects](#s3-objects)
          - [S4 objetcs](#s4-objetcs)
          - [Exercise](#exercise)
          - [Simlifying vs. preserving
            subsetting](#simlifying-vs.-preserving-subsetting)
          - [`$`](#section)
      - [Missing / out of bounds
        indices](#missing-out-of-bounds-indices)
          - [Exercise](#exercise-1)
      - [Subsetting and assignment](#subsetting-and-assignment)
      - [Applications](#applications)
          - [Lookup tables (character
            subsetting)](#lookup-tables-character-subsetting)
          - [Matching and mersing by hand (integer
            subsetting)](#matching-and-mersing-by-hand-integer-subsetting)
          - [Random samples/bootstrap (integer
            subseting)](#random-samplesbootstrap-integer-subseting)
          - [Removing columns from data frames (character
            subsetting)](#removing-columns-from-data-frames-character-subsetting)
          - [Selectig rows based on a condition (logical
            subsetting)](#selectig-rows-based-on-a-condition-logical-subsetting)
          - [Boolean algebra vs. sets (logical & integer
            subsetting)](#boolean-algebra-vs.-sets-logical-integer-subsetting)
      - [연습문제](#연습문제)

``` r
library(tidyverse)
```

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

There is an important difference if you select a single column : matrix
subsetting simplifies by default, list subsetting does not.

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

There are also two additional subsetting operators that are needed for
S4 objects : `@` (equivalent `$`) and `slot()` (equivalent to `[[`). `@`
is more resrictive than `$` in that it will return an error if the slot
dose not exist.

##### Exercise

1.  Fix data frame sbsetting errors

<!-- end list -->

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

2.  What dose `x <- 1:5; x[NA]` yield five missing values?

<!-- end list -->

``` r
x <- 1:5; 
x[NA]
```

    ## [1] NA NA NA NA NA

``` r
x[NA_real_]
```

    ## [1] NA

인덱스의 결측은 결과에도 항상 결측을 만듭니다.

3.  What does upper.tri() return? How does subsetting a matrix with it
    work? Do we need any additional subsetting rules to describe its
    behaviour?

<!-- end list -->

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

TRUE 인 부분에 해당하는 원소들이 벡터로 출력됩니다. 여기에서.추가적인 서브세팅 규칙이 필요한지 여부는 좀 더 살펴봐야 알 것
같습니다.

4.  Why does `mtcars[1:20]`return error? (Error in
    `[.data.frame`(mtcars, 1:20) : undefined columns selected) mtcars
    데이터는 데이터프레임 구조를 가지므로 1개의 벡터로 서브세팅하면 리스트처럼 동작하는데 열의 갯수가 11 뿐이므로
    범위를 초과하여 에러가 발생한 것입니다. mtcars\[1:6\]으로 범위 내에서 서브세팅하면 정상적으로 동작합니다.

5.  Implement your own function that extract the diagonal entries from a
    matrix.

대각원소를 추출하는 함수 `extract_diag`를 다음과 같이 작성하였습니다.

``` r
extract_diag <- function(mat) {
  n <- nrow(mat)
  select <- matrix(ncol = 2, byrow = T, 
                   rep(1:n, each = 2))
  return(mat[select])
}

test_mat <- matrix(1:25, ncol=5)

extract_diag(test_mat)
```

    ## [1]  1  7 13 19 25

6.  What dose `df[is.na(df)] <- 0` do?

하나의 작은 예를 만들어서 실험해 봅니다.

``` r
d <- data.frame(
  a = c(1, 2, 3),
  b = c(NA, 4, 5),
  c = c(6, 7, NA)
)

d[is.na(d)] <- 0

d 
```

    ##   a b c
    ## 1 1 0 6
    ## 2 2 4 7
    ## 3 3 5 0

결국, 원소 중에 있는 NA 값들을 0으로 치환시킵니다. \#\#\#\# Subsetting operators

서브세팅 연사자에는 `[[`와 `$`가 있습니다.

``` r
b <- list(a = list(b = list(c = list(d = 1))))
b[["a"]][["b"]][["c"]][["d"]]
```

    ## [1] 1

##### Simlifying vs. preserving subsetting

**Atomic** vector

``` r
x <- c(a=1, b=2)
x[1] 
```

    ## a 
    ## 1

``` r
x[[1]] # 이름이 제거된다.
```

    ## [1] 1

**List**

``` r
y <- list(a=1, b=2)
str(y[1]) 
```

    ## List of 1
    ##  $ a: num 1

``` r
str(y[[1]])  
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

**Matrix or array** : if any of the dimension has length 1, drops that
dimension

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

**Data frame** : if output is a single column, returns a vector instead
of a data frame

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

x$y is equivalent to x\[\[“y”, exact = F\]\]

`$`를 잘못 사용하는 흔한 사례는 변수에 저장된 열의 이름에 있을때 그것을 사용하려는 것입니다.

``` r
var <- "cyl"
mtcars$var # 잘못 사용한 예
```

    ## NULL

``` r
mtcars[[var]] # `[[`를 사용하면 됩니다.
```

    ##  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4

``` r
x <- list(abc =1)
x$a # $ 연산자는 partial matching을 합니다.
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

`mod <- lm(mpg ~ wt, data = mtcars)`, Extract the residual degrees of
freeom, Extract the R squared from the model summary

``` r
mod <- lm(mpg ~ wt, data = mtcars)
```

잔자의 자유도는 다음과 같이 추출할 수 있습니다.

``` r
mod$df.residual
```

    ## [1] 30

R-square는 다음과 같이 추출할 수 있습니다.

``` r
summary_obs <- summary(mod)
str(summary_obs)
```

    ## List of 11
    ##  $ call         : language lm(formula = mpg ~ wt, data = mtcars)
    ##  $ terms        :Classes 'terms', 'formula'  language mpg ~ wt
    ##   .. ..- attr(*, "variables")= language list(mpg, wt)
    ##   .. ..- attr(*, "factors")= int [1:2, 1] 0 1
    ##   .. .. ..- attr(*, "dimnames")=List of 2
    ##   .. .. .. ..$ : chr [1:2] "mpg" "wt"
    ##   .. .. .. ..$ : chr "wt"
    ##   .. ..- attr(*, "term.labels")= chr "wt"
    ##   .. ..- attr(*, "order")= int 1
    ##   .. ..- attr(*, "intercept")= int 1
    ##   .. ..- attr(*, "response")= int 1
    ##   .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
    ##   .. ..- attr(*, "predvars")= language list(mpg, wt)
    ##   .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
    ##   .. .. ..- attr(*, "names")= chr [1:2] "mpg" "wt"
    ##  $ residuals    : Named num [1:32] -2.28 -0.92 -2.09 1.3 -0.2 ...
    ##   ..- attr(*, "names")= chr [1:32] "Mazda RX4" "Mazda RX4 Wag" "Datsun 710" "Hornet 4 Drive" ...
    ##  $ coefficients : num [1:2, 1:4] 37.285 -5.344 1.878 0.559 19.858 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:2] "(Intercept)" "wt"
    ##   .. ..$ : chr [1:4] "Estimate" "Std. Error" "t value" "Pr(>|t|)"
    ##  $ aliased      : Named logi [1:2] FALSE FALSE
    ##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "wt"
    ##  $ sigma        : num 3.05
    ##  $ df           : int [1:3] 2 30 2
    ##  $ r.squared    : num 0.753
    ##  $ adj.r.squared: num 0.745
    ##  $ fstatistic   : Named num [1:3] 91.4 1 30
    ##   ..- attr(*, "names")= chr [1:3] "value" "numdf" "dendf"
    ##  $ cov.unscaled : num [1:2, 1:2] 0.38 -0.1084 -0.1084 0.0337
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:2] "(Intercept)" "wt"
    ##   .. ..$ : chr [1:2] "(Intercept)" "wt"
    ##  - attr(*, "class")= chr "summary.lm"

``` r
summary_obs$r.squared
```

    ## [1] 0.7528328

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
x # x의 첫번쩨 원소가 2였다가 3으로 변했다고 해석할 수 있습니다.
```

    ## [1] 3 4 3 2 1

``` r
x[c(T, F, NA)] <- 1 #' NA가 있는 정수 인덱스는 결합할 수 없습니다. 하지만 NA가 있는 논리형 인덱스는 결합할 수 있습니다.
x
```

    ## [1] 1 4 3 1 1

``` r
df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a
```

    ## [1]  0 10 NA

공백을 이용한 서브세팅은 원본 객체의 클래스와 구조를 유지합니다.

``` r
data('mtcars')
mtcars[] <- lapply(mtcars, as.integer)
mtcars %>% head # return a data.frame
```

    ##                   mpg cyl disp  hp drat wt qsec vs am gear carb
    ## Mazda RX4          21   6  160 110    3  2   16  0  1    4    4
    ## Mazda RX4 Wag      21   6  160 110    3  2   17  0  1    4    4
    ## Datsun 710         22   4  108  93    3  2   18  1  1    4    1
    ## Hornet 4 Drive     21   6  258 110    3  3   19  1  0    3    1
    ## Hornet Sportabout  18   8  360 175    3  3   17  0  0    3    2
    ## Valiant            18   6  225 105    2  3   20  1  0    3    1

``` r
mtcars <- lapply(mtcars, as.integer)
mtcars # return list
```

    ## $mpg
    ##  [1] 21 21 22 21 18 18 14 24 22 19 17 16 17 15 10 10 14 32 30 33 21 15 15
    ## [24] 13 19 27 26 30 15 19 15 21
    ## 
    ## $cyl
    ##  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4
    ## 
    ## $disp
    ##  [1] 160 160 108 258 360 225 360 146 140 167 167 275 275 275 472 460 440
    ## [18]  78  75  71 120 318 304 350 400  79 120  95 351 145 301 121
    ## 
    ## $hp
    ##  [1] 110 110  93 110 175 105 245  62  95 123 123 180 180 180 205 215 230
    ## [18]  66  52  65  97 150 150 245 175  66  91 113 264 175 335 109
    ## 
    ## $drat
    ##  [1] 3 3 3 3 3 2 3 3 3 3 3 3 3 3 2 3 3 4 4 4 3 2 3 3 3 4 4 3 4 3 3 4
    ## 
    ## $wt
    ##  [1] 2 2 2 3 3 3 3 3 3 3 3 4 3 3 5 5 5 2 1 1 2 3 3 3 3 1 2 1 3 2 3 2
    ## 
    ## $qsec
    ##  [1] 16 17 18 19 17 20 15 20 22 18 18 17 17 18 17 17 17 19 18 19 20 16 17
    ## [24] 15 17 18 16 16 14 15 14 18
    ## 
    ## $vs
    ##  [1] 0 0 1 1 0 1 0 1 1 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 0 0 1
    ## 
    ## $am
    ##  [1] 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1
    ## 
    ## $gear
    ##  [1] 4 4 4 3 3 3 3 4 4 4 4 3 3 3 3 3 3 4 4 4 3 3 3 3 3 4 5 5 5 5 5 4
    ## 
    ## $carb
    ##  [1] 4 4 1 1 2 1 4 2 2 4 4 3 3 3 4 4 4 1 2 1 1 2 2 4 2 1 2 2 4 6 8 2

With list, you can use `subsetting + assignment + NULL` to remove
components from a list

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

다음은 match()와 정수 서브세팅(integer subsetting)을 하는 예시입니다.

``` r
grades <- c(1, 2, 2, 3, 1)

info <- data.frame(
  grade = 3:1, 
  desc = c("Excellent", "Good", "Poor"),
  fall = c(F, F, T)
)

id <- match(grades, info$grade); id
```

    ## [1] 3 2 2 1 3

``` r
info[id, ]
```

    ##     grade      desc  fall
    ## 3       1      Poor  TRUE
    ## 2       2      Good FALSE
    ## 2.1     2      Good FALSE
    ## 1       3 Excellent FALSE
    ## 3.1     1      Poor  TRUE

Using rownames…

다음은 rowname()와 문자 서브세팅(character subsetting)을 하는 예시입니다.

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
df[sample(nrow(df), 6, rep =T), ] # 복원추출합니다.
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

``` r
x[order(x, decreasing = T)]
```

    ## [1] "c" "b" "a"

``` r
y <- c("b", "c", "a", NA, "s", "f", NA, NA, "x", "l"); y
```

    ##  [1] "b" "c" "a" NA  "s" "f" NA  NA  "x" "l"

``` r
order(y)
```

    ##  [1]  3  1  2  6 10  5  9  4  7  8

``` r
y[order(y)] # 기본적으로 NA가 마지막으로 할당된다.
```

    ##  [1] "a" "b" "c" "f" "l" "s" "x" NA  NA  NA

By default, any missing values will be put at the end of the vector;
however, you can remove them with `na.last = NA` or put at the front
with `na.list = FALSE`.

``` r
order(y, na.last = NA)
```

    ## [1]  3  1  2  6 10  5  9

``` r
y[order(y, na.last = NA)] # na.last = NA 옵션으로 마지막으로 할당되는 NA를 제거합니다.
```

    ## [1] "a" "b" "c" "f" "l" "s" "x"

``` r
order(y, na.last = FALSE)
```

    ##  [1]  4  7  8  3  1  2  6 10  5  9

``` r
y[order(y, na.last = FALSE)] # na.last = FALSE 옵션으로 마지막으로 할당되는 NA를 앞으로 보냅니다.
```

    ##  [1] NA  NA  NA  "a" "b" "c" "f" "l" "s" "x"

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

rep(1:nrow(df), df$n)
```

    ## [1] 1 1 1 2 2 2 2 2 3

``` r
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

제거하고자 하는 열을 NULL로 삭제할 수 있습니다.

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

단지 원하는 열만 반환되도록 서브세팅할 수 있습니다.

``` r
df[c('x', 'y')]
```

    ##   x y
    ## 1 1 3
    ## 2 2 2
    ## 3 3 1

만약 원하지 않는 열을 알고 있다면 집합연산(set operation)을 사용하여 유지할 열을 선택할 수 있습니다.

``` r
df[setdiff(names(df), 'z')]
```

    ##   x y
    ## 1 1 3
    ## 2 2 2
    ## 3 3 1

##### Selectig rows based on a condition (logical subsetting)

``` r
data("mtcars")
mtcars %>% head
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

``` r
mtcars[mtcars$gear == 5, ] %>% head
```

    ##                 mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2
    ## Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.5  0  1    5    4
    ## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.5  0  1    5    6
    ## Maserati Bora  15.0   8 301.0 335 3.54 3.570 14.6  0  1    5    8

``` r
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ] # 드 모르간의 법칙을 기억합시다.
```

    ##                mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa  30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2

``` r
subset(mtcars, gear = 5) %>% head
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

``` r
subset(mtcars, gear == 5 & cyl == 4)
```

    ##                mpg cyl  disp  hp drat    wt qsec vs am gear carb
    ## Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
    ## Lotus Europa  30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2

##### Boolean algebra vs. sets (logical & integer subsetting)

``` r
set.seed(2019)
sample(10)
```

    ##  [1]  8  7  3  5  1  6  4  9 10  2

``` r
x <- sample(10) < 4
x
```

    ##  [1] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE

which() 는 불리언 표현을 정수 표현으로 변환합니다.

``` r
which(x) 
```

    ## [1] 3 7 8

`which()` allows you to convert a boolean representation to an integer
representation. There’s no reverse operation in base in R but we can
easily creat one.

``` r
unwhich <- function(x, n) {
  out <- rep_len(FALSE, n)
  out[x] <- T
  out
}

unwhich(which(x), 10)
```

    ##  [1] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE

두 논리형 벡터와 이와 대응하는 정수형 벡터를 각각 생성하고 불리언 연산과 집합 연산의 관계를 알아봅니다.

``` r
x1 <- 1:10 %% 2 == 0; x1
```

    ##  [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE

``` r
x2 <- which(x1);x2
```

    ## [1]  2  4  6  8 10

``` r
y1 <- 1:10 %% 5 == 0; y1
```

    ##  [1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE

``` r
y2 <- which(y1) ; y2
```

    ## [1]  5 10

``` r
# X & Y <-> intersect(x, y)
x1 & y1
```

    ##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE

``` r
intersect(x2, y2)
```

    ## [1] 10

``` r
# X | Y <-> union(x, y)
x1 | y1
```

    ##  [1] FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE

``` r
union(x2, y2)
```

    ## [1]  2  4  6  8 10  5

``` r
# X & !Y <-> setdiff(x, y)
x1 & !y1
```

    ##  [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE

``` r
setdiff(x2, y2)
```

    ## [1] 2 4 6 8

``` r
# xor(X, Y) <-> setdiff(union(x, y), intersect(x, y))
xor(x1, y1)
```

    ##  [1] FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE

``` r
setdiff(union(x2, y2), intersect(x2, y2))
```

    ## [1] 2 4 6 8 5

#### 연습문제

1.  데이터 프레임이 열을 무작위적으로 치환하는 방법은 무엇인가? 한 번에 열과 행을 동시에 치환할 수 있는가?

먼저 iris 데이터에서 무작위로 3개의 열으르 선택하는 코드를 생각해보겠습니다.

``` r
iris[, sample(ncol(iris), 3)] %>% head
```

    ##   Petal.Length Species Petal.Width
    ## 1          1.4  setosa         0.2
    ## 2          1.4  setosa         0.2
    ## 3          1.3  setosa         0.2
    ## 4          1.5  setosa         0.2
    ## 5          1.4  setosa         0.2
    ## 6          1.7  setosa         0.4

그리고 행도 동시에 치환해보는 코드를 생각해보겠습니다.

``` r
iris[sample(nrow(iris)), sample(ncol(iris), 3)] %>% head
```

    ##     Sepal.Length    Species Petal.Width
    ## 89           5.6 versicolor         1.3
    ## 142          6.9  virginica         2.3
    ## 93           5.8 versicolor         1.2
    ## 67           5.6 versicolor         1.5
    ## 95           5.6 versicolor         1.3
    ## 2            4.9     setosa         0.2

이를 응용해 어떤 data.frame에 대해 열고 행을 동시에 무작위로 치환할 수 있는 함수를 제작해 보겠습니다.

``` r
random_row_col <- function(df) {
  df <- df[sample(nrow(df)), sample(ncol(df))]
  return(df)
}

i <- 1
while (i <= 5) {
  cat(i, "번째 데이터프레임입니다.\n")
  print(random_row_col(iris) %>% head)
  i <- i + 1
}
```

    ## 1 번째 데이터프레임입니다.
    ##     Sepal.Width    Species Petal.Length Sepal.Length Petal.Width
    ## 101         3.3  virginica          6.0          6.3         2.5
    ## 38          3.6     setosa          1.4          4.9         0.1
    ## 82          2.4 versicolor          3.7          5.5         1.0
    ## 31          3.1     setosa          1.6          4.8         0.2
    ## 49          3.7     setosa          1.5          5.3         0.2
    ## 56          2.8 versicolor          4.5          5.7         1.3
    ## 2 번째 데이터프레임입니다.
    ##     Petal.Width Sepal.Length Sepal.Width Petal.Length    Species
    ## 128         1.8          6.1         3.0          4.9  virginica
    ## 78          1.7          6.7         3.0          5.0 versicolor
    ## 70          1.1          5.6         2.5          3.9 versicolor
    ## 49          0.2          5.3         3.7          1.5     setosa
    ## 86          1.6          6.0         3.4          4.5 versicolor
    ## 146         2.3          6.7         3.0          5.2  virginica
    ## 3 번째 데이터프레임입니다.
    ##     Petal.Length Sepal.Length Sepal.Width Petal.Width    Species
    ## 102          5.1          5.8         2.7         1.9  virginica
    ## 134          5.1          6.3         2.8         1.5  virginica
    ## 149          5.4          6.2         3.4         2.3  virginica
    ## 69           4.5          6.2         2.2         1.5 versicolor
    ## 114          5.0          5.7         2.5         2.0  virginica
    ## 95           4.2          5.6         2.7         1.3 versicolor
    ## 4 번째 데이터프레임입니다.
    ##     Petal.Width Petal.Length Sepal.Length Sepal.Width    Species
    ## 135         1.4          5.6          6.1         2.6  virginica
    ## 26          0.2          1.6          5.0         3.0     setosa
    ## 48          0.2          1.4          4.6         3.2     setosa
    ## 138         1.8          5.5          6.4         3.1  virginica
    ## 95          1.3          4.2          5.6         2.7 versicolor
    ## 56          1.3          4.5          5.7         2.8 versicolor
    ## 5 번째 데이터프레임입니다.
    ##     Petal.Length    Species Sepal.Length Petal.Width Sepal.Width
    ## 116          5.3  virginica          6.4         2.3         3.2
    ## 90           4.0 versicolor          5.5         1.3         2.5
    ## 39           1.3     setosa          4.4         0.2         3.0
    ## 145          5.7  virginica          6.7         2.5         3.3
    ## 57           4.7 versicolor          6.3         1.6         3.3
    ## 70           3.9 versicolor          5.6         1.1         2.5

2.  데이터 프레임에서 어떻게 m행의 무작위 샘플을 선택할 수 있는가? 인접한 샘플을 선택해야 한다면 어떻게 해야 하는가?
    (즉, 최초의 행과 마지막 행, 그리고 그 사이의 모든 행)

m개의 무작위 샘플을 추출하는 함수를 제작합니다.

``` r
df_extract_shuffle <- function(df, m) {
  sample_idx <- sample(1:nrow(df), m)
  df_extracted <- df[sample_idx, ]
  
  return(df_extracted)
}

df_extract_shuffle(iris, 50) %>% head
```

    ##     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
    ## 51           7.0         3.2          4.7         1.4 versicolor
    ## 105          6.5         3.0          5.8         2.2  virginica
    ## 58           4.9         2.4          3.3         1.0 versicolor
    ## 65           5.6         2.9          3.6         1.3 versicolor
    ## 60           5.2         2.7          3.9         1.4 versicolor
    ## 140          6.9         3.1          5.4         2.1  virginica

최초의 행과 마지막 행, 그리고 그 사이의 모든 행을 선택하는 함수를 제작합니다.

``` r
df_extract_bwn_m_n <- function(df, m, n) {
  idx <- m:n
  df_extracted <- df[idx, ]
  
  return(df_extracted)
}
df_extract_bwn_m_n(iris, 51, 100) %>% head
```

    ##    Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
    ## 51          7.0         3.2          4.7         1.4 versicolor
    ## 52          6.4         3.2          4.5         1.5 versicolor
    ## 53          6.9         3.1          4.9         1.5 versicolor
    ## 54          5.5         2.3          4.0         1.3 versicolor
    ## 55          6.5         2.8          4.6         1.5 versicolor
    ## 56          5.7         2.8          4.5         1.3 versicolor

3.  어떻게 데이터 프레임에 알파벳 순으로 열을 삽입할 수 있는가?

<!-- end list -->

``` r
data("mtcars")

col_orderd_df <- function(df) {
  ordered_col_nm <- df %>% colnames() %>% sort()
  return(df[, ordered_col_nm])
}

col_orderd_df(mtcars) %>% head
```

    ##                   am carb cyl disp drat gear  hp  mpg  qsec vs    wt
    ## Mazda RX4          1    4   6  160 3.90    4 110 21.0 16.46  0 2.620
    ## Mazda RX4 Wag      1    4   6  160 3.90    4 110 21.0 17.02  0 2.875
    ## Datsun 710         1    1   4  108 3.85    4  93 22.8 18.61  1 2.320
    ## Hornet 4 Drive     0    1   6  258 3.08    3 110 21.4 19.44  1 3.215
    ## Hornet Sportabout  0    2   8  360 3.15    3 175 18.7 17.02  0 3.440
    ## Valiant            0    1   6  225 2.76    3 105 18.1 20.22  1 3.460

만약 문제의 의도가 알파벳 컬럼을 삽입하는 것이라면 다음과 같이 해결합니다.

``` r
insert_alphabet_col <- function(df) {
  n <- nrow(df)
  vec.letters <- c()
  while(n >= length(vec.letters)) {
    vec.letters <- c(vec.letters, letters)
  }
  
  df.letters <- vec.letters[1:nrow(df)]
  
  df$alphabet <- df.letters
  
  return(df)
}

data("mtcars")
insert_alphabet_col(mtcars) %>% head
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
    ##                   alphabet
    ## Mazda RX4                a
    ## Mazda RX4 Wag            b
    ## Datsun 710               c
    ## Hornet 4 Drive           d
    ## Hornet Sportabout        e
    ## Valiant                  f

``` r
insert_alphabet_col(mtcars) %>% tail
```

    ##                 mpg cyl  disp  hp drat    wt qsec vs am gear carb alphabet
    ## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2        a
    ## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2        b
    ## Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.5  0  1    5    4        c
    ## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.5  0  1    5    6        d
    ## Maserati Bora  15.0   8 301.0 335 3.54 3.570 14.6  0  1    5    8        e
    ## Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.6  1  1    4    2        f
