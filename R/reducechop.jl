"""
reducechop(o, x, m)
	
Reduce a given collection x with a given binary operator o column-wise (m = 1) or row-wise (m = 2).

OUTPUT: array/dataframe.

# sources
Main: https://github.com/robertschnitman/afpj

"""

reducechop(o, x, m) = mapslices(z -> reduce(o, z), x, m)