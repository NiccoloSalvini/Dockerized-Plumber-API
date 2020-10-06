source(here::here("scraping/_links.R"),echo = FALSE)
source(here::here("scraping/_complete.R"),echo = FALSE)

vec.pacchetti = c("dplyr",
                  "tibble",
                  "magrittr",
                  "rvest",
                  "tidyr",
                  "httr",
                  "stringi",
                  "lubridate",
                  "jsonlite",
                  "doParallel",
                  "stringr",
                  "here",
                  "purrr")


links = all.links()
date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
filename = paste0('shared-data/imm-',date,'.csv')
all = scrape.all.info(links = links)

cat("writing .csv file...")
write.csv(x = all, file = here::here(filename), append = T)  
