## Plumber API 
## Scraping data from immobiliare.it
## 
## desc: these functions are designed to scrape immobiliare.it 
## website and to extract meaningful information for real estate RENTAL 
## market. On top an API is built

## Header End ----

## 1.0 load the LIBRARIES needed plus the plumber ----

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
                  "here")

invisible(lapply(vec.pacchetti, library, character.only = TRUE))


print("Shared directory exists:")
print(dir.exists("shared-data/"))


print("scraping dir exists:")
print(dir.exists("scraping/"))


## 2.0 MAIN FUNCTIONS ----

## some useful handlers

is_url = function(url){
            re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
            grepl(re, url)
}

source(here::here("scraping/_scrape.R"))
source(here::here("scraping/_links.R"))
source(here::here("scraping/_complete.R"))



## 3.0 REST API ENDPOINT  ----
# define APIs

#* @apiTitle immobiliare.it data
#* @apiDescription GET extensive data from immobiliare.it Real Estate Rental
#* @apiVersion 0.0.1


#* Print to log
#* @filter logger
logger = function(req){
            
            cat("\n", as.character(Sys.time()), 
                "\n", req$REQUEST_METHOD, req$PATH_INFO, 
                "\n", req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR)
            
            # Forward the request
            plumber::forward()
            
}


#* Get fast raw data (5 covariates: title, price, num of rooms, sqmeter, primarykey)
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /scrape
function(npages = 10,
         city = "milano",
         type = "affitto",
         req){
            print(req$QUERY_STRING)
            if (npages > 300 || npages < 0  ){stop("npages must be numeric")}
            # if (!type %in% c("affitto", "vendita")){ stop("type has only 2 options: 'affitto' o 'vendita'")}
            # if (!identical(type,"affitto")){ stop("type has to be 'affitto")}
            list(
                        scrape(npages,city,type)
            )
           
}



#* Get all the links  
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /links
function(npages = 10,
         city = "milano",
         type = "affitto",
         .thesis = F,
         res){
            if (npages > 300 || npages < 0  ){stop("npages must be numeric")}
            if(.thesis){
                        list(
                                    all.links(npages,city,type, .thesis = TRUE)
                        )
            } else {
                        list(
                                    all.links(npages,city,type)
                                    )
            }
}


#* Get the complete data from single links (not the raw)
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /complete
function(npages = 10,
         city = "milano",
         type = "affitto",
         .thesis = F,
         res){
            
            if (npages > 300 || npages < 0  ){stop("pts must be between 1 and 300")}
            
            if(.thesis){
                        links = all.links(npages, city, type, .thesis = TRUE)
                        list(
                                    complete(links)
                                    
                        )
            } else {
                        links = all.links(npages,city,type)
                        list(
                                    complete(links)
                        )
            }
            
}


