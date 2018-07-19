#' Logical statements for even and odd values.
#'
#' @param x Numeric (integer).
#' 
#' @return Boolean.
#' 
#' @examples
#' is.even(1)
#' sapply(mtcars$gear, is.even)
#' is.odd(2)
#' sapply(mtcars$gear, is.odd)
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}; `iseven()` and `isodd` in \url{https://docs.julialang.org/en/release-0.4/stdlib/numbers/}
#' @name is.evenodd
NULL
#> NULL

#' @rdname is.evenodd
is.even <- function(x) x %% 2 == 0

#' @rdname is.evenodd
is.odd <- function(x) x %% 2 == 1
  
  
  
