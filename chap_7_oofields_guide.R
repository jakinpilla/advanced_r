#' ---
#' title: "Advanced_R(chap_7_OO_fields_guide)"
#' author: "jakinpilla"
#' date : "`r format(Sys.time(), '%Y-%m-%d')`"
#' output: 
#'    github_document : 
#'        toc : true
#'        toc_depth : 6
#' ---
#' 
#' # 객체지향 필드 가이드
#' 
#' 어떤 객체지향 시스템이든 그 중심에는 클래스와 메소드의 개념이 있다.
#' 
#' 클래스는 객체의 속성과 다른 클래스들의 관계를 기술함으로써 `object`의 행동을 정의한다.
#' 
#' 클래스는 그 입력 클래스에 따라 다르게 행동하는 함수인 `methods`를 선택할 때도 사용한다.
#' 
#' 클래스는 보통 계층적으로 구성된다. 만약 어떤 메소드가 자식에 존재하지 않는다면 부모 메소드가 대신 사용된다. 즉, 
#' 자식은 부모의 생동을 상속한다.
#' 
#' - S3 : generic function OO , not message passing. 메시지 패싱은 메시지가 객체에 전달되고, 메시지를 전달받은
#' 그 객체가 어느 함수를 호출할 지 판단한다. 하지만 S3는 다르다. 계산이 수행되는 동안 `generic function`라고 
#' 불리는 특수한 유형의 함수가 어느 메소드를 호출할 지를 결정한다.
#' 
#' - S4 : 형식적이다. S4는 형식적 클래스 정의를 갖고 있는데, 그것은 각 클래스에 대한 표현과 상속을 기술하고, 
#' 제너릭과 메소드를 정의하는 데 도움을 주는 특별한 함수를 갖고 있다. S4는 다중 디스패치도 갖고 있는데, 이것은 
#' 제너릭 함수가 여러 개의 인자를 가지는 클래스에 기반을 두고 메소드를 선책할 수 있다는 것을 의미한다.
#' 
#' - RC : 참조클래스. RC는 메시지 패싱을 구현한 것이다. 함수가 아니라 클래스에 메소드가 따른다. 메소드 호출은 
#' canvas$drawRec("blue")와 같은 모양이다. RC는 가변적이기 때문에 R의 일반적인 수정-후-복사 시맨틱스를 사용하지 않는다. 
#' 그 자리에서 바로 수정한다. 
#' 
#' - 베이스 타입 : OO 시스템의 기본이 되는 C 수준 내부 타입이다. 
#' 

library(pryr)

#' ##### 퀴즈 
#' 
#' 1. 객체가 관련되어 있는 OO 시스템이 무엇인지 어떻게 알 수 있는가?
#' 
#' 1. 객체의 베이스 타임을 어떻게 판단하는가?
#' 
#' 1. 제너릭 함수는 무엇인가?
#' 
#' 1. S3와 S4의 주요 차이는 무엇인가? 그리고 S4와 RC의 주된 차이는 무엇인가>
#' 
#' 
#' ## 베이스 타입
#' 
#' 구조체는 메모리 관리에 필요한 정보인 객체의 내용과 여기에서 가장 중요하게 다루는 **type**을 포함하고 있다.
#' 
#' 이 **type**은 R 코어팀만이 수정할 수 있다.
#' 
#' 객체의 베이스타입은 `typeof()`으로 판단할 수 있다.
#' 
#' 함수의 타입은 "closure"이다.
f <- function() {}
typeof(f) 
#' 

is.function(f)
#' 
#' 원시 함수의 타입은 `buildin`이다.
#' 
typeof(sum)
#' 

is.primitive(sum)
#' 

