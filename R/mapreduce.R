#' Apply function over collection and then iteratively reduce it a la` mapreduce() from Julia
#'
#' @param f A function to apply to the collection.
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param x A collection, such as a a list, matrix, or data frame.
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @return Vector. Can differ based on the given inputs. For example, if accumulate = TRUE (via \code{\link{Reduce}}), a vector of length > 1 is returned; otherwise, a 1-element result.
#' 
#' @details A simplified \code{mapreduce} from Julia.
#' 
#' Base R has functionals that output a list by way of \code{\link{lapply()}} and \code{\link{Map}} (among others), while \code{\link{Reduce}} diminishes given elements in a consecutive manner until a single result remains. To reduce the output of a mapping, the mentioned functions are required. 
#' 
#' In turn, \code{mapreduce} simplifies this process.
#' 
#' @examples
#' # 1. Apply a function to 3 matrices and consecutively divide them.
#' matrixl <- list(A = matrix(c(1:9), 3, 3), B = matrix(10:18, 3, 3), C = matrix(19:27, 3, 3))
#' output1 <- mapreduce(function(x) x^2 + 1, `/`, matrixl) 
#' output1 # matrix 3x3
#' 
#' # 2. Split a dataset, apply a ratio to each subset, and then sum said ratios.
#' split2  <- split(mtcars, mtcars$gear)
#' seqrng  <- function(x) {seq(min(x), mean(x), mean(x) - min(x))}
#' adhoc   <- function(x, y) {seqrng(x)/seqrng(y)}
#' output2 <- mapreduce(function(s) with(s, adhoc(mpg, disp)), `+`, split2)
#' output2 # numeric, length 2
#' 
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Map}}, \code{\link{Reduce}}
#' \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}}

# .
mapreduce <- function(f, o, x, ...) {
  
  # 1. Stop if f/o inputs do not match any existing/anonymous functions.
  f <- match.fun(f)
  o <- match.fun(o)
  
  # 2. Map the function f to collection x and iteratively reduce the mapping by the binary operator o.
  output <- Reduce(o, Map(f, x), ...)
  
  # 3. Output should be a matrix or data frame.
  output
  
}