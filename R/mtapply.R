#' Multivariate tapply()
#' 
#' @description Apply a function over an array by a list of indices. Multivariate version of \code{\link{tapply}}.
#' 
#' @param X Object where \code{\link{split}} is applicable. See \code{\link{tapply}}.
#' @param INDEX List of indices. See \code{\link{tapply}} for univariate case.
#' @param FUN Function to apply. See \code{\link{tapply}}.
#' @param ... Parameters passed to \code{\link{mapply}}.
#' 
#' @return List.
#' 
#' @details Unlike \code{\link{tapply}}, one can pass a list of datasets and indices to \code{\link{mtapply}}.
#' 
#' @examples
#' # For each variable in a dataset, obtain means by a different index.
#' A <- mtcars[, c('mpg', 'wt', 'disp')]  # Targets.
#' B <- mtcars[, c('gear', 'am', 'carb')] # Indices.
#' mtapply(A, B, mean)
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{tapply}}, \code{\link{mapply}}

mtapply <- function(X, INDEX, FUN = NULL, ...) {
  
  # 1. Type-check inputs.
  FUN    <- match.fun(FUN)
  
  if (!is.list(X)) {X <- as.list(X)}
  if (!is.list(INDEX)) {INDEX <- as.list(INDEX)}
  
  # 2. Generalize tapply for the multivariate case.
  tapfun <- function(a, b) tapply(a, b, FUN) # Writing the tapply() on this line makes the output-assignment line more readable than otherwise.
  
  output <- mapply(tapfun, X, INDEX, ...)
  
  # 3. Edit names of the output to differentiate/identify the target and associated index.
  names(output) <- paste0(names(output), '_by_', names(INDEX))
  
  output                                     # Output = list. See tapply documentation.
  
}
