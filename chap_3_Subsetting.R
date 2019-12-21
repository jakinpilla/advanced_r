#' ---
#' title: "Advanced_R(chap_3_subsetting)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 6
#' ---

#+ message = FALSE, warning = FALSE
library(tidyverse)


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

#' 인덱스의 결측은 결과에도 항상 결측을 만듭니다.
#' 
#' 3. What does upper.tri() return? How does subsetting a matrix with it work? Do we need any additional subsetting rules to describe its behaviour?
#' 
x <- outer(1:5, 1:5, FUN = "*")
upper.tri(x)
x[upper.tri(x)]

#' TRUE 인 부분에 해당하는 원소들이 벡터로 출력됩니다. 여기에서.추가적인 서브세팅 규칙이 필요한지 여부는 좀 더 살펴봐야 알 것 같습니다.
#'
#' 4. Why does `mtcars[1:20]`return error? 
#' (Error in `[.data.frame`(mtcars, 1:20) : undefined columns selected)

#' mtcars 데이터는 데이터프레임 구조를 가지므로 1개의 벡터로 서브세팅하면 리스트처럼 동작하는데 열의 갯수가 `r mtcars %>% ncol()` 뿐이므로 범위를 초과하여 에러가 발생한 것입니다. mtcars[1:6]으로 범위 내에서 서브세팅하면 정상적으로 동작합니다.
#' 
#' 5. Implement your own function that extract the diagonal entries from a matrix.
#'
#' 대각원소를 추출하는 함수 `extract_diag`를 다음과 같이 작성하였습니다. 
extract_diag <- function(mat) {
  n <- nrow(mat)
  select <- matrix(ncol = 2, byrow = T, 
                   rep(1:n, each = 2))
  return(mat[select])
}

test_mat <- matrix(1:25, ncol=5)

extract_diag(test_mat)
 
#' 6. What dose `df[is.na(df)] <- 0` do?
#' 
#' 하나의 작은 예를 만들어서 실험해 봅니다.

d <- data.frame(
  a = c(1, 2, 3),
  b = c(NA, 4, 5),
  c = c(6, 7, NA)
)

d[is.na(d)] <- 0

d 

#' 결국, 원소 중에 있는 NA 값들을 0으로 치환시킵니다. 

#' #### Subsetting operators
#' 
#' 서브세팅 연사자에는 `[[`와 `$`가 있습니다.
#' 
b <- list(a = list(b = list(c = list(d = 1))))
b[["a"]][["b"]][["c"]][["d"]]
#'
#' ##### Simlifying vs. preserving subsetting
#' 
#' **Atomic** vector
x <- c(a=1, b=2)
x[1] 
x[[1]] # 이름이 제거된다.

#' **List**
y <- list(a=1, b=2)
str(y[1]) 
str(y[[1]])  

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
#' `$`를 잘못 사용하는 흔한 사례는 변수에 저장된 열의 이름에 있을때 그것을 사용하려는 것입니다.
var <- "cyl"
mtcars$var # 잘못 사용한 예
mtcars[[var]] # `[[`를 사용하면 됩니다.

x <- list(abc =1)
x$a # $ 연산자는 partial matching을 합니다.
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

#' 잔자의 자유도는 다음과 같이 추출할 수 있습니다.
mod$df.residual

#' R-square는 다음과 같이 추출할 수 있습니다.
summary_obs <- summary(mod)
str(summary_obs)
summary_obs$r.squared


#' #### Subsetting and assignment
#' 

x <- 1:5
x[c(1, 2)] <- 2:3
x

x[-1] <- 4:1
x

x[c(1, 1)] <- 2:3
x # x의 첫번쩨 원소가 2였다가 3으로 변했다고 해석할 수 있습니다.

x[c(T, F, NA)] <- 1 #' NA가 있는 정수 인덱스는 결합할 수 없습니다. 하지만 NA가 있는 논리형 인덱스는 결합할 수 있습니다.
x

df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a

#' 공백을 이용한 서브세팅은 원본 객체의 클래스와 구조를 유지합니다.
data('mtcars')
mtcars[] <- lapply(mtcars, as.integer)
mtcars %>% head # return a data.frame

mtcars <- lapply(mtcars, as.integer)
mtcars # return list
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
#' 다음은 match()와 정수 서브세팅(integer subsetting)을 하는 예시입니다.
grades <- c(1, 2, 2, 3, 1)

info <- data.frame(
  grade = 3:1, 
  desc = c("Excellent", "Good", "Poor"),
  fall = c(F, F, T)
)

id <- match(grades, info$grade); id
info[id, ]

#' Using rownames...
#' 
#' 다음은 rowname()와 문자 서브세팅(character subsetting)을 하는 예시입니다.
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
df[sample(nrow(df), 6, rep =T), ] # 복원추출합니다.

#' Ordering (integer subsetting)
#' 
x <- c("b", "c", "a"); x
order(x)
x[order(x)]
x[order(x, decreasing = T)]

y <- c("b", "c", "a", NA, "s", "f", NA, NA, "x", "l"); y
order(y)
y[order(y)] # 기본적으로 NA가 마지막으로 할당된다.

#' By default, any missing values will be put at the end of the vector; however, you can remove them with `na.last = NA` or put at the front with `na.list = FALSE`.

