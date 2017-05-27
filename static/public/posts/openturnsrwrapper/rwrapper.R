#!/usr/bin/env Rscript

# grab arguments
argv <- commandArgs( TRUE )
datafile <- argv[1]
outfile  <- argv[2] 

# read data from data file 
rl <- readLines( datafile )
extract <- function( index = 1 ){
	rx <- sprintf( "^(I%d *= *)(.*)$", index )
	as.numeric( gsub( rx, "\\2", grep(rx, rl, value = TRUE ) ) ) 
}
x1 <- extract( 1 )
x2 <- extract( 2 )
x3 <- extract( 3 )

out <- x1 + x2 + x3
cat( "O1 = ", out, sep = "", file = outfile )

