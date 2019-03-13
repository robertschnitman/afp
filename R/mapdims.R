#' Map over matrix dimensions separately in a single function call
#' 
#' @description Map over matrix dimensions separately in a single function call 
#' 
#' @usage mapdims(f, x, ...)
#' mapc(f, x)
#' mapr(f, x)
#'
#' @param f A function to apply to the 2D dataset.
#' @param x A dataset, such as an array or data frame.
#' @param ... Arguments passed to the \code{f}.
#' 
#' @return List for mapdims(). Two elements: \code{rowwise} for the row-wise computations, and \code{colwise} for the column-specific results. Output is array for `mapc()` and `mapr()`
#' 
#' @details Apply function over dimensions and save the column- and row-wise results separately in a list with `mapdims()`; convenient `apply()` abbreviations with `mapc()` and `mapr()`.
#' 
#' @examples
#' mapdims(median, mtcars)
#' mapdims(mean, airquality, na.rm = TRUE)
#' mapc(median, mtcars)
#' mapr(median, mtcars) 
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{apply}}

#' @rdname mapdims
mapdims <- function(f, x, ...) {
  
  ## 1. Type-check data object x.
  diml <- length(dim(x))
  if (!diml) stop('dim(x) must have a positive length. Please make sure x has at least 2 dimensions!')
  
  ## 2. For each dimension, apply the function.
  # Row results first to coincide with R conventions.
  output <- lapply(1:2, function(i) apply(x, i, f, ...))
  
  names(output) <- c('rowwise', 'colwise') # To denote the dimension-specific results.
  
  output
  
}

#' @rdname mapc
mapc <- function(f, x, ...) apply(x, 2, f, ...)

#' @rdname mapr
mapr <- function(f, x, ...) apply(x, 1, f, ...)