order(y, na.last = NA)
y[order(y, na.last = NA)] # na.last = NA 옵션으로 마지막으로 할당되는 NA를 제거합니다.

order(y, na.last = FALSE)
y[order(y, na.last = FALSE)] # na.last = FALSE 옵션으로 마지막으로 할당되는 NA를 앞으로 보냅니다.


df2 <- df[sample(nrow(df)) , 3:1]
df2

df2[order(df2$x), ]
df2[, order(names(df2))]

df <- data.frame(x = c(2, 4, 1), 
                 y = c(9, 11, 6), 
                 n = c(3, 5, 1))

rep(1:nrow(df), df$n)

df[rep(1:nrow(df), df$n), ]

#' ##### Removing columns from data frames (character subsetting)

#' 제거하고자 하는 열을 NULL로 삭제할 수 있습니다.
#'
df <- data.frame(x = 1:3, 
                 y = 3:1, 
                 z = letters[1:3])
df$z <- NULL
df[setdiff(names(df), "z")]

#' 단지 원하는 열만 반환되도록 서브세팅할 수 있습니다.

df[c('x', 'y')]

#' 만약 원하지 않는 열을 알고 있다면 집합연산(set operation)을 사용하여 유지할 열을 선택할 수 있습니다.
#' 
df[setdiff(names(df), 'z')]

#' ##### Selectig rows based on a condition (logical subsetting)

data("mtcars")
mtcars %>% head
mtcars[mtcars$gear == 5, ] %>% head
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ] # 드 모르간의 법칙을 기억합시다.

subset(mtcars, gear = 5) %>% head
subset(mtcars, gear == 5 & cyl == 4)

#' ##### Boolean algebra vs. sets (logical & integer subsetting)
#' 
set.seed(2019)
sample(10)
x <- sample(10) < 4
x

#' which() 는 불리언 표현을 정수 표현으로 변환합니다.
which(x) 

#' `which()` allows you to convert a boolean representation to an integer representation. There's no reverse operation in base in R but we can easily creat one.
#' 
unwhich <- function(x, n) {
  out <- rep_len(FALSE, n)
  out[x] <- T
  out
}

unwhich(which(x), 10)

#' 두 논리형 벡터와 이와 대응하는 정수형 벡터를 각각 생성하고 불리언 연산과 집합 연산의 관계를 알아봅니다.
#' 
x1 <- 1:10 %% 2 == 0; x1
x2 <- which(x1);x2

y1 <- 1:10 %% 5 == 0; y1
y2 <- which(y1) ; y2

# X & Y <-> intersect(x, y)
x1 & y1
intersect(x2, y2)

# X | Y <-> union(x, y)
x1 | y1
union(x2, y2)

# X & !Y <-> setdiff(x, y)
x1 & !y1
setdiff(x2, y2)

# xor(X, Y) <-> setdiff(union(x, y), intersect(x, y))
xor(x1, y1)
setdiff(union(x2, y2), intersect(x2, y2))

#' #### 연습문제
#' 
#' 1. 데이터 프레임이 열을 무작위적으로 치환하는 방법은 무엇인가? 한 번에 열과 행을 동시에 치환할 수 있는가?
#' 
#' 먼저 iris 데이터에서 무작위로 3개의 열으르 선택하는 코드를 생각해보겠습니다.
iris[, sample(ncol(iris), 3)] %>% head

#'그리고 행도 동시에 치환해보는 코드를 생각해보겠습니다.
iris[sample(nrow(iris)), sample(ncol(iris), 3)] %>% head

#' 이를 응용해 어떤 data.frame에 대해 열고 행을 동시에 무작위로 치환할 수 있는  함수를 제작해 보겠습니다.

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



#' 2. 데이터 프레임에서 어떻게 m행의 무작위 샘플을 선택할 수 있는가? 인접한 샘플을 선택해야 한다면 어떻게 해야 하는가?
#' (즉, 최초의 행과 마지막 행, 그리고 그 사이의 모든 행)
#'
#' m개의 무작위 샘플을 추출하는 함수를 제작합니다.

df_extract_shuffle <- function(df, m) {
  sample_idx <- sample(1:nrow(df), m)
  df_extracted <- df[sample_idx, ]
  
  return(df_extracted)
}

df_extract_shuffle(iris, 50) %>% head


#' 최초의 행과 마지막 행, 그리고 그 사이의 모든 행을 선택하는 함수를 제작합니다.
#' 
df_extract_bwn_m_n <- function(df, m, n) {
  idx <- m:n
  df_extracted <- df[idx, ]
  
  return(df_extracted)
}
df_extract_bwn_m_n(iris, 51, 100) %>% head



#' 3. 어떻게 데이터 프레임에 알파벳 순으로 열을 삽입할 수 있는가?
#' 
data("mtcars")

col_orderd_df <- function(df) {
  ordered_col_nm <- df %>% colnames() %>% sort()
  return(df[, ordered_col_nm])
}

col_orderd_df(mtcars) %>% head

#'만약 문제의 의도가 알파벳 컬럼을 삽입하는 것이라면 다음과 같이 해결합니다.

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
insert_alphabet_col(mtcars) %>% tail

