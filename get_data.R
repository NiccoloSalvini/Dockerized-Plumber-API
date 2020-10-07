source(here::here("scraping/_scrape.R"),echo = FALSE)

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
                  "purrr", 
                  "mongolite")

get_data = function(npages = 10, city = "milano", type = "affitto", append = T) {
            date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
            filename = paste0('shared-data/imm-',date,'.csv')
            all = scrape(npages, city, type) %>%  jsonlite::toJSON()
            cat("writing .csv file...")
            write.csv(x = all, file = here::here(filename), append = append)
            cat("\n Written file into shared-data directory")
            cat("\n Does the file exists? ", file.exists(here::here(filename)), "\n")
            
}

