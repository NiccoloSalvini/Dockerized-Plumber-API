## get_daily_data
## cronjob executable for scraping
## 
## desc: the file scrapes from a predefined source
## and then stores the resulting dataframe into a NOSQL
## MongoDB database instance, whose connections

## Header End ----

## 1.0 load the LIBRARIES needed minus the plumber (in main.R) ----

vec_libs = c("tidyverse",
             "rvest",
             "tictoc", 
             "future", 
             "here",
             "robotstxt", 
             "parallel",  
             "stringi",
             "furrr",
             "glue",
             "jsonlite",
             "lubridate",
             "httr",
             "rvest",
             "magrittr",
             "tibble"
)


## Loading Packages
message("Loading Packages for crojob executable...")
invisible(lapply(vec_libs, library, character.only = TRUE))


##  check if shared directory, file and last_update date exists
print("Shared directory exists:")
print(file.exists("/job/shared_data/"))

## source the function endpoint coming from scraping shared volume 
## source get_link
## source rotating agents
source("_fastscrape2.R")
source("helpers.R")
source("agents.R")

## --> GESTIRE LE CONNESSIONI ALL'ISTANZA (mettile private)

## Parallel ----
## parallel workers initialized
workers = future::availableCores()
future::plan(multisession, workers = workers)

get_data = function(){
            npages_vec = get_link(npages = 10, 
                                  city = "miilano",
                                  type = "affitto")
            
            date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
            filename = paste0('shared-data/imm-',date,'.csv')
            all = fastscrape2(npages_vec)
            
            url_path  = "mongodb+srv://salvini:mucrini27@cluster0.qs3zp.mongodb.net/api-immobiliare?retryWrites=true&w=majority"
            db = mongo(
                        collection = "test",
                        db = "api-immobiliare",
                        url = url_path,
                        verbose = TRUE,
            )
            db$insert(all)
            
}

# run function
get_data()