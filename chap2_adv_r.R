#' ---
#' title: "Advanced_R(chap_2)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#' ---
#' 
#' 

#+ message = FALSE, warning = FALSE
library(tidyverse)

#' ## 벡터
#' 
#' ### 원자벡터
#' 
#' 원자벡터과 리스트는 공통적으로 유형(typeof), 길이(length), 속성(attributes) 등을 가지고 있습니다.
#' 
#' `is.vector()` : 객체가 이름과 다른 속성을 가지지 않는 경우에만 TRUE를 반환합니다. 어떤 객체가 실질적으로
#' 벡터인지 알려면 `is.atomic()` || `is.list()` 를 사용합니다.
#' 
a <- c(1, 2, 3)
is.vector(a)
names(a) <- c('x', 'y', 'z')
is.vector(a)

is.atomic(a)
is.list(a)
 
dbl_var <- c(1, 2.5, 4.5)
int_var <- c(1L, 6L, 10L)
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("these are", "some strings")

#' 원자벡터는 `c()`로 감싸더라도 항상 벡터입니다. `NA`를 `c()` 안에서 사용하면 강제로 그 형태에 맞게 형변환이 됩니다.
#' 이는 NA_real_, NA_integer_, NA_character_ 등의 특수한 형태가 있기 때문에 가능합니다.
#' 
c(1, c(2, c(3, 4)))

#' #### 유형과 검증
#' 
int_var <- c(1L, 6L, 10L)
typeof(int_var)
is.integer(int_var)
is.atomic(int_var)

dbl_var <- c(1, 2.5, 4.5)
typeof(dbl_var)
is.atomic(dbl_var)

is.numeric(int_var)
is.numeric(dbl_var)

#' #### 강제형변환
#' 
#' 다른 유형을 결합하려고 하면 강제형변환 `coercion`이 일어납니다. 이는 가장 유연한 방향으로 일어납니다.
#' 논리형이 가장 유연하지 않으며, 정수형, 더불형, 그리고 문자형 순으로 유연합니다.
str(c("a", 1))

#' 벡터가 정수형이나 더블형으로 강제변환될 때 TRUE는 1이 되고, FALSE는 0이 됩니다.
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)
sum(x) # TRUE의 총수
mean(x) # TRUE인 비율

#' 강제변환에 대한 혼란에 대비하여 `as.character`, `as.double()`, `as.integer()`, 
#' `as.logical()` 을 이용한 명시적 형변환을 하는 것을 권장합니다.
#' 
#' 
#' ### 리스트
#' 
x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
str(x)


#' `list`를 `recursive vector`라고도 부르는데 그 이유는 리스트가 다른 리스트를 표현할 수 있기 때문입니다.
#' 
x <- list(list(list(list())))
str(x)
is.recursive(x)

#' `c()`는 여러 리스트를 하나의 데이터 객체로 만듭니다. 만약 어떤 원자 벡터와 리스트가
#' 결합된 형태로 주어진다면 `c()`는 그 둘을 결합하기 전에 그것들을 리스트로 강제형변환할 것입니다.

x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4)) # 이질적인 리스트와 벡터를 결합하기 전에 c()는 이것들을 강제변환함.

str(x)
str(y)

unlist(x)
unlist(y)

#' 데이터 프레임과 `lm()`으로 만들어진 선형 모형 객체는 모두 리스트입니다.
#' 
head(mtcars)
is.list(mtcars)
str(mtcars)

mod <- lm(mpg ~ wt, data = mtcars)
is.list(mod)


#' ### 연습문제
#' 
#' 1. 원자벡터의 여섯가지 유형은 무엇인가? 리스트는 원자 벡터와 어떻게 다른가?
#' 
#' 논리형, 정수형, 더블형, 문자형, 복소수형, 원시형 등 여섯 가지의 원자 벡터 유형이 있습니다. 리스트는 이질적인 원자
#' 벡터들을 원소들오 가질 수 있지만  원자 벡터는 하나의 동질적인 원자 벡터들만을 가질 수 있습니다.
#' 
#' 2. is.vector(), is.numeric(), is.list() 그리고 is.character()의 근본적인 차이는 무엇인가?
#' 
#' is.vector() :
#' is.numeric() : 데이터가 integer 혹은 double 일때 TRUE를 반환합니다.
#' is.list() : 데이터 유형이 list 일때 TRUE를 반환합니다.
#' is.character() : 원자 벡터가 문자형일때 TRUE를 반환합니다. 

#' 3. 다음 각 경우에 따라 c()의 출력결과를 예상해보자.
#' 
c(1, FALSE)

#' 숫자형이 논리형보다 더 유연한 자료구조형이므로 FALSE가 강제형변화되어 0이 됩니다.

c("a", 1)

#' 문자형이 숫자형보다 더 유연한 자료구조형이므로 1이 강제형변화되어 "1"이 됩니다.

c(list(1), "a")

#' 

c(TRUE, 1L)

1 == "1" # True
-1 < FALSE # True
"one" < 2 # False

