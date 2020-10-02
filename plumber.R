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
#* @param city [chr string] the city you are interested in
#* @param npages [positive integer] number of pages to scrape (1-300) default: 10 min: 2
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /scrape
function(npages = 10,
         city = "milano",
         type = "affitto",
         res){
            if (npages > 300 || npages < 0  ){stop("npages must be numeric")}
            # if (!type %in% c("affitto", "vendita")){ stop("type has only 2 options: 'affitto' o 'vendita'")}
            # if (!identical(type,"affitto")){ stop("type has to be 'affitto")}
            list(
                        scrape.all(npages,city,type)
            )
           
}



#* Get all the links  
#* @param url [url string] the link from which you are interested to extract data default: Milan
#* @param npages [positive integer] number of pages to scrape (1-300) default: 10 min: 2
#* @get /links
function(url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
         npages = 10,
         res){
            
            if (!is_url(url)){stop("url you inputted seems not to be a proper url")}
            
            if (npages > 300 || npages < 0  ){stop("npages must be numeric")}
            
            list(
                        links = all.links(url,npages)
            )
            
}


#* Get the complete data from single links (not the raw)
#* @param url [url string] the link from which you are interested to extract data default: Milan
#* @param npages [positive integer] number of pages to scrape (1-300) default: 10 min: 2
#* @get /complete
function(url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
         npages = 10){
            
            if (!is_url(url)){stop("url you inputted seems not to be a proper url")}
            
            if (npages > 300 || npages < 0  ){stop("pts must be between 1 and 300")}
  
            links = all.links(url,npages)
            list(
                        complete = scrape.all.info(links)
                        
            )
            
}


