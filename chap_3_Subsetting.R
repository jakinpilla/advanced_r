#' ---
#' title: "Advanced_R(chap_3_subsetting)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 4
#' ---
#' 
#' ### Data types
#' 
#' 

x <- c(2.1, 4.2, 3.3, 5.4)
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
select

df <- data.frame(x = 1:3, y = 3:1, 
                 z = letters[1:3])
df[df$x == 2, ]

df[c("x", "z")]

df[, c("x", "z")]


# There is an importatn difference if you select a single column : matrix subsetting simplifies by default, list subsetting does not.
str(df["x"]) # data.frame
str(df[, "x"]) # vector

mtcars[mtcars$cyl == 4, ]
mtcars[1:4, ]
mtcars[mtcars$cyl <= 5, ]
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]


x < -outer(1:5, 1:5, FUN = "*")
x[upper.tri(x)]

mtcars[1:20, ]

df
df[is.na(df)] <- 0

b <- list(a = list(b = list(c = list(d = 1))))
b[["a"]][["b"]][["c"]][["d"]]

y <- list(a=1, b=2)
str(y[1])

z <- factor(c("a", "b"))
z[1]
z[1, drop = T]

# MAtrix or array : if any of the dimension has length 1, drops that dimension

a <- matrix(1:4, nrow =2)
a[1, , drop = FALSE]
a[1, ]

df <- data.frame(a =1:2, b = 1:2)
df
str(df[1])
str(df[[1]])
str(df[, "a", drop = F])
str(df[, "a"])

x$y is equivalent to x[["y", exact = F]]


var <- "cyl"
mtcars$var
mtcars[[var]]

x <- list(abc =1)
x$a
x[["a"]]

x <- 1:4 
str(x[5])

str(x[NA_real_])
str(x[NULL])

mod <- lm(mpg ~ wt, data = mtcars)
summary(mod)

x <- 1:5
x[c(1, 2)] <- 2:3
x
x[-1] <- 4:1
x
x[c(1, 1)] <- 2:3
x
x[c(1, NA)] <- c(1, 2)
x
x[c(T, F, NA)] <- 1
x







