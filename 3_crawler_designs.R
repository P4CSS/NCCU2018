pkgs <- c("jsonlite", "httr", "dplyr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

library(httr)
library(jsonlite)
library(dplyr)



# 0. Clean code of crawling rent591 ---------------------------------------

## Getting the first chunk of data
url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text", encoding = "utf-8"))
all.df <- res1$data$data

## Detecting the page number of the last chunk
end <- as.numeric(gsub(",", "", res1$records))
endpage <- end %/% 30

## Modifying urls by page number to get all data
for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text", encoding = "utf-8"))
	all.df <- bind_rows(all.df, res$data$data) # dplyr::bind_rows()
}

length(unique(all.df$user_id))




# 1. Get the first page of rent591 ----------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
class(res1$data$data)
dim(res1$data$data);

# store res1 data to all.df
all.df <- res1$data$data



# 2. Get the 2nd page -----------------------------------------------------

# Observing the different part of the following urls
# url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
# url2 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1&firstRow=30&totalRows=2563"

# composing url2 by url1 as prefix and surfix arguments (parameters)
url2 <- paste0(url1, "&firstRow=30&totalRows=2563")
res2 <- fromJSON(content(GET(url2), "text"))
class(res2$data$data)
dim(res2$data$data)

# concatenating res2 data after all.df by row
# ?dplyr::bind_rows
all.df <- bind_rows(all.df, res2$data$data)
nrow(all.df)



# 3. Get the 3rd page data ------------------------------------------------

# url3 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1&firstRow=60&totalRows=2563"
url3 <- paste0(url1, "&firstRow=60&totalRows=2563")
res3 <- fromJSON(content(GET(url3), "text"))

# concatenating res3
all.df <- bind_rows(all.df, res3$data$data)
dim(all.df)



# 4. Review essential code above ------------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

url2 <- paste0(url1, "&firstRow=30&totalRows=2563")
res2 <- fromJSON(content(GET(url2), "text"))
all.df <- bind_rows(all.df, res2$data$data)

url3 <- paste0(url1, "&firstRow=60&totalRows=2563")
res3 <- fromJSON(content(GET(url3), "text"))
all.df <- bind_rows(all.df, res3$data$data)

url4 <- paste0(url1, "&firstRow=90&totalRows=2563")
res4 <- fromJSON(content(GET(url4), "text"))
all.df <- bind_rows(all.df, res4$data$data)




# 5. Use for(){} to do s.t. repeatedly ------------------------------------

url1 <- "https://rent.591.com.tw/home/search/rsList?is_new_list=1&type=1&kind=2&searchtype=1&region=1"
res1 <- fromJSON(content(GET(url1), "text"))
all.df <- res1$data$data

for(i in 1:3){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=2563")
	res <- fromJSON(content(GET(url), "text"))
	all.df <- rbind(all.df, res$data$data)
}



# 6. Get the last page ----------------------------------------------------

# the total records
res1$records
# [1] "2,575"

# convert character to number
end <- as.numeric(gsub(",", "", res1$records))
# calculate the number of end page
endpage <- end %/% 30


for(i in 1:endpage){
	url <- paste0(url1, "&firstRow=", i*30, "&totalRows=", end)
	res <- fromJSON(content(GET(url), "text"))
	all.df <- rbind(all.df, res$data$data)
}






# Practice01: Find the next and end ---------------------------------------

# Finding the next page and the end page of the following urls
url_pchome <- "http://ecshweb.pchome.com.tw/search/v3.3/?q=switch&scope=all"
url_dcard <- "https://www.dcard.tw/f/relationship"
url_104 <- "https://www.104.com.tw/jobs/search/?ro=0&keyword=%E8%B3%87%E6%96%99%E5%88%86%E6%9E%90&area=6001001000&order=1&asc=0&kwop=7&page=9&mode=s&jobsource=n104bank1"

