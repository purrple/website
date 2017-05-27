#' get the extension of the files if they have one or "" otherwise
getExtension <- function( files ){
    out <- character( length(files) )
    has.ext <- grepl( "[.]", basename(files) )
    out[ has.ext ] <- sub( "^.*\\.(.*?)$", "\\1", files[has.ext], perl = T )
    out
}

#' process one svn log item, something like: 
# ------------------------------------------------------------------------
# r50000 | ripley | 2009-10-09 10:34:17 +0200 (Fri, 09 Oct 2009) | 1 line
# Changed paths:
#    M /branches/R-2-10-branch/src/library/stats/R/plot.lm.R
# 
# port r49999 from trunk
process_chunk <- function( txt ){
    if( length( txt ) == 1L ) return( NULL )
    
    header_line <- strsplit( txt[2L], " | ", fixed=TRUE )[[1]][ c(1L, 2L, 3L) ]
    
    # revision number
    revision <- substring( header_line[1], 2 )
    
    # who commited the revision
    author <- header_line[2]
    
    # these are uninteresting automatic commits (only data-stamp is involved)
    if( author %in% c("apache", "root" ) ) return(NULL)
    
    date     <- substring( header_line[3], 1, 10 )
    
    # process lines associated with files
    file_lines <- txt[ seq.int( 4L, which( txt == "" )[1L] - 1L ) ]
    file_lines <- strsplit( sub( "^ +", "", file_lines), " " )
    
    # M, A, D, ...
    actions <- sapply( file_lines, "[", 1L )
    
    # the files
    files   <- sapply( file_lines, "[", 2L )
    
    # we format the result as a matrix
    # this is much more efficient than formatting as a data frame
    # at that stage
    nlines  <- length( actions )
    matrix( c( 
        rep.int( revision, nlines ), 
        rep.int( author, nlines ), 
        rep.int( date, nlines ), 
        actions, 
        files ), nrow = nlines )
    
}

# bind all results
data <- local( {
    lines <- readLines( "rcpp.svnlog" )
    index <- cumsum( grepl( "^-+$", lines ) )
    commits <- split( lines, index )
    do.call( rbind, lapply( commits, process_chunk ) )
} )
colnames( data ) <- c( "revision", "author", "date", "action", "file" )

# extract some more information
data <- within( as.data.frame( data, stringsAsFactors = FALSE ), {
    date <- as.Date( date, format = "%Y-%m-%d") 
    revision <- as.integer( revision )
    extension <- getExtension( file )
    weekday  <- weekdays( date )
    year <- as.integer( format( date, "%Y" ) )
    month <- month.abb[ as.integer( format( date, "%m") ) ]    
} )
data <- subset( data, ! author %in% "stefan7th" )
data$author <- factor( as.character( data$author ) )

# a simpler data set, with only one entry per commit
simple <- data[ 
    !duplicated(data$revision), 
    c("revision","author","date", "month", "year", "weekday" ) ]

# aggregate the data daily
daydata <- local( {
    tab <- table( simple$date )
    within( data.frame( date = as.Date( names(tab) ), commits = as.integer(tab) ), {
        month <- as.integer( format( date, "%m") )
        weekday  <- weekdays( date )
        year <- as.integer( format( date, "%Y" ) )
    } )
} )

# aggregate data by day and author
day_author_data <- with( simple, aggregate( revision, 
    list( date = date, author = author ), length ) )
names( day_author_data )[3] <- "commits"
day_author_data$date <- as.Date( day_author_data$date )
day_author_data$month <- as.integer(format( day_author_data$date, "%m" ) )
day_author_data$year <- as.integer(format( day_author_data$date, "%Y" ) )

# and monthly
monthdata <- local({
    ym <- sprintf( "%04d-%02d", daydata$year, daydata$month )
    rx <- "^(\\d+)-(\\d+)$"
    ag <- aggregate( daydata$commits, list(date = ym), sum )
    names(ag)[2] <- "commits"
    within( ag, {
        year  <- sub( rx, "\\1", date )
        month <- sub( rx, "\\2", date )
        date  <- as.Date( paste( date, "01", sep = "-" ), format = "%Y-%m-%d" ) 
    } )
})

month_author_data <- local({
    ym <- sprintf( "%04d-%02d", day_author_data$year, day_author_data$month )
    rx <- "^(\\d+)-(\\d+)$"
    ag <- aggregate( day_author_data$commits, list(date = ym, author = day_author_data$author), sum )
    names(ag)[3] <- "commits"
    within( ag, {
        year  <- sub( rx, "\\1", date )
        month <- sub( rx, "\\2", date )
        date  <- as.Date( paste( date, "01", sep = "-" ), format = "%Y-%m-%d" ) 
    } )
})


# calculate the number of files in the distribution at each revision
# (sum of "A"dded files so far minus sum of "D"eleted files so far)
nfiles_data <- data.frame( 
    revision = sort( unique(data$revision ) ),
    nfiles   = cumsum( tapply( data$action, data$revision, function(x){ 
        sum( x == "A", na.rm = TRUE) - sum(x == "D", na.rm = TRUE) 
    } ) ), 
    date     = as.Date( tapply( as.character(data$date), data$revision, head, 1 ) ), 
    author = tapply( data$author, data$revision, head, 1 ) )

    
