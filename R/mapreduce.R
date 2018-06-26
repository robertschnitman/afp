#' Apply function over collection and then iteratively reduce it a la` mapreduce() from Julia
#'
#' @param f A function to apply to the collection.
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param x A collection, such as a a list, matrix, or data frame.
#' @param y A list of additional arguments from \code{f}. Passed to MoreArgs from \code{\link{Map}}.
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @details A simplified \code{mapreduce} from Julia with a multivariate option.
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
#' # 2. Use multiple arguments.
#' matrixl <- list(A = matrix(c(1:9), 3, 3), B = matrix(10:18, 3, 3), C = matrix(19:27, 3, 3))
#' output2 <- with(matrixl, mapreduce(function(i, j, k) i*j - k, `/`, A, list(B, C)))
#' output2
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Map}}, \code{\link{Reduce}}
#' \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}}

mapreduce <- function(f, o, x, y = NULL, ...) {
  
  # 1. Stop if f/o inputs do not match any existing/anonymous functions.
  f <- match.fun(f)
  o <- match.fun(o)
  
  # 2. Map the function f to collection x and iteratively reduce the mapping by the binary operator o.
  # output <- Reduce(o, mapply(f, x, MoreArgs = y, SIMPLIFY = FALSE), ...)
  output <- Reduce(o, Map(f, x, MoreArgs = y), ...)
  
  # 3. Output should be a matrix or data frame.
  output
  
}
