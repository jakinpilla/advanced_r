#' ---
#' title: "Advanced_R(chap_5_style_guide)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 6
#' ---
#' 
#' 
#' ### Functions
#' 
#' #### Function components
#' 
f <- function(x) x^2
f

formals(f)
body(f)
environment(f)

#' 
#' ##### Primitive functions
#' 
sum
formals(sum)
body(sum)
environment(sum)

#' 1. What function allows you to tell if an object is a function? What function allows you to tell if a 
#' funcion is a primitive function?
#' 
#' 2. This code makes a list of all functions in the base package/
objs <- mget(ls("package:base"), inherits = T)
funs <- Filter(is.function, objs)
#'
#' - Which base function has the most arguments?
#' 
#' - How many base functions have no arguments? What's special about those functions?
#' 
#' - How couid you adapt the code to find all primitive functions?
#' 
#' #### Lexical scoping
x <- 10
x

#' ##### Name masking
#' 
f <- function() {
  x <- 1
  y <- 2
  c(x, y)
}

f()
rm(f)

x <- 2
g <- function() {
  y <- 1
  c(x, y)
}

g()
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

rm(x, h)

j <- function(x) {
  y <- 2
  function() {
    c(x, y)
  }
}

k <- j(1)

k()

rm(j, k)

#' ##### Functions vs variables
#' 
l <- function(x) x + 1
m <- function() {
 l <- function(x) x * 2
 l(10)
}

m()

rm(l, m)

n <- function(x) x/2
o <- function() {
  n <- 10
  n(n)
}

o()

rm(n, o)


#' ##### A fresh start
#' 
j <- function() {
  if(!exists("a")) {
    a <- 1
  } else {
    a <- a +1
  }
  a
}

j()

rm(j)

#' ##### Dynamic lookup
#' 
f <- function() x
x <- 15
f()

x <- 20
f()

f <- function() x + 1
codetools::findGlobals(f)

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

rm("(")

#' ##### Exercise
#' 
#' 1. What does the following code return? Why? What does each of the three c's mean?
#' 
c <- 10
c(c = c)

#' 2. What are the four principles that govern how R looks for values?
#' 
#' 3. What does the following function return? Make a prediction before running the code yourself?
#' 
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

#' #### Every operation is a function call
#' 
#' To understand computations in R, two slogans are helpful:
#'
#' - Everything that exist is an object
#' 
#' - Everything that happens is a function call
#' 
#' 
x <- 10; y <- 5
x + y

`+`(x, y)

`for`(i, 1:2, print(i))

if (i == 1) print("yes!") else print("no.")
`if`(i == 1, print("yes!"), print("no."))

x[3]
`[`(x, 3)

{print(1); print(2); print(3)}

`{`(print(1), print(2), print(3))

add <- function(x, y) x + y
sapply(1:10, add, 3)

sapply(1:5, `+`, 3)
sapply(1:5, "+", 3) # sapply() can be given the name of a function instead of the function itself.

x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
sapply(x, function(x) x[2])

#' #### Function arguments
#' 
#' ##### Calling functions
#' 
f <- function(abcdef, bcde1, bcde2) {
  list(a = abcdef, b1 = bcde1, b2 = bcde2)
}

str(f(1, 2, 3))

str(f(2, 3, abcdef = 1))

#' Can abbreviate long argument names:
str(f(2, 3, a =1))

#' But this doesn't work because abbreviation is ambiguous
#' `str(f(1, 3, b = 1))``

mean(1:10)
mean(1:10, trim = 0.05)

mean(x = 1:10) # this is probably overkill

mean(1:10, n = T)
mean(1:10, , FALSE)
mean(1:10, 0.05)
mean(, TRUE, x = c(1:10, NA))

args <- list(1:10, na.rm = T)

#' How could you then send that list to mean()? You need `do.call()``
#' 
do.call(mean, args)

#' ##### Default and missing arguments
#' 
f <- function(a =1, b = 2) {
  c(a, b)
}

f()

g <- function(a = 1, b = a * 2) {
  c(a, b)
}

g()

h <- function(a = 1, b = d) {
  d <- (a+1)^2
  c(a, b)
}

h()
h(10)

i <- function(a, b) {
  c(missing(a), missing(b))
}

i()

i(a=1)
i(b=2)
i(1, 2)

#' ##### Lazy evaluation

f <- function(x) {
  10
}

f(stop("This is an error!"))

#' If you want to ensure that an argument is evaluated you can use `force()`
#' 
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
adders[[10]](10)

add <- function(x) {
  x
  function(y) x + y
}

f <- function(x  = ls()) {
  a <- 1
  x
}



f()

f(ls())

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

# if (is.null(a)) stop("a is null")
# !is.null(a) || stop("a is null")

#' #### `...`
#' 
#' 
plot(1:5, col = "red")
plot(1:5, cex = 5, pch = 20)
plot(1:5, bty ="u")
# plot(1:5, labels = F)

f <- function(...) {
  names(list(...))
}

f(a = 1, b = 2)
sum(1, 2, NA, na.mr = T)

#' ##### Exercise

#' 1. Clarify the following list of odd function calls
#' 
x <- sample(replace = T, 20, x = c(1:10, NA))
y <- runif(min = 0, max = 1, 20)
cor(m = "k", y = y, u ="p", x = x)

