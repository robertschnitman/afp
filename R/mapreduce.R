#' Apply function over collection and then iteratively reduce it a la` mapreduce() from Julia
#' 
#' @description Apply function over collection and then iteratively reduce it a la` mapreduce() from Julia.
#' 
#' @usage mapreduce(f, o, x, y = NULL, ...)
#' mrchop(f, o, x, m, ...)
#' reducechop(o, x, m, ...)
#'
#' @param f A function to apply to the collection.
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param x A collection, such as a a list, matrix, or data frame.
#' @param y A list of additional arguments from \code{f}. Passed to MoreArgs from \code{\link{Map}}.
#' @param m Margin. 1 for rows, 2 for columns.
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @details A simplified \code{mapreduce} from Julia with a multivariate option.
#' 
#' Base R has functionals that output a list by way of \code{\link{lapply()}} and \code{\link{Map}} (among others), while \code{\link{Reduce}} diminishes given elements in a consecutive manner until a single result remains. To reduce the output of a mapping, the mentioned functions are required. In turn, \code{mapreduce} simplifies this process. 
#' 
#' The functions \code{mrchop} and \code{reducechop} have similar properties. The former applies \code{mapreduce} row-wise or column-wise, which can be specified; the latter applies \code{Reduce} in the same manner.
#' 
#' @examples
#' # 1. mapreduce: apply a function to 3 matrices and consecutively divide them.
#' matrixl <- list(A = matrix(c(1:9), 3, 3), B = matrix(10:18, 3, 3), C = matrix(19:27, 3, 3))
#' output1 <- mapreduce(function(x) x^2 + 1, `/`, matrixl) 
#' output1 # matrix 3x3
#' 
#' # 2. mapreduce: use multiple arguments.
#' matrixl <- list(A = matrix(c(1:9), 3, 3), B = matrix(10:18, 3, 3), C = matrix(19:27, 3, 3))
#' output2 <- with(matrixl, mapreduce(function(i, j, k) i*j - k, `/`, A, list(B, C)))
#' output2
#' 
#' # 3. mrchop.
#' mrchop(function(x) x/2, `+`, mtcars, 1)
#' 
#' # 4. reducechop.
#' reducechop(`+`, mtcars, 2) # Column-wise (default).
#' reducechop(`/`, mtcars, 1) # Row-wise. Equivalent to Reduce(`/`, mtcars).  
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Map}}, \code{\link{Reduce}}, \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}}

#' @rdname mapreduce
mapreduce <- function(f, o, x, y = NULL, ...) {
  
  # 1. Stop if f/o inputs do not match any existing/anonymous functions.
  f <- match.fun(f)
  o <- match.fun(o)
  
  # 2. Map the function f to collection x and iteratively reduce the mapping by the binary operator o.
  output <- Reduce(o, Map(f, x, MoreArgs = y), ...)
  
  # 3. Output should be a matrix or data frame.
  output
  
}

#' @rdname mrchop
mrchop <- function(f, o, x, m, ...) {
  
  # 1. Type-check inputs.
  f <- match.fun(f)
  o <- match.fun(o)
  
  stopifnot(is.matrix(x) | is.data.frame(x)) # Intent is that x is 2D.
  
  # 2. Use apply() to set margins.
  output <- apply(x, m, function(z) mapreduce(f, o, z, y = NULL, ...)) # Multivariate options have not been tested.
  
  # 3. Output should be a 2 dimensional dataset (matrix/data frame)
  output
  
}


#' @rdname reducechop
reducechop <- function(o, x, m, ...) {
  
  # 1. Type-check inputs.
  o <- match.fun(o)
  
  stopifnot(is.matrix(x) | is.data.frame(x)) # Intent is that x is 2D.
  
  if (!any(m == 1:2)) {
    
    stop('The margin must either be 1 (row-wise) or 2 (column-wise).')
    
  }
  
  # 2. Use apply() to set margins.
  output <- apply(x, m, function(z) Reduce(o, z, ...)) # Multivariate options have not been tested.
  
  # 3. Output should be a vector.
  output
  
}
