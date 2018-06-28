***Robert Schnitman***  
***2018-06-23***  
***Recommended Citation:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Schnitman, Robert (2018). afp v0.0.0.1. <https://github.com/robertschnitman/afp>***

Outline
-------

0.  Installation
1.  Introduction
2.  `do.bind()`
3.  `mapreduce()`
4.  `telecast()`
5.  Conclusion
6. References

## 0. Installation
---------------

    ## Dependencies: R >= 3.5

    # install.packages("devtools")
    devtools::install_github("robertschnitman/afp")

## 1. Introduction
---------------

The `afp` package--*Applied Functional Programming*--provides
functionals to simplify iterative processes in R. The Base R `*apply()`
family, `purrr` library, and [Julia programming
language](https://julialang.org/) are the principal influences. The
former two contain tools essential for functional programming that
minimize the need to incorporate loops and increase code brevity;
however, there is inelegance with respect to specific situations.

For example, to map a function and consequently bind rows or columns,
`purrr` splits the decision into two functions rather than within one:
`map_dfr()` and `map_dfc()`, both of which only output to data
frames--while this feature is as intended, they nonetheless omit the
possibility of a matrix when such a data type is preferred.
Additionally, to reduce the results of a mapping, one must encase
`Map()`/`lapply()` in `Reduce()`, while [Julia blends the routine into
`mapreduce()`](https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple%7B4,Any%7D).

As such, `afp` exists to supplement the functionals in Base R,
`purrr`, and others to support efficient and concise programming.

The following sections provide examples for the primary functions:
`do.bind()`, `mapreduce()`, and `telecast()`.

## 2. `do.bind()`
--------------

When executing `lapply()` to manipulate subsets of data, calling
`rbind()` or `cbind()` within `do.call()` is common to fuse the
transformed partitions. While the implementation is possible on one line
by way of the `do.call(*bind, lapply(x, f))` form, the readability and
intended concision decreases as the complexity of the anonymous function
increases. Even if the `lapply()` portion is stored in an object before
hand, the intention of `do.call()` is not clear until `*bind` is stated.
To minimize these issues, `do.bind()` wraps this process and clarifies
its purpose: *bind the results of the given function*.

One may obtain similar results with `map_dfr()`/`map_dfc()` from
`purrr`; but the output would always result in a data frame rather than
the possibility of a matrix. Additionally, the binding rows or columns
must be done in different functions, whereas it can be defined within
`do.bind()`.

There are three required parameters in this function: `f`, `x`, and
`m`--respectively the function, collection (e.g. data frame), and
margin (rbind/cbind designation). If `m = 1` (the default), the results are
combined row-wise; `2` for column-wise. A fourth parameter `...` passes
to `do.call()`.

To note, the naming of this function is to be consistent with the
previously mentioned function.

### EXAMPLE - `do.bind()` \#1: Store subset-contingent lm() coefficients in a matrix.

    split1  <- split(mtcars, mtcars$gear)
    adhoc1  <- function(s) {coef(lm(mpg ~ disp + wt + am, s))}
    output1 <- do.bind(adhoc1, split1) # == do.call(rbind, lapply(split1, adhoc1)).
    output1                            # Rownames indicate subset.

    ##   (Intercept)         disp        wt        am
    ## 3    27.99461 -0.007982643 -2.384834        NA
    ## 4    46.68250 -0.097327135 -3.171284 -2.817164
    ## 5    41.77904 -0.006730729 -7.230952        NA

### EXAMPLE - `do.bind()` \#2: Compute the median ozone-temperature ratio for each given month.

    airquality2 <- na.omit(airquality) # NA values exist in airquality.
    split2      <- split(airquality2, airquality2$Month)
    adhoc2      <- function(x, y) {median(x/y)}
    output2     <- do.bind(function(s) with(s, adhoc2(Ozone, Temp)), split2, 2) 
    output2 # == do.call(cbind, lapply(split2, function(s) with(s, adhoc2(Ozone, Temp))))

    ##              5         6         7         8         9
    ## [1,] 0.3003337 0.3076923 0.7272928 0.5696203 0.2948718

## 3. `mapreduce()`
----------------

Base R has functionals that output a list by way of `lapply()` and
`Map()` (among others), while `Reduce()` diminishes given elements in a
consecutive manner until a single result remains. While these functions
are relatively straightforward to combine (depending on the functions
being passed), R does not inherently possess a singular function to
accomplish this operation [unlike `mapreduce()` in
Julia](https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple%7B4,Any%7D).

The three required parameters are `f`, `o`, and `x` ("fox",
collectively). A fourth parameter `...` passes to `Reduce()`.

In turn, `mapreduce()` in `afp` offers a simplified Julia-equivalent to
streamline the intended procedure in R.

### EXAMPLE - `mapreduce()` \#1: Element-wise divide manipulated matrices.

    matrixl <- list(A = matrix(c(1:9), 3, 3), B = matrix(10:18, 3, 3), C = matrix(19:27, 3, 3))
    output1 <- mapreduce(function(x) x^2 + 1, `/`, matrixl) # == Reduce(`/`, Map(function(x) x^2 + 1, matrixl))
    output1

    ##              [,1]         [,2]         [,3]
    ## [1,] 0.0000547016 0.0002061856 0.0003107868
    ## [2,] 0.0001022035 0.0002490183 0.0003310752
    ## [3,] 0.0001560306 0.0002837380 0.0003456270

### EXAMPLE - `mapreduce()` \#2: A case of multiple arguments.

    # Using the same list from the previous example...
    output2 <- with(matrixl, mapreduce(function(i, j, k) i*j - k, `/`, A, list(B, C)))
    output2

    ##               [,1]          [,2]          [,3]
    ## [1,] -1.387799e-10 -3.408547e-12 -3.442132e-13
    ## [2,] -2.925642e-11 -1.456427e-12 -1.839155e-13
    ## [3,] -9.059628e-12 -6.829299e-13 -1.031438e-13

## 4. `telecast()`
---------------

`Map()`/`mapply()` from Base R executes functions pairwise when given
multiple data objects, as do `map2()`/`pmap()` from `purrr`. While
beneficial in its own right, said functions cannot concisely map over
datasets *independently* of each other, which would be useful for
storing disparate information into a single list.

Inspired by [`broadcast()` from
Julia](https://docs.julialang.org/en/v0.6.1/manual/arrays/#Broadcasting-1),
`telecast()` essentially wraps `mapply()` within `lapply()` to achieve
this outcome.

The two functions (both required) are `f` and `l`, respectively a
function and list.

### EXAMPLE - `telecast()` \#1: Apply means to each variable for all datasets in a stored list.

    l <- list(mc = mtcars, aq = airquality, lcs = LifeCycleSavings)

    mean.nr <- function(x) mean(x, na.rm = TRUE) # airquality has NA values.
    output1 <- telecast(mean.nr, l) 
    output1 # Compare: lapply(l, function(x) mapply(mean.nr, x))

    ## $mc
    ##        mpg        cyl       disp         hp       drat         wt 
    ##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250 
    ##       qsec         vs         am       gear       carb 
    ##  17.848750   0.437500   0.406250   3.687500   2.812500 
    ## 
    ## $aq
    ##      Ozone    Solar.R       Wind       Temp      Month        Day 
    ##  42.129310 185.931507   9.957516  77.882353   6.993464  15.803922 
    ## 
    ## $lcs
    ##        sr     pop15     pop75       dpi      ddpi 
    ##    9.6710   35.0896    2.2930 1106.7584    3.7576

### EXAMPLE - `telecast()` \#2: Iteratively reduce each variable for all datasets in a list.

    # With the same list in the previous example...
    red.div <- function(y) Reduce(`/`, y)
    output2 <- telecast(red.div, l) 
    output2 # Compare: lapply(l, function(x) mapply(red.div, x))

    ## $mc
    ##          mpg          cyl         disp           hp         drat 
    ## 3.488260e-39 6.971465e-24 9.175733e-70 1.724534e-64 3.483381e-17 
    ##           wt         qsec           vs           am         gear 
    ## 1.767344e-15 2.807034e-38          NaN          Inf 2.126822e-17 
    ##         carb 
    ## 1.149781e-11 
    ## 
    ## $aq
    ##         Ozone       Solar.R          Wind          Temp         Month 
    ##            NA            NA 5.634846e-147 5.949698e-286 3.666302e-127 
    ##           Day 
    ## 2.556316e-167 
    ## 
    ## $lcs
    ##            sr         pop15         pop75           dpi          ddpi 
    ##  2.774085e-44  2.731185e-74  7.078060e-14 2.849951e-136  5.292273e-23

## 5. Conclusion
-------------

The functions discussed and demonstrated will be improved on a
continuous basis to (1) minimize repetitive iterative processing and (2)
emphasize code efficiency and brevity. New functions to be added based
on feasibility and future needs as appropriate.

## 6. References
-------------
[Julia programming language](https://julialang.org/)  
[Julia - `broadcast()`](https://docs.julialang.org/en/v0.6.1/manual/arrays/#Broadcasting-1)  
[Julia - `mapreduce()`](https://docs.julialang.org/en/v0.6.1/stdlib/collections/#Base.mapreduce-NTuple%7B4,Any%7D)  
[Tidyverse - `purrr`](https://purrr.tidyverse.org/)  

While not mentioned in this document, Hadley Wickham's [Advanced R](http://adv-r.had.co.nz/Functionals.html)
is a fabulous reference for functionals in R.

*End of Document*