c(FALSE, NA_character_) # return character vector
class(NA)
class(NA_character_)
class(NA_integer_)
class(NA_complex_)
class(NA_real_) 

#' ### 속성
#' 
#' 속성은 이름있는 리스트처럼 생각할 수 있습니다.
#' 
#' 속성은 `attr()` 함수로 개별적으로 접근할 수 있지만, `attributes()` 함수로 (리스트처럼) 한 번에 
#' 모든 속성에 접근할 수도 있습니다.
#' 
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")

str(y)

str(attributes(y))

y <- structure(1:10, my_attribute = "This is a vector")
attr(y, "my_attribute")

#' 기본적으로 대부분의 속성은 벡터를 수정할 때 상실됩니다.
y
attributes(y[1])
attributes(sum(y[1]))

#' 상실되지 않은 유일한 속성은 다음의 세 가지다.
#' 
#' > - 이름(names), 각 요소에 이름을 부여하는 문자형 벡터이다.
#' 
#' > - 차원(dimensions), 벡터를 메트릭스와 어레이로 변환하는데 사용한다.
#' 
#' > - 클래스(class), S3 객체 시스템을 구현하는데 사용한다.
#' 
#' 각 속성은 값을 가져오거나 설정하기 위한 특별 접근자 함수를 가지고 있습니다.

x <- c(a=1, b=2, c=3)

attr(x, 'names')
names(x)

attr(x, 'dim')
dim(x)

attr(x, 'class')
class(x)


#' #### 이름
#' 
#' 이름은 다음의 3가지 방식으로 설정할 수 있습니다.

x <- c(a=1, b=2, c=3)
names(x) <- c("a", "b", "c")
x <- setNames(1:3, c("a", "b", "c"))

#' 이름은 중복이 허용됩니다.
names(x) <- c('a', 'a', 'b')
x
x['a']
x['b']


#' 이름 중 몇 개가 생략되었다면 names() 함수는 이들 요소에 대해 빈 문자열을 반환합니다.
y <- c(a=1, 2, 3)
names(y)


v <- c(1, 2, 3)
names(v) <- c("a")
names(v)

z <- c(1, 2, 3)
names(z)

#' `unnames(x)`를 이용하여 이름이 없는 새로운 벡터를 생성하거나 `names(x) <- NULL`로 
#' 작업공간에 있는 이름을 제거할 수 있습니다.
#' 
#' ### 팩터
#' 
x <- factor(c("a", "b", "b", "a"))
class(x)
levels(x)

#' 수준에 없는 값을 사용할 수 없다.
x[2] <- "c" 
#' Warning message:
#'   In `[<-.factor`(`*tmp*`, 2, value = "c") :
#'   invalid factor level, NA generated

x

#' 팩터는 결합할 수 없다.
c(factor("a"), factor("b"))

#' 문자형 벡터 대신 팩터를 이용하면 어떤 데이터 세트의 관측값이 없을 때 그 관측값이 없음을 
#' 명백히 할 수 있다.
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)

z <- read.csv(text = "value\n12\n1\n.\n9")
typeof(z$value)
as.double(z$value) # 3 2 1 4는 읽어들인 값이 아니라 팩터형의 수준이다.
class(z$value)

as.double(as.character(z$value)) # 이렇게 잘못된 것을 고칠 수 있다.
z <- read.csv(text = "value\n12\n1\n.\n9", na.strings = ".")
typeof(z$value)
class(z$value)
z$value # 이상없이 처리되었다.

#' `factor` 에 `gsub()` 과 `grepl()` 같은 문자열 메소드는 팩터를 문자열로 변환한다.
#' 초기 버전의 R에서는 문자형 벡터 대신 팩터를 사용하는 것이 메모리 사용에 이점이 있었지만
#' 이제는 그렇지 않다.
#' 
#' ### 연습문제
#' 1.
structure(1:5, comment = "my attribute")

#' 2. 
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))

f2 <- rev(factor(letters))
f2

f3 <- factor(letters, levels = rev(letters))
f3


#' ### Matrix와 Array
#' 
a <- matrix(1:6, ncol = 3, nrow = 2)
b <- array(1:12, c(2, 3, 2))

c <- 1:6
dim(c) <- c(3, 2); c
dim(c) <- c(2, 3); c

#' `length()`와 `names()`는 `high-dimensional generalisations`를 가진다.
#' 
#' > - `length()`는 매트릭스에 대해서는 `nrow()`와 `ncol()`, 어레이에 대해서는 `dim()`으로 
#' 일반화된다.
#' 
#' > - `names()`는 매트릭스에 대해서는 `rownames()`와 `colnames()`, 어레이에 대해서는 문자형
#' 벡터로 된 리스트인 `dimnames()`로 일반화된다.
#' 
length(a)
nrow(a)
ncol(a)

rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")

a

length(b)
dim(b)
dimnames(b) <- list(c("one", "two"), c("a", "b", "c"), c("A", "B"))
b














