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
sapply(1:5, "+", 3) # sapply() can be given the name of a  function instead of the function itself.

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

# Can abbreviate long argument names:
str(f(2, 3, a =1))

# But this doesn't work because abbreviation is ambiguous
# str(f(1, 3, b = 1))

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
y <- 