#' this fills y with 0 for x that are not in the range of dates
#' (thanks to Duncan Murdoch for the suggestion)
#' 
#' @param x dates
#' @param y numbers
#' @param start start date in the extended date vector
#' @param end end date in the extended date vector
#' @param by see ?seq.Date
panel.loess.fill <- function(x, y, by = "day", start = min(x), end = max(x), ...){
    xx <- seq.Date( start, end, by= by )
    yy <- numeric( length(xx) )
    not.zero <- xx %in% x
    if( any( not.zero ) ) yy[ not.zero ] <- y
    loess.out <- loess( as.numeric(yy) ~ as.numeric(xx) )
    panel.lines( xx, predict( loess.out), ... )
}

panel.monthlines <- function( 
    start = as.Date( "2008-01-01" ) , end = as.Date( "2020-09-01" ), 
    lwd = 0.5, col = "gray", ... ){
    
    months <- seq.Date( start, end, by = "month" )
    panel.abline( v = months, col = col, lwd = lwd, ... )
}
    
#' grabs version number, release dates and size of the R distribution
#' for each archive on CRAN
releaseDate <- function( 
    urls = "http://cran.r-project.org/src/contrib/Archive/Rcpp/", 
    pattern = "" ){
    
    rx <- '^.*(Rcpp_.*?gz).*?right">([^\\s>]*?)\\s.*?right">\\s?([^>]*?)<.*$'
    data <- do.call( rbind, lapply( urls, function( url ){
        txt <- grep( rx, readLines( url ), value = TRUE, perl = TRUE )
        parts <- sub( rx, "\\1--\\2--\\3", txt, perl = TRUE )
        do.call( rbind, strsplit( parts, "--" ) )
    } ) )
    colnames( data ) <- c("version", "date", "size")
    
    data <- within( as.data.frame( data ), {
        version <- sub( "^Rcpp_(.*)[.]tar[.]gz.*$", "\\1", version )
        date    <- as.Date( date, format = "%d-%b-%Y" )
        size    <- local({
            K <- grepl( "K$", size)
            x <- numeric( length( size ) )
            x[ K ]  <- as.numeric(sub( "K", "", size[K] )) / 1024
            x[ !K ] <- as.numeric(sub( "M", "", size[!K] ))
            x
        } )
    } )
    data[ grepl( pattern, data$version ), ]
}
lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
releases <- rbind( 
	releaseDate(), 
	data.frame( version = "0.8.5", date = as.Date( "2010-07-26" ), size = 1.6 )
	)
releases$major <- grepl( "[.]0$", releases$version )

#' helper function to draw R releases on the top axis
axis.releases <- function(side, ...) {
    switch(side,
        top = {
            panel.axis(side = side, outside = TRUE,
            	at = releases$date[ !releases$major ] , 
            	labels = releases$version[ !releases$major ], 
            	rot = 45)
            
            maj <- which( releases$major )
            for( i in 1:length(maj) )
            	try( panel.axis(side = side, outside = FALSE,
            		at = releases$date[ maj[i] ], 
            		labels = releases$version[ maj[i] ], 
                   rot = 0, text.fontface = "bold" , text.cex = 2), silent = TRUE )
             
        },
        bottom = {
        	months <- seq.Date( as.Date( "2008-01-01" ), as.Date( "2010-09-01" ), by = "month" )
    
        	panel.axis(side = side, outside = TRUE,
                       at = months, labels = substring( format(months, "%b" ), 1, 1 ), rot = 0 )
                       
           try( panel.axis(side = side, outside = FALSE, 
           		at = as.Date("2009-01-01"), labels = "2009", rot = 0, 
           		text.fontface = "bold", text.alpha = .5, text.col = "darkgray", 
           		text.cex = 2 ), silent = TRUE )
           panel.axis(side = side, outside = FALSE, 
           		at = as.Date("2010-01-01"), labels = "2010", rot = 0, 
           		text.fontface = "bold", text.alpha = .5, text.col = "darkgray", 
           		text.cex = 2 )
           				
        }, 
        axis.default(side = side, ...)
    )
}



png( "commits_per_day.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date , data = daydata, ylab = "commits / day",
    panel = function(x, y, ...){
        panel.monthlines( )
        panel.abline( h = seq( 0, 50, by = 5), lwd = .5, col = "gray" )
        panel.loess.fill( x, y, lwd = 5, col = "black", ... )
        panel.xyplot( x, y, pch = "+", ... )
        panel.abline( v = seq.Date( as.Date("2007-01-01"), as.Date("2010-09-01"), by = "month" ), lwd = .5, col = "gray" )
    } #, subset = date > as.Date("2009-10-01")
    , axis = axis.releases
    ) )    
dev.off()   

