Title: "chain"
Author: "Robert Schnitman"
Date: "October 13, 2018"

## 1. About
--------

The function `chain()`, created under `telecast.r`, is a simplification
of `telecast()`: the output will be a matrix via `sapply()`.

    chain <- function(f, l) {
      
      # 1. Type-check inputs.
      f <- match.fun(f)
      
      # 2. Compute nestesd sapply().
      s <- sapply(l, function(z) sapply(z, f))
      
      # 3. Output should be a 2D object.
      output <- t(s)
      
      output
      
    }

## 2. Example
----------

    l <- split(mtcars, mtcars$cyl) 
    output <- chain(mean, l)

    all(chain(mean, l) == t(sapply(l, function(z) sapply(z, mean))))

    ## [1] TRUE

    barplot(output[, 'mpg'], col = 'cyan3', ylab = 'Mean MPG', xlab = 'Number of Cylinders')

![](plots//chain_ex1.png)

*End of Document*
