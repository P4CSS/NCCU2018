### Slide: https://docs.google.com/presentation/d/e/2PACX-1vSGeNG6BcEUNjhZjqo1obJ9bijuMjKJ0WhEva29-AuishNv779rSC0nDShfkR5HcWp4EdlRUBaaiG0M/pub?start=false&loop=false&delayms=3000
# Crawling ltn
library(xml2)
library(httr)


options(stringsAsFactors = F)
pre <- 'http://news.ltn.com.tw'




# Get the initial index page url -------------------------------------------------
q <- "食安"
i <- 1
url <-
  paste0('http://news.ltn.com.tw/search?page=', i,
         '&keyword=', q,
         '&conditions=and&SYear=2016&SMonth=9&SDay=2&EYear=2016&EMonth=10&EDay=1'
  )
url



# Get all article links ---------------------------------------------------
monthvec <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)



# Defining function to retrieve page data ---------------------------------

doc2df <- function(doc){
  href <- xml_attr(xml_find_all(doc, '//*[@id="newslistul"]//li/a'), "href")
  content <- xml_text(xml_find_all(doc, '//*[@id="newslistul"]//li/div'))
  category <- xml_attr(xml_find_all(doc, '//*[@id="newslistul"]//li/img'), "src")
  category <- as.numeric(sub(".*tab([0-9]+).*", "\\1", category))
  title <- xml_text(xml_find_all(doc, '//*[@id="newslistul"]//li/a'))
  timestamp <- xml_text(xml_find_all(doc, '//*[@id="newslistul"]//li/span'))
  href <- paste0(pre, href)
  tryCatch({tempdf <- data.frame(href, content, category, title, timestamp)}, 
           error = function(err){
             print(href)
           })
  
  tempdf
}


# Query by different duration ---------------------------------------------

for(y in c(2005:2010)){
  for(m in c(1:12)){
    print(sprintf("%s-%s", y, m))
  }
}

a <- "123"
b <- "4565"
paste0(a, b)


urls <- c()
for (y in c(2005:2015)) {
  for (m in c(1:12)) {
    url <-
      paste0(
        'http://news.ltn.com.tw/search?keyword=', q,
        '&conditions=and&SYear=', y,
        '&SMonth=', m,
        '&SDay=1&EYear=', y,
        '&EMonth=', m,
        '&EDay=', monthvec[m]
      )
    urls <- c(urls, url)
  }
}
urls


# Create an empty data frame to store data --------------------------------

result <- data.frame(
  timestamp = character(0),
  href = character(0),
  title = character(0),
  category = character(0),
  content = character(0)
)



# Crawl by urls -----------------------------------------------------------

for(url in urls){
  print(url)
  doc   <- read_html(url)
  lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
  lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
  if (is.na(lastpage.url)) {
    tempdf <- doc2df(doc)
    result <- rbind(result, tempdf)
    next
  }
  lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))
  for (page in c(1:lastpage.num)) {
    pageurl <- sprintf(sub("keyword","page=%d&keyword", url), page)
    doc   <- read_html(pageurl)
    tempdf <- doc2df(doc)
    result <- rbind(result, tempdf)
  }
  print(nrow(result))
}



# Remove duplicated row ---------------------------------------------------
result <- result[!duplicated(result), ]
apply(result, 2, class)
class(result$content)



# Save to RData -----------------------------------------------------------
save(result, file = "ltn_index2.RData")
load('ltn_index2.RData')
apply(result, 2, class)
class(result$content)

tdf$area <- gsub("\\s", NA, tdf$area)
result$timestamp <- gsub("\\s", "", result$timestamp)


allhref
