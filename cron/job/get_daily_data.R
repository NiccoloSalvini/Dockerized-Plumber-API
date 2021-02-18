## get_daily_data
## cronjob executable for scraping
## 
## desc: the file scrapes from a predefined source
## and then stores the resulting dataframe into a NOSQL
## MongoDB database instance, whose connections

## Header End ----

## 1.0 load the LIBRARIES needed minus the plumber (in main.R) ----

vec_libs = c(
            "tidyverse",
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
             "tibble",
             "DBI", 
             "dbplyr",
             "RPostgres"
)


## Loading Packages
message("Loading Packages for crojob task...")
invisible(lapply(vec_libs, library, character.only = TRUE))

## source the function endpoint coming from scraping shared volume 
## source get_link
## source rotating agents
print("Loading endpoint functions to complete task...")
source("_fastscrape2.R")
source("helpers.R")
source("agents.R")

## Parallel ----
## parallel workers initialized
workers = future::availableCores()
future::plan(multisession, workers = workers)


## 2.0 Postegres Connection
## estalish a connection with the DB

dbConnect(
            
            drv = Postgres(),
            host = "localhost",
            port = 5432, 
            user = Sys.getenv("POSTGRES_USER"),
            password = Sys.getenv("POSTGRES_PASSWORD"),
            dbname = Sys.getenv("POSTGRES_DB")
)

## get_data
## extracts (daily data) from the same city

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