#' 서로 다른 베이스 타입에 따라 상이하게 동작하는 함수는 거의 C로 쓰여져 있고, `switch`구문을 사용하여 
#' 디스패치가 발생한다.  
#' 
#' 모든 것이 베이스타입 위에 구축되어 있기 때문에 베이스 타입을 이해하는 것은 중요하다.
#' 
#' S3 객체는 어떤 베이스 타입 위에서도 구축될 수 있고, S4 객체는 특수한 베이스 타입을 사용하며, RC 객체는 
#' S4와 (다른 베이스 타입인) 환경의 결합이다.
#' 
#' 그 객체가 S3, S4 또는 RC 행동을 갖고 있지 않은지 여부를 확인하고 싶다면 `is.object(x)`가 FALSE를 반환하는지
#' 확인하라.
#' 
#' ### 객체인식, 제너릭 함수, 그리고 메소드
#' 
#' S3 객체인지 쉽게 확인하는 방법은 `is.object(x) & !isS4(x)`, 즉 개체이면서 S4가 아닌지를 평가하는 것이다.
#' 보다 쉬운 방법은 `pryr::otype()`을 사용하는 것이다.
#' 
library(pryr)

df <- data.frame(x = 1:10, y = letters[1:10])

otype(df)

otype(df$x)

otype(df$y)

#' S3에서 메소드는 제너릭 함수, 또는 짧게 제너릭이라고 불리는 함수에 속한다. 
#' 
#' S3 메소드는 객체나 클래스에 속하지 않는다.
#' 
mean

ftype(mean)

#'

ftype(t.data.frame)

ftype(t.test)


methods("mean")

methods("t.test")

methods(class = "ts")

#' ### 클래스를 정의하고 객체 생성하기
#'
#' 한 번에 클래스를 생성하고 할당하기
foo <- structure(list(), class = "foo")

#' 클래스를 생성하고 난 후 설정하기
foo <- list()
class(foo) <- "foo"

class(foo)

inherits(foo, "foo")

foo <- function(x) {
  if(!is.numeric(x)) stop("X must be numeric" )
  structure(list(x), class = "foo")
}

#' 개발자가 제공한 생성자 함수와는 별도로 S3는 정확성을 체크하지 않는다. 이것은 기존 객체의 클래스를 변경할 수 있다는
#' 것을 의미한다.
#'
#' 선형 모형 생성
#'
mod <- lm(log(mpg) ~ log(disp), data = mtcars)
class(mod)

print(mod)

#' 원래 **lm**인 클래스를 **data.frame** 에 삽입해보자. 그러나 이것이 잘 동작하지 않을 것은 예상할 수 있다.
class(mod) <- "data.frame"

print(mod)

#' 그러나 데이터는 여전히 그대로 있다. 

mod$coefficients

#' ### 새로운 메소드와 제너릭 생성하기
#'
f <- function(x) UseMethod("f")
#'

#' 제너릭 함수는 메소드가 없으면 유용하지 않다. 메소드를 추가하려면 정확한 (generic.class) 이름으로 정규 함수를 생성하면 된다.
#' 
f.a <- function(x) "Class a"

a <- structure(list(), class ="a")

class(a)

f(a)
#'

mean.a <- function(x) "a"
mean(a)
#'
#' 메소드는 제너릭과 호환되는 클래스를 반환하는지의 여부를 확인하지 않는다.

#' ### 메소드 디스패치
#'
#' S3 메소드 디스패치는 상대적으로 간단하다. `UseMethod()`는 `paste0("generic", ".", "c(class(x), "default"))`처럼
#' 함수 이름 벡터를 생성한 후 각각을 순서대로 탐색한다.
#'
f <- function(x) UseMethod("f")
f.a <- function(x) "Class a"
f.default <- function(x) "Unknown class" 

f(structure(list(), class = "a"))

#' **b** 클래스에 대한 메소드가 없으므로 **a** 클래스에 대한 메소드를 사용한다.
#'
f(structure(list(), class = c("b", "a")))

#'
#' **c** 클래스에 대한 메소드가 없으므로 기본값으로 돌아간다.
f(structure(list(), class = "c"))

