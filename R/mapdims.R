#' Map over matrix dimensions separately in a single function call
#' 
#' @description Apply function over dimensions and save the column- and row-wise results separately in a list.
#' 
#' @usage mapdims(f, x, ...)
#'
#' @param f A function to apply to the 2D dataset.
#' @param x A 2D dataset, such as a matrix or data frame.
#' @param ... Arguments passed to the \code{f}.
#' 
#' @return List. Two elements: \code{rowwise} for the row-wise computations, and \code{colwise} for the column-specific results.
#' 
#' @examples
#' mapdims(median, mtcars)
#' 
#' mapdims(mean, airquality, na.rm = TRUE)
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{apply}}

mapdims <- function(f, x, ...) {
  
  ## 1. Type-check data object x--must be 2D due to apply().
  stopifnot(length(dim(x)) == 2)
  
  ## 2. For each dimension, apply the function.
  # Row results first to coincide with R conventions.
  output <- lapply(1:2, function(i) apply(x, i, mean, ...))
  
  names(output) <- c('rowwise', 'colwise') # To denote the dimension-specific results.
  
  output
  
}
