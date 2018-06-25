#' Map function to a 2D dataset and reduce the results based on a given margin.
#'
#' @param f A function to apply to the collection.
#' @param o A binary operator. Typically arithmetic operators, but can be another (binary) function.
#' @param x A matrix, or data frame.
#' @param m Margin. 1 = row-wise; 2 = column wise. See \code{\link{apply}}.
#' @param ... Arguments passed to \code{\link{Reduce}}.
#' 
#' @return Vector. Can differ based on the given inputs. For example, if accumulate = TRUE (via \code{\link{Reduce}}), a vector of length > 1 is returned; otherwise, a 1-element result.
#' 
#' @details \code{\link{mapreduce}} with the option to apply a function over the columns or rows. Effectively calls \code{\link{apply}} and \code{\link{mapreduce}}.
#' 
#' @examples
#' # 1. Apply a function row-wise and consecutively add them.
#' output1 <- mrchop(function(x) x/2, `+`, mtcars, 1)
#' output1 # vector.
#' 
#' # 2. Apply a function column-wise and iteratively divide them.
#' output2 <- mrchop(function(x) x^2 + 1, `/`, na.omit(airquality), 2)
#' output2 # vector.
#' 
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{Map}}, \code{\link{Reduce}}, \code{\link{mapreduce}}, \code{\link{apply}}
#' \code{mapreduce} from Julia:\url{https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple{4,Any}}

mrchop <- function(f, o, x, m, ...) {
  
  # 1. Type-check inputs.
  f <- match.fun(f)
  o <- match.fun(o)
  
  stopifnot(is.matrix(x) | is.data.frame(x))
  
  # 2. Use apply() to set margins.
  output <- apply(x, m, function(y) mapreduce(f, o, y, ...))
  
  # 3. Output should be a 2 dimensional dataset (matrix/data frame)
  output
  
}
