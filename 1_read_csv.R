# 1. Read CSV from the web ------------------------------------------------

library(httr)
options(stringsAsFactors = F)

url <- "http://data.taipei/opendata/datalist/datasetMeta/download?id=68785231-d6c5-47a1-b001-77eec70bec02&rid=34a4a431-f04d-474a-8e72-8d3f586db3df"
df <- read.csv(url, fileEncoding = "big5")
str(df)



# 2. substr() to get timestamp --------------------------------------------

df$time <- substr(df$發生時段, 1, 2)

# substr() to get regions
df$region <- substr(df$發生.現.地點, 4, 5)



# 3. tapply() to summarize data -------------------------------------------

tapply(df$編號, df$time, length)
tapply(df$編號, df$region, length)


# 3.1 summarized by two variables -----------------------------------------
res <- tapply(df$編號, list(df$time, df$region), length)
class(res)
View(res)




# 4. mosaicplot() to visualize two categorical variables ------------------

par(family=('Heiti TC Light')) # Chinese font-family for Mac
# par(family=('STKaiti')) # Chinese font-family for Win

# Setting the color by yourself.
mosaicplot(res, color = T, border=0, off = 3,
		   main="Theft rate of Taipei city (region by hour)")





# Practice01. -------------------------------------------------------------

# Does it possible to extract month  by substr()?
# (you may need to search how to extract the last n characters in R)
x <- df$發生.現.日期
df$month <- x # modify this line
res2 <- tapply(df$編號, list(df$month, df$region), length)
res2 <- tapply(df$編號, list(df$region, df$month), length)
mosaicplot(res2, color=colors, border=0, off = 3, main="Theft rate of Taipei city (region by hour)")
