#' Multivariate tapply()
#' 
#' @description Apply a function over an array by a list of indices. Multivariate version of \code{\link{tapply}}.
#' 
#' @param f Function to apply. See \code{\link{tapply}}.
#' @param x Object where \code{\link{split}} is applicable. See \code{\link{tapply}}.
#' @param index List of indices. See \code{\link{tapply}} for univariate case.
#' @param ... Parameters passed to \code{\link{mapply}}.
#' 
#' @return List.
#' 
#' @details Unlike \code{\link{tapply}}, one can pass a list of datasets and indices to \code{\link{applytm}}.
#' 
#' @examples
#' # For each variable in a dataset, obtain means by a different index.
#' A <- mtcars[, c('mpg', 'wt', 'disp')]  # Targets.
#' B <- mtcars[, c('gear', 'am', 'carb')] # Indices.
#' applytm(A, B, mean)
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{tapply}}, \code{\link{mapply}}, \code{\link{dot}},

applytm <- function(f = NULL, x, index, ...) {
  
  # 1. Type-check inputs.
  f    <- match.fun(f)
  
  if (!is.list(x)) {x <- as.list(X)}
  if (!is.list(index)) {index <- as.list(index)}
  
  # 2. Generalize tapply for the multivariate case.
  tapfun <- function(a, b) tapply(a, b, f) # Writing the tapply() on this line makes the output-assignment line more readable than otherwise.
  
  output <- mapply(tapfun, X = x, INDEX = index, ...)
  
  # 3. Edit names of the output to differentiate/identify the target and associated index.
  names(output) <- paste0(names(output), '_by_', names(index))
  
  output # Output = list. See tapply documentation.
  
}
