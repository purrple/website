
### read the data
d <- read.csv( "data.txt" )
d$bank <- ordered( d$bank, levels = d$bank )

### load lattice and grid
require( lattice )

### setup the key
k <- simpleKey( c( "Q2 2007",  "January 20th 2009" ) )
k$points$fill <- c("lightblue", "lightgreen")
k$points$pch <- 21
k$points$col <- "black"
k$points$cex <- 1

### create the plot
dotplot( bank ~ MV2007 + MV2009 , data = d, horiz = T, 
	par.settings = list( 
		superpose.symbol = list( 
			pch = 21, 
			fill = c( "lightblue", "lightgreen"), 
			cex = 4, 
			col = "black"  
		)
	 ) , xlab = "Market value ($Bn)", key = k, 
	 panel = function(x, y, ...){
	   panel.dotplot( x, y, ... )
	   grid.text( 
	   		unit( x, "native") , unit( y, "native") , 
			label = x, gp = gpar( cex = .7 ) )
	 } ) 
