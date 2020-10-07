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

invisible(lapply(vec.pacchetti, library, character.only = TRUE))


get_data = function(npages = 10, city = "milano", type = "affitto", append = T) {
            date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
            filename = paste0('shared-data/imm-',date,'.csv')
            all = scrape(npages, city, type)
            
            url_path  = "mongodb+srv://salvini:mucrini27@cluster0.qs3zp.mongodb.net/api-immobiliare?retryWrites=true&w=majority"
            db = mongo(
                        collection = "test",
                        db = "api-immobiliare",
                        url = url_path,
                        verbose = TRUE,
            )
            db$insert(all)
            
}

