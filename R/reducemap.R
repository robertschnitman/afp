#' Reduce a dataset by a margin and apply a function afterward
#'
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param m Margin. 1 = row-wise; 2 = column-wise (default). See \code{\link{apply}}.
#' @param f A function to apply to the collection.
#' @param x A collection, such as a a list, matrix, or data frame. 
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @details Inverse of \code{mapreduce}: reduce a dataset row-wise or column-wise, applying a function on the collection afterward.
#' 
#' Effectively, this function calles \code{\link{mapply}} and \code{\link{reducechop}}.
#' 
#' @examples
#' reducemap(`+`, 2, function(x) x^2, mtcars) # Add all values for each variable and then square the reduction.
#' reducemap(`-`, 1, function(x) x^2, mtcars, right = TRUE) # Subtracts iteratively starting from the rightmost row
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{mapply}}, \code{\link{Reduce}}, \code{\link{reducechop}}
#' \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}}

reducemap <- function(o, m = 2, f, x, ...) {
  
  # 1. Stop if f/o inputs do not match any existing/anonymous functions.
  f <- match.fun(f)
  o <- match.fun(o)
  
  # 2. Reduce THEN map.
  output <- mapply(f, reducechop(o, x, m, ...))
  
  # 3. Output should be matrix or data frame--same as mapreduce.
  output
  
}