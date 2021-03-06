#' Mop an array with multiple functions
#' 
#' @description Based on \code{\link{sweep}}, operate on an array by a summary statistic function.
#' 
#' @usage mop(x, m, s, f, ...), smop(x, s, f, ...), mop_div(x, s, ...)
#'
#' @param x An array.
#' @param m Margin. 1 for rows, 2 for columns.
#' @param s A summary statistic function such as \code{\link{mean}}.
#' @param f A function to be "swept" or "mopped" out, typically a binary operator.
#' @param ... Arguments passed to \code{\link{sweep}}.
#' 
#' @details Essentially, \code{mop} is a wrapper for \code{sweep(x, MARGIN, apply(...), FUN)}. Useful for indexing variables by their means, for example, so that the magnitude of a value relative to its average is known. The function \code{smop} simplifies \code{mop} by operating only on columns. The function \code{mop_div} simplifies \code{mop} further by operating only on columns and assuming \code{f} to be \code{`/`}.
#' 
#' @examples
#' mop(mtcars, 2, mean, `/`) # == sweep(mtcars, 2, apply(mtcars, 2, mean), `/`)
#' mop(mtcars, 2, median, `/`)
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{sweep}}

#' @rdname mop
mop <- function(x, m, s, f, ...) {
  
  # 1. Check inputs.
  f <- match.fun(f)
  s <- match.fun(s)
  
  diml <- length(dim(x))
  if (!diml) stop('dim(x) must have a positive length. Please make sure x is 2D!')
  
  if (!any(m == 1:2)) stop('The m (margin) input must either be 1 (row-wise) or 2 (column-wise).')
  
  # 2. Sweep out the summary statistic function
  summ_stats <- apply(x, m, s) # apply() allows us to control for margins.
  
  output <- sweep(x, m, summ_stats, f, ...)
  
  # 3. Output should be 2D; its class should be the same as x.
  output
  
}

smop <- function(x, s, f, ...) mop(x, 2, s, f, ...)

mop_div <- function(x, s, ...) smop(x, s, `/`, ...)
