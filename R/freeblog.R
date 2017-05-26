library(httr)
library(rvest)
library(purrr)
library(stringr)
library(dplyr)

get_links <- function(page = 1){
  url <- paste0("http://romainfrancois.blog.free.fr/index.php?/page/", page)  
  url %>% 
    read_html() %>% 
    html_nodes( ".post-title a" ) %>% 
    html_attr("href") %>% 
    str_replace("^.*[?]post/", "") %>% 
    data_frame(url=.) %>% 
    separate( url, into = c("year", "month", "day", "slug" ), sep =  "/", extra = "merge", remove = FALSE)
}
links <- bind_rows( map(1:7, get_links) )

download_post <- function(url){
  prefix <- "http://romainfrancois.blog.free.fr/index.php?post/"
  url <- paste0(prefix, url)
  html <- read_html(url)
  title <- html %>% 
    html_node("h2.post-title") %>% 
    html_text()
  
  tags <- html %>% 
    html_nodes("ul.post-tags li a") %>% 
    html_text()
  
  content <- html %>% 
    html_node("div.post-content") %>% 
    as.character()
  
  imgs <- html %>% 
    html_nodes("div.post-content img") %>% 
    html_attr("src")
  
  iframes <- html %>% 
    html_nodes("div.post-content iframe") %>% 
    html_attr("src")
  
  data_frame( 
    title = title, 
    tags = list(tags), 
    content = content, 
    imgs = list(imgs), 
    iframes = list(iframes)
  )
}

data <- links$url %>% 
  map(download_post) %>% 
  bind_rows() %>% 
  bind_cols( links )

imgs <- unlist(data$imgs) %>% 
  str_subset( "^/public" ) %>% 
  str_replace( "^/", "")
  unique

directories <- sort( unique( dirname(imgs) ) )

file.path( "static", directories) %>% 
  walk( dir.create, recursive = TRUE, showWarnings = FALSE)

download.file(
  paste0( "http://romainfrancois.blog.free.fr/", imgs ), 
  file.path( "static", imgs)
)

iframes <- unique(unlist(data$iframes)) %>% 
  str_subset( "^/public" )

directories <- sort( unique( dirname(iframes) ) )
file.path( "static", directories) %>% 
  walk( dir.create, recursive = TRUE, showWarnings = FALSE)

download.file( 
  paste0( "http://romainfrancois.blog.free.fr/", iframes ), 
  file.path( "static", iframes)
  )

data$slug <- data$slug %>% str_replace_all( "[%].{2}", "-")
data$title <- data$title %>% str_replace_all( "[#:]", "-" )

for(i in seq_len(nrow(data))){
  slug <- data$slug[i]
  title <- data$title[i]
  
  year <- data$year[i]
  month <- data$month[i]
  day <- data$day[i]
  content <- data$content[i]
  tags <- data$tags[[i]]
  
  cat( slug, "\n" )
  
  md <- file.path( "content",  "blog", paste0(year, "-", month, "-", day, "-", slug, ".md") )
  file <- file( md, open = "w" )
  writeLines( "---", file )
  writeLines( paste( "title:  ", title ), file )
  writeLines( 'author: "Romain François"', file )
  writeLines( sprintf( "date:  %s-%s-%s", year, month, day), file )
  writeLines( sprintf( "slug:  %s", slug), file )
  if( length(tags) ){
    writeLines( sprintf( "tags:  [ %s ]", paste( '"', tags, '"', collapse = ", ", sep = "" ) ), file )
  }
    
  writeLines( "---", file)
  
  writeLines( content, file )
  close(file)
}



