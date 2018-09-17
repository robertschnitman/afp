#' Naming and input consistency within the Base R *apply() family.
#' 
#' @description Consistent naming and inputs for the \code{\link{*apply}} family--they all start with "apply", and the first two inputs are the function and object.
#' @usage apply(f, x, m, ...) # \code{\link{apply}}
#' applyl(f, x, ...)  # \code{\link{lapply}}
#' applym(f, ..., moreargs = NULL, simplify = TRUE, use.names = TRUE) # \code{\link{mapply}}
#' applys(f, x, ..., simplify = TRUE, use.names = TRUE) # \code{\link{sapply}}
#' applyt(f = NULL, x, index, ..., default = NA, simplify = TRUE) # \code{\link{tapply}}
#' applyr(f, x, classes = 'ANY', default = NULL, how = c("unlist", "replace", "list"), ...) # \code{\link{rapply}}
#' applyv(f, x, f.value, ..., use.names = TRUE) # \code{\link{vapply}}
#'
#' @param f Function.
#' @param x Object.
#' @param m Margin. See \code{\link{apply}}.
#' @param moreargs Additional arguments to the given function. See \code{\link{mapply}}.
#' @param simplify Boolean value determines whether the output is an array or list. See \code{\link{mapply}}, \code{\link{sapply}}, and \code{\link{tapply}}.
#' @param use.names Determines whether the output uses names if defiened in \code{x}. See \code{\link{mapply}}, \code{\link{sapply}}, and \code{\link{vapply}}.
#' @param index List of factors that is the same length as \code{x}. See \code{\link{tapply}}.
#' @param default The default value of any missing element (if the output is an array). See \code{\link{tapply}}.
#' @param classes Vector of \code{\link{class}} names.See \code{\link{rapply}}.
#' @param how Determines whether the output is an array, list, or replaces elements of some original list. See \code{\link{rapply}} 
#' @param f.value Generalized vector that establishes the return value from \code{f}. Useful for type-checking. See \code{\link{vapply}} 
#' @param ... Inputs passed to the respective \code{*apply} family.
#' 
#' @details 
#' The naming scheme converts the \code{*apply} prefixes into suffixes (e.g. \code{applys} instead of \code{sapply}). The first input is a function \code{f}, while the second parameter is an object \code{x}. The order of the rest of the inputs follows the same pattern in their respective functions on which they are based.
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{apply}}, \code{\link{lapply}}, \code{\link{sapply}}, \code{\link{mapply}}

#' @name applyfamily

apply  <- function(f, x, m, ...) apply(X = x, MARGIN = m, FUN = f, ...)
applyl <- function(f, x, ...) lapply(X = x, FUN = f, ...)
applym <- function(f, ..., moreargs = NULL, simplify = TRUE, use.names = TRUE) mapply(FUN = f, ..., MoreArgs = moreargs, SIMPLIFY = simplify, USE.NAMES = use.names)
applys <- function(f, x, ..., simplify = TRUE, use.names = TRUE) sapply(X = x, FUN = f, ..., simplify = simplify, USE.NAMES = use.names)
applyt <- function(f = NULL, x, index, ..., default = NA, simplify = TRUE) tapply(X = x, INDEX = index, FUN = f, ..., deflt = default, simplify = simplify)
applyr <- function(f, x, classes = 'ANY', default = NULL, how = c("unlist", "replace", "list"), ...) {
  
  rapply(object = x, f = f, classes = classes, default = default, how = how, ...)
  
}
applyv <- function(f, x, f.value, ..., use.names = TRUE) vapply(X = x, FUN = f, FUN.VALUE = f.value, ..., USE.NAMES = use.names)
  
  
  