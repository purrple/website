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
    html_nodes("div.post-content iframe")
  
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
  bind_rows()

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



