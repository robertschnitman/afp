#' Apply function over collection and then filter it with a predicate function
#' 
#' @description Apply function over collection and then filter it with a predicate function. Effectively, this function calls \code{mapply} and \code{Filter}.
#'
#' @param f A function to apply to the collection.
#' @param p Predicate function to filter the data. See \code{\link{Filter}}.
#' @param x A collection, such as a list, matrix, or data frame.
#' @param ... Arguments passed to \code{\link{mapply}}.
#' 
#' @details When operating on lists, combining \code{mapfilter} with \code{\link{telecast}} is advised if the list elements are disparate.
#' 
#' @examples
#' # 1. Obtain the squared even elements from a vector.
#' A       <- 1:50
#' is.even <- function(x) x %% 2 == 0
#' output1 <- mapfilter(function(x) x^2, is.even, A)
#' output1
#' 
#' # 2. For each dataset and its set of variables, find the cubed odd elements.
#' l       <- list(mc = mtcars, aq = airquality, lcs = LifeCycleSavings)
#' is.odd  <- function(x) x %% 2 == 1
#' mf.odd  <- function(x) mapfilter(function(y) y^3, is.odd, x)
#' output2 <- telecast(mf.odd, l)
#' output2 # list of lists.
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Map}}, \code{\link{Filter}}, \code{\link{telecast}}

mapfilter <- function(f, p, x, ...) {
  
  # 1. Type-check inputs
  f <- match.fun(f)
  p <- match.fun(p)
  
  # 2. Map THEN filter.
  output <- Filter(p, mapply(f, x, ...))
  
  # 3. Output varies based on the passed functions and how SIMPLIFY in mapply() is set.
  output
  
}