png( "commits_per_day__zoom.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date , data = daydata, ylab = "commits / day",
    panel = function(x, y, ...){
        panel.monthlines( )
        panel.abline( h = seq( 0, 50, by = 1), lwd = .5, col = "gray" )
        panel.loess.fill( x, y, lwd = 5, col = "black", ... )
        panel.xyplot( x, y, pch = "+", ... )
        panel.abline( v = seq.Date( as.Date("2007-01-01"), as.Date("2010-09-01"), by = "month" ), lwd = .5, col = "gray" )
    }, ylim = c(-1,10), subset = date > as.Date("2009-10-01"), 
    axis = axis.releases
    ) )    
dev.off()   


png( "commits_per_day_per_author.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date | author, data = day_author_data, ylab = "commits / day",
    panel = function(x, y, ...){
        panel.monthlines( )
        panel.abline( h = seq( 0, 50, by = 1), lwd = .5, col = "gray" )
        panel.abline( h = seq( 0, 50, by = 5), lwd = 1 , col = "darkgray" )
        panel.loess.fill( x, y, lwd = 5, col = "black", ... )
        panel.xyplot( x, y, pch = "+", ... )
        panel.abline( v = seq.Date( as.Date("2007-01-01"), as.Date("2010-09-01"), by = "month" ), lwd = .5, col = "gray" )
        
    }, 
    axis = axis.releases
    #,  subset = date > as.Date("2009-10-01"), layout = c(3,1), ylim = c(-1, 10 )
    ) )    
dev.off()    
 

png( "commits_per_day_per_author__zoom.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date | author, data = day_author_data, ylab = "commits / day",
    panel = function(x, y, ...){
        panel.monthlines( )
        panel.abline( h = seq( 0, 20, by = 1), lwd = .5, col = "gray" )
        panel.loess.fill( x, y, lwd = 5, col = "black", ... )
        panel.xyplot( x, y, pch = "+", ... )
        panel.abline( v = seq.Date( as.Date("2007-01-01"), as.Date("2010-09-01"), by = "month" ), lwd = .5, col = "gray" )
    }, ylim = c(-1,10),  subset = date > as.Date("2009-10-01"), layout = c(3,1)
    , axis = axis.releases )  )
dev.off()    

png( "commits_per_month.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date , data = monthdata, ylab = "commits / month",
    panel = function(x, y, ...){
        panel.monthlines() 
        panel.abline( h = seq(0,500, by = 20) , lwd = .5, col = "gray" )
        panel.abline( h = pretty(y), lwd = 1, col = "darkgray" )
        panel.loess.fill( x, y, by = "month", 
            lwd = 2, col = "black", ... )
        panel.xyplot( x, y, pch = 21, fill = "red", cex = 2, ... )
    }, axis = axis.releases ) )
dev.off()    
    
png( "commits_per_month__zoom.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date , data = monthdata, ylab = "commits / month",
    panel = function(x, y, ...){
        panel.monthlines() 
        panel.abline( h = seq(0,500, by = 20) , lwd = .5, col = "gray" )
        panel.abline( h = seq(0,500, by = 100) , lwd = 1, col = "darkgray" )
       
        xx <- seq.Date( min(x), max(x), by = "month" )
        yy <- rep( 0, length(xx) )
        yy[ xx %in% x ] <- y
        panel.lines( xx, yy )
        
       panel.xyplot( xx, yy, pch = 21, fill = "red", cex = 2, ... )
    }, axis = axis.releases,  subset = date > as.Date("2009-10-01") ) )    
dev.off()
    

png( "commits_per_month_author.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date | author, data = month_author_data, ylab = "commits / month",
    panel = function(x, y, ...){
        panel.monthlines() 
        panel.abline( h = seq(0,500, by = 20) , lwd = .5, col = "gray" )
        panel.abline( h = seq(0,500, by = 100) , lwd = 1, col = "darkgray" )
        
        xx <- seq.Date( min(x), max(x), by = "month" )
        yy <- rep( 0, length(xx) )
        yy[ xx %in% x ] <- y
        panel.lines( xx, yy )
        panel.xyplot( xx, yy, pch = 21, fill = "red", cex = 1.5, ... )
    }, axis = axis.releases
    # ,  subset = date > as.Date("2009-10-01") )
    )
)    
dev.off()

png( "commits_per_month_author__zoom.png", width = 1500, height = 500 )    
print( xyplot( commits ~ date | author, data = month_author_data, ylab = "commits / month",
    panel = function(x, y, ...){
        panel.monthlines() 
        panel.abline( h = seq(0,500, by = 20) , lwd = .5, col = "gray" )
        panel.abline( h = seq(0,500, by = 100) , lwd = 1, col = "darkgray" )
        
        xx <- seq.Date( min(x), max(x), by = "month" )
        yy <- rep( 0, length(xx) )
        yy[ xx %in% x ] <- y
        panel.lines( xx, yy )
        panel.xyplot( xx, yy, pch = 21, fill = "red", cex = 1.5, ... )
    }, axis = axis.releases,  subset = date > as.Date("2009-10-01") )
)    
dev.off()

  
