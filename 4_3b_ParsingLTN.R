# Crawling ltn
library(xml2)
options(stringsAsFactors = F)
pre <- 'http://news.ltn.com.tw' # visit the website



# Get the url of query ----------------------------------------------------
# http://news.ltn.com.tw/search
url <- 'http://news.ltn.com.tw/search?keyword=%E5%B9%B4%E9%87%91&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'

url.2ndpage <- 'http://news.ltn.com.tw/search?page=2&keyword=%E5%B9%B4%E9%87%91&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'



# Decompose the url -------------------------------------------------------


q <- "年金"
i <- 1

#  Method 1 by paste0
url <-
  paste0('http://news.ltn.com.tw/search?page=', i,
         '&keyword=', q,
         '&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
  )
url

# Method 2 by sprintf
# your turn


# Get and read the html ---------------------------------------------------
doc   <- read_html(url)



# Parse the html file to detect link --------------------------------------

# Get <a> in all <li> under <ul> with id="newslistul"
node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
class(node.a)


# Get text of all <a>
a.text <- xml_text(node.a)

# Get attribute 'href's value of all <a>
a.href <- xml_attr(node.a, 'href')

a.href
# /news/politics/breakingnews/2041678

# Observe the first link's url http://news.ltn.com.tw/news/politics/breakingnews/2041243

# Combine the pre-url and href
a.href <- paste0(pre, a.href)
a.href


# Stop condition: find the last page url ----------------------------------

# find the last page url
lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
class(xml_find_first(doc, lastpage.path))
lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
lastpage.url

# Get the page number of the last page
lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))



# For loop to get back all url --------------------------------------------
hrefs <- c()
for(i in 1: lastpage.num){
	url <-
		paste0('http://news.ltn.com.tw/search?page=', i,
			'&keyword=', q,
			'&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
		)	
	doc   <- read_html(url)
	node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
	a.href <- xml_attr(node.a, 'href')
	a.href <- paste0(pre, a.href)
	hrefs <- c(hrefs, a.href)
	print(i)
}



# A clean version of news url crawler -------------------------------------

q <- "年金"
i <- 1
url <-
	paste0('http://news.ltn.com.tw/search?page=', i,
		'&keyword=', q,
		'&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
	)
url

# Get the html file by url and transfer to xml_document
doc   <- read_html(url)

# Get the last page number
lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))


# Crawl page by page
hrefs <- c()
for(i in 1: lastpage.num){
	url <-
		paste0('http://news.ltn.com.tw/search?page=', i,
			'&keyword=', q,
			'&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
		)	
	doc   <- read_html(url)
	node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
	a.href <- xml_attr(node.a, 'href')
	a.href <- paste0(pre, a.href)
	hrefs <- c(hrefs, a.href)
	print(paste0("crawling page ", i))
}


# Formulate new query by year and month -----------------------------------

# Original url
url <- 'http://news.ltn.com.tw/search?page=2&keyword=%E5%B9%B4%E9%87%91&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'


# Decompose url by keyword, year and month

q <- "年金"
y <- 2015
m <- 1
monthvec <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

url <-paste0(
	'http://news.ltn.com.tw/search?keyword=', q,
	'&conditions=and&SYear=', y,
	'&SMonth=', m,
	'&SDay=1&EYear=', y,
	'&EMonth=', m,
	'&EDay=', monthvec[m]
)
url

# Using for-loop to get all initial query link ----------------------------



q <- "年金"
urls <- c()
for (y in 2005:2015) {
	for (m in seq(1, 11, 2)) {
		url <-
			paste0(
				'http://news.ltn.com.tw/search?keyword=', q,
				'&conditions=and&SYear=', y,
				'&SMonth=', m,
				'&SDay=1&EYear=', y,
				'&EMonth=', m+1,
				'&EDay=', monthvec[m+1]
			)
		urls <- c(urls, url)
	}
}
urls

# A testing
for(y in 2005:2010){
	for(m in 1:12){
		print(sprintf("%s-%s", y, m))
	}
}

# Get news title, date, and metadata --------------------------------------
url.test <- urls[[1]]
doc <- read_html(url.test)

# get the last page number of url.test
lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))

# Now, insert "page=%d" to url.test
pageurl <- sprintf(sub("keyword","page=%d&keyword", url.test), 1)
pageurl

# Crawl for url.test, the 1st url of urls
hrefs <- c()
for(p in 1:lastpage.num){
	pageurl <- 	sprintf(sub("keyword","page=%d&keyword", url.test), p)
	doc   <- read_html(pageurl)
	node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
	a.href <- xml_attr(node.a, 'href')
	a.href <- paste0(pre, a.href)
	hrefs <- c(hrefs, a.href)
	
}


