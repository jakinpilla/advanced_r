Advanced\_R(chap\_5\_style\_guide)
================
jakinpilla
2019-02-12

-   [Functions](#functions)
    -   [Function components](#function-components)
        -   [Primitive functions](#primitive-functions)
    -   [Lexical scoping](#lexical-scoping)
        -   [Name masking](#name-masking)
        -   [Functions vs variables](#functions-vs-variables)
        -   [A fresh start](#a-fresh-start)
        -   [Dynamic lookup](#dynamic-lookup)
        -   [Exercise](#exercise)
    -   [Every operation is a function call](#every-operation-is-a-function-call)
    -   [Function arguments](#function-arguments)
        -   [Calling functions](#calling-functions)
        -   [Default and missing arguments](#default-and-missing-arguments)
        -   [Lazy evaluation](#lazy-evaluation)
    -   [`...`](#section)
        -   [Exercise](#exercise-1)
    -   [Special call](#special-call)
        -   [infix funciton](#infix-funciton)
-   [replace function](#replace-function)
    -   [연습문제](#연습문제)
-   [반환값](#반환값)
    -   [나가기](#나가기)
    -   [연습문제](#연습문제-1)

### Functions

#### Function components

``` r
f <- function(x) x^2
f
```

    ## function(x) x^2

``` r
formals(f)
```

    ## $x

``` r
body(f)
```

    ## x^2

``` r
environment(f)
```

    ## <environment: R_GlobalEnv>

##### Primitive functions

``` r
sum
```

    ## function (..., na.rm = FALSE)  .Primitive("sum")

``` r
formals(sum)
```

    ## NULL

``` r
body(sum)
```

    ## NULL

``` r
environment(sum)
```

    ## NULL

1.  What function allows you to tell if an object is a function? What function allows you to tell if a funcion is a primitive function?

2.  This code makes a list of all functions in the base package/

``` r
objs <- mget(ls("package:base"), inherits = T)
funs <- Filter(is.function, objs)
```

-   Which base function has the most arguments?

-   How many base functions have no arguments? What's special about those functions?

-   How couid you adapt the code to find all primitive functions?

#### Lexical scoping

``` r
x <- 10
x
```

    ## [1] 10

##### Name masking

``` r
f <- function() {
  x <- 1
  y <- 2
  c(x, y)
}

f()
```

    ## [1] 1 2

``` r
rm(f)

x <- 2
g <- function() {
  y <- 1
  c(x, y)
}

g()
```

    ## [1] 2 1

``` r
rm(x, g)

x <- 1
h <- function() {
  y <- 2
  i <- function() {
    z <- 3
    c(x, y, z)
  }
  i()
}

h()
```

    ## [1] 1 2 3

``` r
rm(x, h)

j <- function(x) {
  y <- 2
  function() {
    c(x, y)
  }
}

k <- j(1)

k()
```

    ## [1] 1 2

``` r
rm(j, k)
```

##### Functions vs variables

``` r
l <- function(x) x + 1
m <- function() {
 l <- function(x) x * 2
 l(10)
}

m()
```

    ## [1] 20

``` r
rm(l, m)

n <- function(x) x/2
o <- function() {
  n <- 10
  n(n)
}

o()
```

    ## [1] 5

``` r
rm(n, o)
```

##### A fresh start

``` r
j <- function() {
  if(!exists("a")) {
    a <- 1
  } else {
    a <- a +1
  }
  a
}

j()
```

    ## [1] 1

``` r
rm(j)
```

##### Dynamic lookup

``` r
f <- function() x
x <- 15
f()
```

    ## [1] 15

``` r
x <- 20
f()
```

    ## [1] 20

``` r
f <- function() x + 1
codetools::findGlobals(f)
```

    ## [1] "+" "x"

``` r
# environment(f) <- emptyenv()
# f()

`(` <- function(e1) {
  if(is.numeric(e1) && runif(1) < .1) {
    e1 + 1
  } else {
    e1
  }
}

replicate(50, (1+2))
```

    ##  [1] 3 3 3 3 4 3 3 4 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 3 3 3 3 3
    ## [36] 3 3 3 3 3 4 3 3 3 3 3 3 3 3 3

``` r
rm("(")
```

##### Exercise

1.  What does the following code return? Why? What does each of the three c's mean?

``` r
c <- 10
c(c = c)
```

    ##  c 
    ## 10

1.  What are the four principles that govern how R looks for values?

2.  What does the following function return? Make a prediction before running the code yourself?

``` r
f <- function(x) {
  f <- function(x) {
    f <- function(x) {
      x ^ 2
    }
    f(x) + 1
  }
  f(x) + 2
}

f(10)
```

    ## [1] 103

#### Every operation is a function call

To understand computations in R, two slogans are helpful:

-   Everything that exist is an object

-   Everything that happens is a function call

``` r
x <- 10; y <- 5
x + y
```

    ## [1] 15

``` r
`+`(x, y)
```

    ## [1] 15

``` r
`for`(i, 1:2, print(i))
```

    ## [1] 1
    ## [1] 2

``` r
if (i == 1) print("yes!") else print("no.")
```

    ## [1] "no."

``` r
`if`(i == 1, print("yes!"), print("no."))
```

    ## [1] "no."

``` r
x[3]
```

    ## [1] NA

``` r
`[`(x, 3)
```

    ## [1] NA

``` r
{print(1); print(2); print(3)}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3

``` r
`{`(print(1), print(2), print(3))
```

    ## [1] 1
    ## [1] 2
    ## [1] 3

``` r
add <- function(x, y) x + y
sapply(1:10, add, 3)
```

    ##  [1]  4  5  6  7  8  9 10 11 12 13

``` r
sapply(1:5, `+`, 3)
```

    ## [1] 4 5 6 7 8

``` r
sapply(1:5, "+", 3) # sapply() can be given the name of a function instead of the function itself.
```

    ## [1] 4 5 6 7 8

``` r
x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
```

    ## [1]  2  5 11

``` r
sapply(x, function(x) x[2])
```

    ## [1]  2  5 11

#### Function arguments

##### Calling functions

``` r
f <- function(abcdef, bcde1, bcde2) {
  list(a = abcdef, b1 = bcde1, b2 = bcde2)
}

str(f(1, 2, 3))
```

    ## List of 3
    ##  $ a : num 1
    ##  $ b1: num 2
    ##  $ b2: num 3

``` r
str(f(2, 3, abcdef = 1))
```

    ## List of 3
    ##  $ a : num 1
    ##  $ b1: num 2
    ##  $ b2: num 3

Can abbreviate long argument names:

``` r
str(f(2, 3, a =1))
```

    ## List of 3
    ##  $ a : num 1
    ##  $ b1: num 2
    ##  $ b2: num 3

But this doesn't work because abbreviation is ambiguous \`str(f(1, 3, b = 1))\`\`

``` r
mean(1:10)
```

    ## [1] 5.5

``` r
mean(1:10, trim = 0.05)
```

    ## [1] 5.5

``` r
mean(x = 1:10) # this is probably overkill
```

    ## [1] 5.5

``` r
mean(1:10, n = T)
```

    ## [1] 5.5

``` r
mean(1:10, , FALSE)
```

    ## [1] 5.5

``` r
mean(1:10, 0.05)
```

    ## [1] 5.5

``` r
mean(, TRUE, x = c(1:10, NA))
```

    ## [1] 5.5

``` r
args <- list(1:10, na.rm = T)
```

How could you then send that list to mean()? You need \`do.call()\`\`

``` r
do.call(mean, args)
```

    ## [1] 5.5

##### Default and missing arguments

``` r
f <- function(a =1, b = 2) {
  c(a, b)
}

f()
```

    ## [1] 1 2

``` r
g <- function(a = 1, b = a * 2) {
  c(a, b)
}

g()
```

    ## [1] 1 2

``` r
h <- function(a = 1, b = d) {
  d <- (a+1)^2
  c(a, b)
}

h()
```

    ## [1] 1 4

``` r
h(10)
```

    ## [1]  10 121

``` r
i <- function(a, b) {
  c(missing(a), missing(b))
}

i()
```

    ## [1] TRUE TRUE

``` r
i(a=1)
```

    ## [1] FALSE  TRUE

``` r
i(b=2)
```

    ## [1]  TRUE FALSE

``` r
i(1, 2)
```

    ## [1] FALSE FALSE

##### Lazy evaluation

``` r
f <- function(x) {
  10
}

f(stop("This is an error!"))
```

    ## [1] 10

If you want to ensure that an argument is evaluated you can use `force()`

``` r
f <- function(x) {
  force(x)
  10
} 

# f(stop("This is an error!"))

add <- function(x) {
  function(y) x+y
}

adders <- lapply(1:10, add)
adders[[1]](10)
```

    ## [1] 11

``` r
adders[[10]](10)
```

    ## [1] 20

``` r
add <- function(x) {
  x
  function(y) x + y
}

f <- function(x  = ls()) {
  a <- 1
  x
}



f()
```

    ## [1] "a" "x"

``` r
f(ls())
```

    ##  [1] "add"    "adders" "args"   "c"      "f"      "funs"   "g"     
    ##  [8] "h"      "i"      "objs"   "x"      "y"

``` r
x <- NULL
if(!is.null(x) && x > 0)  {
  
}

`&&` <- function(x, y) {
  if(!x) return(FALSE)
  if(!y) return(FALSE)
  
  TRUE
}

a <- NULL
!is.null(a) && a > 0
```

    ## [1] FALSE

``` r
# if (is.null(a)) stop("a is null")
# !is.null(a) || stop("a is null")
```

#### `...`

``` r
plot(1:5, col = "red")
```

![](chap_6_functions_files/figure-markdown_github/unnamed-chunk-19-1.png)

``` r
plot(1:5, cex = 5, pch = 20)
```

![](chap_6_functions_files/figure-markdown_github/unnamed-chunk-19-2.png)

``` r
plot(1:5, bty ="u")
```

![](chap_6_functions_files/figure-markdown_github/unnamed-chunk-19-3.png)

``` r
# plot(1:5, labels = F)

f <- function(...) {
  names(list(...))
}

f(a = 1, b = 2)
```

    ## [1] "a" "b"

``` r
sum(1, 2, NA, na.mr = T)
```

    ## [1] NA

##### Exercise

1.  Clarify the following list of odd function calls

``` r
x <- sample(replace = T, 20, x = c(1:10, NA))
y <- runif(min = 0, max = 1, 20)
cor(m = "k", y = y, u ="p", x = x)
```

    ## [1] -0.2087573

1.  

``` r
f1 <- function(x = {y <- 1; 2}, y = 0){
  x + y
}

f1()
```

    ## [1] 3

1.  

``` r
f2 <- function(x = z) {
  z <- 100
  x
}

f2()
```

    ## [1] 100

#### Special call

infix functions, replacement functions

##### infix funciton

``` r
`%+%` <- function(a, b) paste0(a, b)
"new" %+% " string"
```

    ## [1] "new string"

syntatic sugar

``` r
"new" %+% " string"
```

    ## [1] "new string"

``` r
`%+%`("new", " string")
```

    ## [1] "new string"

``` r
1 + 5
```

    ## [1] 6

``` r
`+`(1, 5)
```

    ## [1] 6

``` r
`% %` <- function(a, b) paste(a, b)
`%'%` <- function(a, b) paste(a, b)
`%/\\%` <- function(a, b) paste(a, b)

"a" % % "b"
```

    ## [1] "a b"

``` r
"a" %'% "b"
```

    ## [1] "a b"

``` r
"a" %/\% "b"
```

    ## [1] "a b"

``` r
`%-%` <- function(a, b) paste0("(", a, " %-% ", b, ")")

"a" %-% "b" %-% "c"
```

    ## [1] "((a %-% b) %-% c)"

``` r
`%||%` <- function(a, b) if (!is.null(a)) a else b
```

### replace function

``` r
`second<-` <- function(x, value) {
  x[2] <- value
  x
}


library(pryr)
```

    ## 
    ## Attaching package: 'pryr'

    ## The following object is masked _by_ '.GlobalEnv':
    ## 
    ##     f

``` r
x <- 1:10
address(x)
```

    ## [1] "0x7fffe4ac1890"

``` r
second(x) <- 6L
address(x)
```

    ## [1] "0x7fffe508d488"

``` r
x <- 1:10
address(x)
```

    ## [1] "0x7fffe45de468"

``` r
x[2] <- 7L
address(x)
```

    ## [1] "0x7fffe5107588"

``` r
`modify<-` <- function(x, position, value) {
  x[position] <- value
  x
}

modify(x, 1) <- 10

x
```

    ##  [1] 10  7  3  4  5  6  7  8  9 10

``` r
x <- `modify<-` (x, 1, 10)

x <- c(a = 1, b = 2, c = 3)
names(x)
```

    ## [1] "a" "b" "c"

``` r
names(x)[2] <- "two"

names(x)
```

    ## [1] "a"   "two" "c"

``` r
`*tmp*` <- names(x)

`*tmp*` [2] <- "two"
```

#### 연습문제

1.  **base**에서 찾을 수 있는 모든 대체 함수의 목록을 생성하라. 어느 것이 원시함수인가?

2.  사용자 생성 함수에 유효한 이름은 무엇인가?

3.  `xor()` 삽입 연산자를 만들어 보라.

4.  집합 함수인 `intersect()`, `union()` 그리고 `setdiff()`의 삽입 버전을 만들어 보라.

5.  어떤 벡터의 임의의 위치를 수정하는 대체 함수를 만들어보라.

### 반환값

``` r
f <- function(x) {
  if (x < 0) {
   0
  } else {
   10
  }
}

f(5)
```

    ## [1] 10

``` r
f(15)
```

    ## [1] 10

함수는 오로지 하나의 객체만을 반환할 수 있다. 그러나 이것이 한계가 아닌 이유는 여러 객체를 담고 있는 리스트도 반환할 수 있기 때문이다.

순수함수(pure function)는 순수 함수가 반환하는 값 이외에는 현재 상태에 어떠한 영향도 미치지 않는다.

R 객체는 수정후복사(copy-on-modify) 시맨틱스를 갖는다. 따라서 함수 인자를 수정하는 것은 원래의 값을 변화시키지 않는다.

``` r
f <- function(x) {
  x$a <- 2
  x
}

x <- list(a = 1)

f(x)
```

    ## $a
    ## [1] 2

``` r
x$a
```

    ## [1] 1

이는 함수의 입력을 수정할 수 있는 Java와 확연히 다르다.

함수는 보이지 않는 값을 반환할 수 있는데, 이런 값은 함수를 호출할 때 기본적으로 출력되지 않는다.

``` r
f1 <- function() 1
f2 <- function() invisible(1)

f1()
```

    ## [1] 1

``` r
f2()

f1() == 1
```

    ## [1] TRUE

``` r
f2() == 1
```

    ## [1] TRUE

``` r
(f2()) # 보이지 않는 값을 괄호로 감싸 표시되도록 할 수 있다.
```

    ## [1] 1

하나의 값을 여러 변수에 할당할 수 있다.

``` r
a <- b <- c <- d <- 2
```

왜냐하면 다음과 같이 파싱되기 때문이다.

``` r
(a <- (b <- (c <- (d <- 2))))
```

    ## [1] 2

#### 나가기

함수는 값을 반환할 수 있고 on.exit()를 사용하여 끝날때 시작되는 다른 트리거를 설정할 수도 있다. 이것은 함수가 종료될 때 전역 상태에 대한 변경 사항을 확실히 복원하는데 사용한다.

``` r
in_dir <- function(dir, code) {
  old <- setwd(dir)
  on.exit(setwd(old))
  
  force(code)
}

getwd()
```

    ## [1] "/home/jakinpilla/adv_r/advanced_r"

``` r
in_dir("~", getwd())
```

    ## [1] "/home/jakinpilla"

#### 연습문제

1.  `source()` 의 chdir 파라미터는 `in_dir()`과 어떻게 다른가? 한 접근법을 다른 것보다 선호하는 이유는 무엇인가?

2.  어떤 함수가 `library()`의 행동을 무효화하는가? `option()`과 `par()`의 값을 저장하고 복원하는 방법은 무엇인가?

3.  (플롯을 그리는 코드가 동작하는지 여부와는 관계없이 항상) 그래픽 디바이스를 시동하는 함수를 작성한 후 제공된 코드를 실행하고, 그 그래픽 디바이스를 종료해보라.

4.  `capture.output()`의 단순한 버전을 구현하기 위해 `on.exit()`를 사용할 수 있다.

``` r
capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = T)
  
  sink(temp)
  on.exit(sink(), add = T)
  
  force(code)
  readLines(temp)
}


capture.output2(cat("a", "b", "c", sep = "\n"))
```

    ## [1] "a" "b" "c"