#' `group_generic`은 하나의 함수로 복수의 제너릭에 대한 메소드 구현을 가능하게 한다. 
#'
#' 네 개의 `group_generic`과 그것들이 포함하는 함수는 다음과 같다.
#'
#' - Math : abs, sign, sqrt, floor, cos, sin, log, exp,...
#'
#' - Ops : +, -, *, /, ^, %%, %/%, &, |, ==, !=, <, <=, >=, >
#' 
#' - Summary : all, amy, sum, prod, min, max, range
#' 
#' - Complex : Arg, Conj, Im, Mod, Re
#' 
#' 그룹 제너릭 함수 내부에서 특수한 변수인 `.Generic`이 호출된 실제 제너릭 함수를 제공한다는 점에 주의하여야 한다.
#' 
#' 메소드는 일반적이 R 함수이기 때문에 그 메소드를 직접 호출할 수 있다.
#' 
c <- structure(list(), class = "c")

#' 올바른 메소드 호출
#' 
f.default(c)

#' R이 잘못된 메소드를 호출하도록 강제
f.a(c)


#' ### 연습문제
#' 
#' 1. `t()`와 `t.test()`의 소스 코드를 읽어보고, `t.test()`가 `S3` 메소드가 아니라 `S3` 제너릭인 것을 확인하라. 
#' `test` 클래스와 이 클래스를 이용한 `t()` 호출을 생성한다면 어떤 일이 일어나는가?
#' 

stats:::t.ts

getAnywhere(t.ts)


#' 2. 어떤 클래스가 베이스 R의 Math 그룹 제너릭에 대한 메소드를 가지는가? 소스 코드를 읽어보라. 그 메소드가 어떻게
#' 동작하는가?
#' 
#' 
#' 3. R은 일시(datetime) 데이터를 표현하기 위한 두 가지 클래스(POSIXct와 POSIXlt)를 갖고 있는데, 이 둘은 모두 POSIXt를 
#' 상속한 것이다. 어느 제너릭이 이 두 클래스에 대해 상이한 행동을 하는가? 어느 제너릭이 동일한 행동을 공유하는가?
#' 
#' 4. 어느 베이스 제너릭이 가장 많은 수의 정의된 메소드를 갖고 있는가?
#' 
#' 5. UseMethod()는 특별한 방법으로 메소드를 호출한다. 다음 코드가 무엇을 반환할지 예상해 본 후 실행해 보고,
#' 어떤 일이 일어나고 있는지 확인하기 위해 UseMethod()의 도움말을 읽어보라. 가능한 한 가장 단순한 형태로 그 규칙을 
#' 설명해 보라.
#' 
y <- 1
g <- function(x) {
  y <- 2
  UseMethod("g")
}

g.numeric <- function(x) y
g(10)

 h <- function(x) {
   x <- 10
   UseMethod("h")
 }

h.character <- function(x) paste("char", x)
h.numeric <- function(x) paste("num", x)

h("a")


#'
#' 6. 내부 제너릭은 베이스 타입의 내재 클래스에 디스패치 않는다. 다음 사례에서 f와 g의 길이가 다른 이유를 알아내기 위해
#' 내부 제너릭 문서를 주의깊게 읽어보라. 어떤 함수가 f와 g의 행동을 구별하는데 도움이 되는가?
#' 
f <- function() 1
g <- function() 2


class(g) <- "function"

class(f)
class(g)

length.function <- function(x) "function"
length(f)
length(g)



#' ### S4
#' 
#' formality and rigour
#' 
#' - 클래스는 그 필드와 상속구조(부모 클래스)를 설명하는 형식적 정의를 갖고 있다.
#' 
#' - 메소드 디스패치는 제너릭 함수에 대해 단 하나의 인자가 아니라 복수의 인자에 기초할 수 있다.
#' 
#' - 어떤 S4 객체로부터 슬롯(필드라고도 함)을 추출하기 위한 `@`이라는 특별한 연산자가 있다.
#' 
#' 
#' ### 객체, 제너릭 함수, 그리고 메소드 인식
#' 
library(stats4)

# example(mle)에서

y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
nLL <- function(lambda) - sum(dpois(y, lambda, log = T))
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))

#' S4 객체
isS4(fit)


