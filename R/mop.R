#' Mop an array with multiple functions
#' 
#' @description Based on \code{\link{sweep}}, operate on an array by a summary statistic function.
#' 
#' @usage mop(f, s, x, m, ...)
#'
#' @param f A function, typically a binary operator.
#' @param s A summary statistic function such as \code{\link{mean}}.
#' @param x An array.
#' @param m Margin. 1 for rows, 2 for columns.
#' @param ... Arguments passed to \code{\link{sweep}}.
#' 
#' @details Essentially, \code{mop} is a wrapper for \code{sweep(x, MARGIN, apply(...), FUN)}. Useful for indexing variables by their means, for example, so that the magnitude of a value relative to its average is known.
#' 
#' @example
#' mop(`/`, mean, mtcars, 2) # == sweep(mtcars, 2, apply(mtcars, 2, mean), `/`)
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{sweep}}

mop <- function(f, s, x, m, ...) {
  
  # 1. Check inputs.
  f <- match.fun(f)
  s <- match.fun(s)
  
  diml <- length(dim(x))
  if (!diml) stop('dim(x) must have a positive length.')
  
  if (!any(m == 1:2)) stop('The m (margin) input must either be 1 (row-wise) or 2 (column-wise).')
  
  # 2. Sweep out the summary statistic function
  summ_stats <- apply(x, m, s) # apply() allows us to control for margins.
  
  output <- sweep(x, m, summ_stats, f, ...)
  
  # 3. Output should be 2D; its class should be the same as x.
  output
  
}