#' ---
#' title: "Advanced_R(chap_3_subsetting)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 6
#' ---
#' 
#' 
#' ### Subsetting
#' 
#' #### Data types
#' 
#' ##### Atomic vectors
#' 
x <- c(2.1, 4.2, 3.3, 5.4)
x[c(3, 1)]
x[order(x)]
x[c(1, 1)]
x[c(2.1, 2.9)]
x[-c(3, 1)]

x[c(T, T, F, F)]
x[x > 3]
x[c(T, F)]
x[c(T, T, NA, F)]
x[]

y <- setNames(x, letters[1:4])
y
y[c("d", "c", "a")]
y[c("a", "a", "a")]

z <- c(abc = 1, def = 2)
z[c("a", "d")]

#' ##### Lists
#' 
#' ##### Matrices and arrays

a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a[1:2, ]

a[c(T, F, T), c("B", "A")]
a[0, -2]


val <- outer(1:5, 1:5, FUN = "paste",
             sep = ",")
val

val[c(4, 15)]

vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")

select <- matrix(ncol =2, byrow = T, 
                 c(1, 1,
                   3, 1, 
                   2, 4))

vals[select]


#' ##### Data frames
#' 
df <- data.frame(x = 1:3, y = 3:1, 
                 z = letters[1:3])
df[df$x == 2, ]

df[c("x", "z")]

df[, c("x", "z")]


#' There is an important difference if you select a single column : matrix subsetting simplifies by default, list subsetting does not.
#' 
str(df["x"]) # data.frame
str(df[, "x"]) # vector

#' ##### S3 objects
#' 
#' ##### S4 objetcs
#' 
#' There are also two additional subsetting operators that are needed for S4 objects : `@` (equivalent `$`) and `slot()` (equivalent to `[[`). `@` is more resrictive than `$` in that it will return an error if the slot dose not exist.
#'
#' ##### Exercise
#' 1. Fix data frame sbsetting errors
#' 
mtcars[mtcars$cyl == 4, ]
mtcars[1:4, ]
mtcars[mtcars$cyl <= 5, ]
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]

#' 2. What dose `x <- 1:5; x[NA]` yield five missing values?
x <- 1:5; 
x[NA]
x[NA_real_]
#'
#' 3. What does upper.tri() return? How does subsetting a matrix with it work? Do we need any additional subsetting rules to describe its behaviour?
#' 
x <- outer(1:5, 1:5, FUN = "*")
upper.tri(x)
x[upper.tri(x)]

#' 4. Why does `mtcars[1:20]`return error? 
#' (Error in `[.data.frame`(mtcars, 1:20) : undefined columns selected)
mtcars[1:20, ]

#' 5. Implement your own function that extract the diagonal entries from a matrix.
#' 
#' 
#' 6. What dose `df[is.na(df)] <- 0` do?
#' 
#' #### Subsetting operators
#' 
b <- list(a = list(b = list(c = list(d = 1))))
b[["a"]][["b"]][["c"]][["d"]]
#'
#' ##### Simlifying vs. preserving subsetting
#' 
#' **Atomic** vector
x <- c(a=1, b=2)
x[1] # preserving
x[[1]] # simpifying 

#' **List**
y <- list(a=1, b=2)
str(y[1]) # preserving
str(y[[1]]) # simpifying 

#' **Factor** : drop any unused levels
#' 
z <- factor(c("a", "b"))
z[1] # preserving
z[1, drop = T] # simpifying 

#' **Matrix or array** : if any of the dimension has length 1, drops that dimension

a <- matrix(1:4, nrow =2)
a[1, , drop = FALSE] # preserving
a[1, ] # simpifying 

#' **Data frame** : if output is a single column, returns a vector instead of a data frame
df <- data.frame(a =1:2, b = 1:2)
df
str(df[1])
str(df[[1]]) # simpifying 
str(df[, "a", drop = F])
str(df[, "a"]) # simpifying 

