library(pdftools)
library(glue)

url <- "https://speakerd.s3.amazonaws.com/presentations/d458a2e75d544c70a1a344b7bb3aec73/rap_rladies.pdf"
tf <- tempfile()
download.file(url, destfile = tf)

target_dir <- "static/img/rap-rladies"

npages <- pdf_info(tf)$pages
filenames <- sprintf("slide-%0d.png", seq_len(npages))
img_files <- file.path(target_dir, filenames)
pdf_convert(tf, format = "png", filenames = img_files)

glue('<img src="/img/rap-rladies/{filenames}" class="slide"/> \n\nlorem ipsum .... \n\n') %>% 
  write_clip()
