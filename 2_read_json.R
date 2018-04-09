

# 0. Loading packages -----------------------------------------------------

pkgs <- c("jsonlite", "httr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
options(stringsAsFactors = F)
options(fileEncoding = "utf-8")


# 1. GET and parse JSON ---------------------------------------------------
# Air-Quaility-Index (AQI) is an well-formatted json,
# Well-formatted json: a [] contains {} pairs
# fromJSON() converts text to a data.frame
# jsonlite::fromJSON converts JSON to R objects(a list or a data.frame)

url <- "http://opendata.epa.gov.tw/ws/Data/REWIQA/?$orderby=SiteName&$skip=0&$top=1000&format=json"
df <- fromJSON(content(GET(url), "text", encoding = "utf-8"))
str(df)


# 1.1 GET() to request and obtain the response ----------------------------
response <- GET(url)
class(response)
??httr::GET


# 1.2 httr::content() Extract content from a request ----------------------
text <- content(response, "text")
class(text)
??httr::content


# 1.3 jsonlite::fromJSON() ------------------------------------------------
# convert between JSON data and R objects.
df.test <- fromJSON(text)
?fromJSON
# https://www.r-bloggers.com/dealing-with-a-byte-order-mark-bom/




# Practice01 --------------------------------------------------------------
# Read json by following urls

url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
url_dcard <- "https://www.dcard.tw/_api/forums/girl/posts?popular=true"
url_pchome <- "http://ecshweb.pchome.com.tw/search/v3.3/all/results?q=X100F&page=1&sort=rnk/dc"
url_104 <- "https://www.104.com.tw/jobs/search/list?ro=0&keyword=%E8%B3%87%E6%96%99%E5%88%86%E6%9E%90&area=6001001000&order=1&asc=0&kwop=7&page=2&mode=s&jobsource=n104bank1"
url_ubike <- "http://data.taipei/youbike"

res <- fromJSON(content(GET(url_104), "text", encoding = "utf-8"))


# 2. Well-formatted but hierarchical --------------------------------------

url_rent591 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res <- fromJSON(content(GET(url_rent591), "text", encoding = "utf-8"))

# Access the right level of nodes
View(res$data$data)


# (option) Get and write to disck
response <- GET(url_rent591, write_disk("data/rent591_original.json", overwrite=TRUE))