# Crawl for url in urls ---------------------------------------------------


hrefs <- c()
for(url in urls){
	print(url)
	doc <- read_html(url)
	
	lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
	lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
	lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))
	
	for(p in 1:lastpage.num){
		pageurl <- 	sprintf(sub("keyword","page=%d&keyword", url), p)
		doc   <- read_html(pageurl)
		node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
		a.href <- xml_attr(node.a, 'href')
		a.href <- paste0(pre, a.href)
		hrefs <- c(hrefs, a.href)
		print(paste0("...get page ", p))
	}
}



# Get news content --------------------------------------------------------

hrefs[[1]]
doc <- read_html(hrefs[[1]])


# Get all article links ---------------------------------------------------




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
  
  return(tempdf)
}




# Create an empty data frame to store data --------------------------------

# result <- data.frame(
#   timestamp = character(0),
#   href = character(0),
#   title = character(0),
#   category = character(0),
#   content = character(0)
# )



# Crawl by urls -----------------------------------------------------------
library(plyr)

result <- data.frame()

for(url in urls){
  print(url)
  doc   <- read_html(url)
  lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
  lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
  if (is.na(lastpage.url)) {
    tempdf <- doc2df(doc)
    result <- rbind.fill(result, tempdf)
    next
  }
  lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))
  for (page in 1:lastpage.num) {
    pageurl <- sprintf(sub("keyword","page=%d&keyword", url), page)
    doc   <- read_html(pageurl)
    tempdf <- doc2df(doc)
    result <- rbind.fill(result, tempdf)
  }
  print(nrow(result))
}

saveRDS(result, file="ltn_index.RDS")

# Remove duplicated row ---------------------------------------------------
result <- result[!duplicated(result), ]
apply(result, 2, class)
class(result$content)


# Crawling news content ---------------------------------------------------

allhref <- unlist(result[1])
class(allhref)

textdf <- data.frame()

allhref[2529]

for (i in 2529:length(allhref)) {
	texturl <- allhref[i]
	tempvec <- unlist(strsplit(texturl, '/'))
	cat <- tempvec[5]
	id <- tempvec[7]
	doc <- read_html(texturl)
	title <- trimws(xml_text(xml_find_first(doc, '//*[@id="main"]//h1')))
	content <- trimws(xml_text(xml_find_all(doc, '//*[@id="newstext"]//p')))
	content <- paste(content, collapse = " ")
	journalist <-  sub(".*記者(.+)[／攝].*", "\\1", content)
	tempdf <- data.frame(cat, id, title, content, journalist)
	textdf <- rbind.fill(textdf, tempdf)
	print(i)
}
# 2524~2527?
# Save to RData -----------------------------------------------------------
save(result, file = "ltn_index2.RData")
load('ltn_index2.RData')
apply(result, 2, class)
class(result$content)

tdf$area <- gsub("\\s", NA, tdf$area)
result$timestamp <- gsub("\\s", "", result$timestamp)


allhref



# Appendix ----------------------------------------------------------------

# Get the last page node
lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'

# Get the last page href
lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")

# Get the last page number from the href
lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))

# Create an empty character vector for gather urls
hrefs <- c()

# for-loop from 1st page to the last page
for(i in 1: lastpage.num){
	
	# Compose url
	url <-
		paste0('http://news.ltn.com.tw/search?page=', i,
			'&keyword=', q,
			'&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
		)	
	
	# Get the html document and convert to xml_document
	doc   <- read_html(url)
	
	# Get all <a> node under ul@id="newslistul"
	node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
	
	# Get all <a>'s href values
	a.href <- xml_attr(node.a, 'href')
	
	# Compose hrefs with header
	a.href <- paste0(pre, a.href)
	
	# Add hrefs into hrefs vector
	hrefs <- c(hrefs, a.href)
	print(i)
}


lastpage.path <- '//*[@id="page"]/a[@class="p_last"]'
lastpage.url <- xml_attr(xml_find_first(doc, lastpage.path), "href")
lastpage.num <- as.numeric(sub(".*page=([0-9]+).*", "\\1", lastpage.url))

hrefs <- c()

for(i in 1: lastpage.num){
	url <-
		paste0('http://news.ltn.com.tw/search?page=', i,
			'&keyword=', q,
			'&conditions=and&SYear=2017&SMonth=1&SDay=20&EYear=2017&EMonth=4&EDay=20'
		)	
	doc   <- read_html(url)
	
	node.a <- xml_find_all(doc, '//ul[@id="newslistul"]//li/a')
	a.href <- xml_attr(node.a, 'href')
	a.href <- paste0(pre, a.href)

	hrefs <- c(hrefs, a.href)
}
ˇ


