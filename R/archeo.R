library(tibble)
library(rvest)
library(stringr)
library(dplyr)

old_articles <- function(time = "20150404132257", origin = c("ghost", "wp") ){
  origin <- match.arg(origin)
  link_pattern <- switch(origin, 
    ghost = "article h2 a", 
    wp    = "h2 a[rel='bookmark']"
    )
  
  url <- sprintf("https://web.archive.org/web/%s/http://blog.r-enthusiasts.com/", time)
  
  links <- read_html(url) %>% 
    html_nodes(link_pattern)
  
  titles <- links %>% html_text()
  
  link <- links %>% html_attr("href")
  if( origin == "ghost"){
    link <- paste0("https://web.archive.org", link )
  }
  
  date <- link %>% 
    str_extract("\\d{4}/\\d{2}/\\d{2}") %>% 
    str_replace_all( "/", "-")
  
  suffix <- link %>% 
    str_replace(".*/(.*)/$", "\\1")
  
  data_frame(titles, link, date, suffix, origin)
  
}

article_text <- function(url, origin) {
  node <- switch( origin, 
    ghost = ".post-content", 
    wp    = ".entry-content"
  )
  read_html(url) %>% html_nodes(node) %>% as.character
}

retrieve_article <- function(link, title, date, origin, file){
  tryCatch({
    text <- article_text( link, origin )
    
    con <- file( file, open = "w" )
    writeLines( "---", con )
    writeLines( paste("title: ", title ), con )
    writeLines( 'author: "Romain François"', con)
    writeLines( paste("date: ", date ), con )
    writeLines( 'tags: []', con )
    writeLines( "---\n", con )
    writeLines( text, con = con )
    close(con)
  })
}

articles <- bind_rows(
    old_articles("20150303173911", "ghost"),
    old_articles("20140922210338", "ghost"),
    old_articles("20140701174434", "ghost"),
    old_articles("20140531145445", "ghost"), 
    old_articles("20130607064651", "wp")
  ) %>% 
  filter( !duplicated(titles) ) %>% 
  mutate( file = sprintf("content/post/%s-%s.md", date, suffix) )


for( i in seq_len(nrow(articles))){
  cat( i, " ...\n")
  with( articles[i,], {
    retrieve_article(link, titles, date, origin, file)  
  })
}


