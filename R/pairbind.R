#' Append two datasets' rows in a pairwise fashion
#' 
#' @description Append two datasets' rows in a pairwise fashion. In other words, append the 1st row of the first dataset with the 1st row of the second dataset, the 2nd row of the first with the 2nd row of the second, and so on.
#'
#' @usage pairbind(x, y), pairbind_df(x, y)
#'
#' @param x 2D object (e.g. Data frame, matrix)
#' @param y Same as above.
#' @return  Same as above; except in the case of pairbind_df, which outputs a data frame.
#' 
#' @details This function can be useful for kable-friendly frequency distribution tables.
#' 
#' @examples
#' library(tidyverse)
#' library(knitr)
#' 
#' freq_df <- with(diamonds, table(color, clarity)) %>%
#'   as.data.frame() %>%
#'   spread(NCOL(.) - 1, NCOL(.)) %>%
#'   mutate(Total = apply(.[, 2:NCOL(.)], 1, sum))
#' 
#'  prop_df <- freq_df
#'  prop_df[, 2:NCOL(prop_df)] <- prop_df[, 2:NCOL(prop_df)]/prop_df$Total
#'  prop_df[, 2:NCOL(prop_df)] %<>% 
#'    map_df(~ paste0(round(.x*100), '%'))
#'   freq_df %<>% 
#'   format(., big.mark = ',', scientific = FALSE) %>%
#'   map_df(as.character)
#'   
#' prop_df %<>% map_df(as.character)
#' 
#' pairbind_df(freq_df, prop_df) %>% kable()
#'
#' @seealso \url{https://github.com/robertschnitman/afp}, \code{\link{lapply}}, \code{\link{do.call}}, \code{\link{rbind}}, \url{https://purrr.tidyverse.org/}

pairbind <- function(x, y) {
  
  do.bind(function(i) rbind(x[i, ], y[i, ]), 1:NROW(x))
  
}

pairbind_df <- function(x, y) {
  
  split <- lapply(1:NROW(x), function(i) rbind.data.frame(x[i, ], y[i, ]))
  
  output <- do.call(rbind.data.frame, split)
  
  output
  
}