#' 2. 
f1 <- function(x = {y <- 1; 2}, y = 0){
  x + y
}

f1()


#' 3. 
f2 <- function(x = z) {
  z <- 100
  x
}

f2()

#' #### Special call
#' 
#' infix functions, replacement functions
#' 
#' ##### infix funciton

`%+%` <- function(a, b) paste0(a, b)
"new" %+% " string"

#' syntatic sugar
#' 
"new" %+% " string"
`%+%`("new", " string")

1 + 5
`+`(1, 5)


`% %` <- function(a, b) paste(a, b)
`%'%` <- function(a, b) paste(a, b)
`%/\\%` <- function(a, b) paste(a, b)

"a" % % "b"

"a" %'% "b"

"a" %/\% "b"

`%-%` <- function(a, b) paste0("(", a, " %-% ", b, ")")

"a" %-% "b" %-% "c"

`%||%` <- function(a, b) if (!is.null(a)) a else b

#' ### replace function
#' 
`second<-` <- function(x, value) {
  x[2] <- value
  x
}


library(pryr)
x <- 1:10
address(x)

second(x) <- 6L
address(x)

x <- 1:10
address(x)

x[2] <- 7L
address(x)


`modify<-` <- function(x, position, value) {
  x[position] <- value
  x
}

modify(x, 1) <- 10

x

x <- `modify<-` (x, 1, 10)

x <- c(a = 1, b = 2, c = 3)
names(x)

names(x)[2] <- "two"

names(x)

`*tmp*` <- names(x)

`*tmp*` [2] <- "two"


#' #### 연습문제
#' 
#' 1. **base**에서 찾을 수 있는 모든 대체 함수의 목록을 생성하라. 어느 것이 원시함수인가?
#' 
#' 2. 사용자 생성 함수에 유효한 이름은 무엇인가?
#' 
#' 3. `xor()` 삽입 연산자를 만들어 보라.
#' 
#' 4. 집합 함수인 `intersect()`, `union()` 그리고 `setdiff()`의 삽입 버전을 만들어 보라.
#' 
#' 5. 어떤 벡터의 임의의 위치를 수정하는 대체 함수를 만들어보라.
#' 
#' 
#' ### 반환값
#' 
f <- function(x) {
  if (x < 0) {
   0
  } else {
   10
  }
}

f(5)

f(15)


#' 함수는 오로지 하나의 객체만을 반환할 수 있다. 그러나 이것이 한계가 아닌 이유는 여러 객체를 담고 
#' 있는 리스트도 반환할 수 있기 때문이다.
#' 
#' 순수함수(pure function)는 순수 함수가 반환하는 값 이외에는 현재 상태에 어떠한 영향도 미치지 않는다.
#' 
#' R 객체는 수정후복사(copy-on-modify) 시맨틱스를 갖는다. 따라서 함수 인자를 수정하는 것은 원래의 값을 변화시키지 않는다.
#' 
f <- function(x) {
  x$a <- 2
  x
}

x <- list(a = 1)

f(x)

x$a

#' 이는 함수의 입력을 수정할 수 있는 Java와 확연히 다르다.
#' 

#' 함수는 보이지 않는 값을 반환할 수 있는데, 이런 값은 함수를 호출할 때 기본적으로 출력되지 않는다.
#' 
f1 <- function() 1
f2 <- function() invisible(1)

f1()

f2()

f1() == 1
f2() == 1
(f2()) # 보이지 않는 값을 괄호로 감싸 표시되도록 할 수 있다.

#' 하나의 값을 여러 변수에 할당할 수 있다.
#' 
a <- b <- c <- d <- 2

#' 왜냐하면 다음과 같이 파싱되기 때문이다.
#' 
(a <- (b <- (c <- (d <- 2))))

#' #### 나가기
#' 
#' 함수는 값을 반환할 수 있고 on.exit()를 사용하여 끝날때 시작되는 다른 트리거를 설정할 수도 있다.
#' 이것은 함수가 종료될 때 전역 상태에 대한 변경 사항을 확실히 복원하는데 사용한다.
#' 
in_dir <- function(dir, code) {
  old <- setwd(dir)
  on.exit(setwd(old))
  
  force(code)
}

getwd()

in_dir("~", getwd())

#'#### 연습문제
#'
#' 1. `source()` 의 chdir 파라미터는 `in_dir()`과 어떻게 다른가? 한 접근법을 다른 것보다 선호하는 이유는 무엇인가?
#' 
#' 2. 어떤 함수가 `library()`의 행동을 무효화하는가? `option()`과 `par()`의 값을 저장하고 복원하는 방법은 무엇인가?
#' 
#' 3. (플롯을 그리는 코드가 동작하는지 여부와는 관계없이 항상) 그래픽 디바이스를 시동하는 함수를 작성한 후 제공된
#' 코드를 실행하고, 그 그래픽 디바이스를 종료해보라.
#' 
#' 4. `capture.output()`의 단순한 버전을 구현하기 위해 `on.exit()`를 사용할 수 있다.

capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = T)
  
  sink(temp)
  on.exit(sink(), add = T)
  
  force(code)
  readLines(temp)
}


capture.output2(cat("a", "b", "c", sep = "\n"))























































