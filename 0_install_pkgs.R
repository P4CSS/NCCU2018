browseURL("https://drive.google.com/open?id=1t54qpJ1GmeY_NAoMAXqIYQ9xmjPxZr1u")


# Install and import essential packages -----------------------------------



# install.packages("tidyverse")
# library(tidyverse) will import ggplot2, dplyr, tidyr, readr, purrr, and tibble
# Need to library
# readxl	for .xls and .xlsx sheets.
# haven 	for SPSS, Stata, and SAS data.
# jsonlite 	for JSON.
# xml2 		for XML.
# httr 		for web APIs.
# rvest 	for web scraping.
# stringr 	for strings.
# lubridate	for dates and date-times.
# forcats	for categorical variables (factors).
# hms		for time-of-day values.
# blob		for storing blob (binary) data.

# packages for lecture hand-in-hand R
pkgs <- c("tidyverse", "ggmap", "twitteR", "tidytext",
          "tm", "wordcloud", "igraph", "tidyr", "readr",
          "RColorBrewer", "jsonlite", "ggmap", "ggplot2")

# excluded packages not in the computer
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

# 0. Inconsisdent encoding of RStudio -------------------------------------

# Sys.setlocale(category = "LC_ALL", locale = "UTF-8")
# Sys.setlocale(category = "LC_ALL", locale = "C")
# Sys.setlocale(category = "LC_ALL", locale = "cht") # for win
# http://psmethods.postach.io/post/ru-he-geng-gai-rde-yu-she-yu-xi
# The locale describes aspects of the internationalization of a program. Initially most aspects of the locale of R are set to "C" (which is the default for the C language and reflects North-American usage)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/locales.html