#' ##### `$`
#' 
#' x$y is equivalent to x[["y", exact = F]]
#' 
var <- "cyl"
mtcars$var
mtcars[[var]]

x <- list(abc =1)
x$a
x[["a"]]

#' #### Missing / out of bounds indices
#' 
x <- 1:4 
str(x[5])

str(x[NA_real_])
str(x[NULL])

#' ##### Exercise
#' `mod <- lm(mpg ~ wt, data = mtcars)`, Extract the residual degrees of freeom, Extract the R squared from the model summary
#' 
mod <- lm(mpg ~ wt, data = mtcars)
summary(mod)
#' 
#' #### Subsetting and assignment
#' 

x <- 1:5
x[c(1, 2)] <- 2:3
x
x[-1] <- 4:1
x
x[c(1, 1)] <- 2:3
x
x[c(T, F, NA)] <- 1
x

mtcars[] <- lapply(mtcars, as.integer)
#' return a data.frame

mtcars <- lapply(mtcars, as.integer)
#' return list
#' 
#' With list, you can use `subsetting + assignment + NULL` to remove components from a list
#' 
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)

y <- list(a = 1)
y["b"] <- list(NULL)
str(y)

#' #### Applications
#' 
#' ##### Lookup tables (character subsetting)
#' 
#' Character matching provides a powerful way to make lookup tables.

x <- c("m" ,"f", "u", "f", "f", "m", "m")
lookup <- c(m= "Male", f = "Female", u = NA)

lookup[x]
unname(lookup[x])

c(m = "Known", f = "Known", u = "Unknown")[x]

#' ##### Matching and mersing by hand (integer subsetting)
#' 
grades <- c(1, 2, 2, 3, 1)

info <- data.frame(
  grade = 3:1, 
  desc = c("Excellent", "Good", "Poor"),
  fall = c(F, F, T)
)

id <- match(grades, info$grade)
info[id, ]

#' Using rownames...
#' 
rownames(info) <- info$grade
info[as.character(grades), ]

#' ##### Random samples/bootstrap (integer subseting)

df <- data.frame(x = rep(1:3, each  =2), 
                 y = 6:1, 
                 z = letters[1:6])

set.seed(2019)

sample(nrow(df))
df[sample(nrow(df)), ]
df[sample(nrow(df), 3), ]

#' Select 6 bootstrap replicates
df[sample(nrow(df), 6, rep =T), ]

#' Ordering (integer subsetting)
#' 
x <- c("b", "c", "a"); x
order(x)
x[order(x)]

#' By default, any missing values will be put at the end of the vector; however, you can remove them with `na.last = NA` or put at the front with `na.list = FALSE`.

df2 <- df[sample(nrow(df)) , 3:1]
df2

df2[order(df2$x), ]
df2[, order(names(df2))]

df <- data.frame(x = c(2, 4, 1), 
                 y = c(9, 11, 6), 
                 n = c(3, 5, 1))

df[rep(1:nrow(df), df$n), ]

#' ##### Removing columns from data frames (character subsetting)

df <- data.frame(x = 1:3, 
                 y = 3:1, 
                 z = letters[1:3])
df$z <- NULL
df[setdiff(names(df), "z")]

#' ##### Selectig rows based on a condition (logical subsetting)
data("mtcars")
mtcars
mtcars[mtcars$gear == 5, ]

mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]

subset(mtcars, gear = 5)
subset(mtcars, gear == 5 & cyl == 4)

#' ##### Boolean algebra vs. sets (logical & integer subsetting)
#' 
set.seed(2019)
sample(10)
x <- sample(10) <4
x
which(x)

#' `which()` allows you to convert a boolean representation to an integer representation. There's no reverse operation in base in R but we can easily creat one.
#' 
unwhich <- function(x, n) {
  out <- rep_len(FALSE, n)
  out[x] <- T
  out
}

unwhich(which(x), 10)

getwd()











