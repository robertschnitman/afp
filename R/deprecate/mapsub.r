#' Apply function over a collection and then substitute values
#' 
#' @description After mapping a function over a dataset, substituting specific values may be warranted. For example, a percent change between two periods cannot be calculated formally if the first of them is 0, which is indivisible. At that point, substituting a 1 (for 100%) would avoid an `Inf`` value in the output.
#' 
#' As such, \code{mapsub} facilitates this process by calling \code{\link{mapply}} and \code{\link{ifelse}}.
#'
#' @param f A function to apply to the collection.
#' @param p A Predicate function.
#' @param x A collection, such as a a list, matrix, or data frame.
#' @param ... Arguments passed to \code{mapply}.
#' 
#'@examples
#'# Example 1 - Replace even, rounded means with 1.
#'is.even <- function(k) k %% 2 == 0
#'mapsub(function(x) floor(mean(x)), is.even, mtcars, 1)
#'
#'# Example 2 - Redact a greeting due to their boring name.
#'people <- c("Aoi", "Tae Min", "Kali", "Robert")
#'myname <- function(x) paste0("My name is ", x)
#'cutoff <- function(x) grepl("Robert", x)
#'mapsub(myname, cutoff, people, "REDACTED - boring name (probably a boring person)")
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \url{https://github.com/robertschnitman/afpj/blob/master/src/mapsub.jl}, \code{\link{mapply}}, \code{\link{ifelse}}


mapsub <- function(f, p, x, out_true, ...) {
  
  # 1. Type-check inputs
  f <- match.fun(f)
  p <- match.fun(p)
  
  # 2. Map THEN substitute.
  m <- mapply(f, x, ...)
  
  output <- ifelse(p(m), out_true, m)
  
  # 3. Output can be tabular, list (depending on whether SIMPLIFY = FALSE is defined in first mapply()), OR data frame.
  output
  
}