otype(fit)

#' S4 제너릭
isS4(nobs)

ftype(nobs)

#' 나중에 설명되어 있는 S4 메소드 추출

mle_nobs <- method_from_call(nobs(fit))
isS4(mle_nobs)


ftype(mle_nobs)

#' 객체가 상속한 모든 클래스를 나열 : `is()`
is(fit)

#' 객체가 특정한 클래스를 상속햇는지를 나열 : `is(a, b)`
is(fit, "mle")


#' getGenerics()로 모든 S4 제너릭의 목록을 얻을 수 있다.
#' 
#' getClasses()로 모든 S4 클래스의 목록을 얻을 수 있다.
#'
#' 이 목록은 S3 클래스와 베이스타입에 대한 `shim` 클래스를 포함한다.
#'
#' showMehod()로 선택을 제한하면서 S4 메소드를 나열할 수 있다.
#' 
#' 전역환경에서 사용할 수 있는 메소드에 대한 검색을 제한하기 위해 `where = search()`를
#' 사용하는 것도 좋은 아이디어이다.
#' 
#' ### 클래스를 정의하고 객체 생성하기
#' 
#' S4는 반드시 `setClass()`로 클랫의 표현을 정의하고, `new()`로 새로운 객체를 생성해야 한다.
#' 
#' `class?mle`처럼 특수한 구문으로 특정 클래스에 대한 문서를 찾을 수 있다.
#' 
#' 세 가지 핵심적인 특징을 가지고 있다.
#' 
#'  - 이름(name) : `alpha-numeric` 클래스 식별자. 관행적으로 S4 클래스의 이름은 문자형 낙타등표기법(UpperCamelCase)을 사용한다.
#'  
#'  - 슬롯 이름과 허용된 클래스를 정의하는 이름 있는 리스트로 된 `slots` 또는 `fields`. 예를들면
#'  `list(name = "character", age = "numeric"` 처럼 사용
#'  
#'  - 상속받은 클래스를 전달하는 문자열(S4 contain). 다중 상속에 다중 클래스를 제공할 수 있지만 복잡하다.
#'  
setClass("Person",
         slots = list(name = "character", age = "numeric"))

setClass("Employee",
         slots = list(boss = "Person"),
         contains = "Person")

alice <- new("Person", name = "Alice", age = 40)
john <- new("Employee", name = "John", age = 20, boss = alice)


alice@age

slot(john, "boss")

setClass("RangedNumeric",
         contains = "numeric",
         slots = list(min))

#' ### 새로운 메소드와 제너릭 생성하기
#' 
#' - `setGeneric()` : 새로운 제너릭을 생성하거나 기존 함수를 제너릭으로 반환
#'
#' - `setMethod()` : 제너릭의 이름, 메소드가 연계되어야 할 클래스, 그리고 그 메소드를
#' 구현한 함수를 취함.
#' 
setGeneric("union")

setMethod("union",
          c(x = "data.frame",  y = "data.frame"),
          function(x, y) {
            unique(rbind(x, y))
          })

#' 새로운 제너릭을 처음부터 생성한다면 `standardGeneric()`을 호출하는 함수를 제공할 
#' 필요가 있다.
#' 
setGeneric("myGeneric", function(x) {
  standardGeneric("myGeneric")
})


#' 메소드 디스패치
#' 
#' 메소드에서 제너릭 이름과 클래스 이름을 취함
selectMethod("nobs", list("mle"))

#' `pryr`에서 : 비평가된 함수 호출 취함
method_from_call(nobs(fit))


#' ### 연습문제
#' 
#' 1. 가장 많은 메소드를 가지는 S4 제너릭은 무엇인가? 가장 많은 메소드와 연계되어 있는
#' S4 클래스는 무엇인가?
#' 
#' 2. 기존 클래스를 포함하지 않는 새로운 S4 클래스를 정의하면 무슨 일이 일어나는가?
#' 
#' 3. S4 객체를 S3 제너릭에 전달하면 어떻게 되는가? 




















































































