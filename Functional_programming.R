#' ---
#' title: "Advanced_R(chap_2)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 4
#' ---
#' 
#' 
set.seed(1014)

df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep =T)))
names(df) <- letters[1:6]

df

df$a[df$a == -99] <- NA
df$b[df$b == -99] <- NA
df$c[df$c == -98] <- NA
df$d[df$d == -99] <- NA
df$e[df$e == -99] <- NA
df$f[df$g == -99] <- NA

#' do not repeat yourself : DRY 
#' 
#' 
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
fix_missing_999(c(-99, -999))


fix_missing <- function(x, na.value) {
  x[x == na.value] <- NA
  x
}

summary <- function(x) {
  funs <- c(mean, median, sd, mad, IQR)
  lapply(funs, function(f) f(x, na.rm = T))
}

lapply(df, summary)


#'## Anonymous  functions
#'
lapply(mtcars, function(x) length(unique(x)))
Filter(function(x) !is.numeric(x), mtcars)
integrate(function(x) sin(x)^2, 0, pi)


formals(function(x = 4) g(x) + h(x))
body(function(x = 4) g(x) + h(x))
environment(function(x = 4) g(x) + h(x))







