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
#' S3 객체인지 쉽게 확인하는 방법은 `is.object(x) & !isS4(x)`, 즉 개체이면서 S4가 아닌지를 평각하는 것이다.
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
#' 




































