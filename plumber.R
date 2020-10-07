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
                  "here",
                  "purrr",
                  "mongolite")

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


get_link = function(city = "milano",
                    type = "affitto",
                    npages = 10,
                    .url,
                    .macrozone= c("fiera", "centro"),
                    .list = FALSE) {
            tipo = tolower(type)
            citta = tolower(city) %>% iconv(to='ASCII//TRANSLIT')
            macrozone = tolower(.macrozone) %>% iconv(to='ASCII//TRANSLIT')
            
            if(!tipo %in% c("affitto", "vendita")){stop("Affitto has to be specified")}
            # if(!identical(tipo, "affitto")){stop("Affitto has to be specified")}
            
            if(!identical(macrozone, c("fiera", "centro"))){
                        idzone = list()
                        for(i in seq_along(macrozone)){
                                    zone = fromJSON("zone.json")
                                    zone$name = zone$name %>%  tolower()
                                    if(grepl(macrozone[i], zone)[2]){
                                                pos = grepl(macrozone[i],zone$name, ignore.case = T)
                                                idzone[i] = zone[pos,] %>%  select(id)
                                    } else { 
                                                stop(paste0("zone:", macrozone[i], " is not recognized"))
                                                }
                        }
                        idzone = idzone %>%  unlist() %>%  unique()
                        mzones =  glue::glue_collapse(x = idzone, "&idMZona[]=") %>% 
                                    paste0("?idMZona[]=",.)
                        
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom,tipo,"-case/",citta,"/",mzones)
                        lista = c()
                        url = list(stringa = stringa, lista = lista)
            }
            dom = "https://www.immobiliare.it/"
            stringa = paste0(dom,tipo,"-case/",citta,"/")
            lista = c()
            url = list(stringa = stringa, lista = lista)
            if(.list == T){
                        vecurls = str_c(stringa, '?pag=', 2:npages) %>% 
                                    append(stringa, after = 0)
                        url$lista = vecurls
                        return(url)
            } else {
                        return(url)
                        }
}


source(here::here("scraping/_scrape.R"))
source(here::here("scraping/_links.R"))
source(here::here("scraping/_complete.R"))

## .csv generator
source(here::here("get_data.R"))

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
#* @get /scrape/<npages:int>/<city:chr>
function(npages = 10,
         city = "milano",
         # macrozone = c("fiera","centro"),
         type = "affitto",
         req){
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME)
            if (npages > 300 & npages > 0){
                        stop("npages must be between 1 and 1,000")
            }
            list(
                        scrape(npages, city, type) # macrozone #url
            )
           
}



#* Get all the links  
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /links/<npages:int>/<city:chr>/<type:chr>/<.thesis:bool>
function(npages = 10,
         city = "milano",
         type = "affitto",
         # url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&idMZona[]=10046&idMZona[]=10047&idMZona[]=10071&idMZona[]=10067&idMZona[]=10066",
         .thesis = F,
         req){
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME, "\n\n")
            if (npages > 300 & npages > 0){
                        stop("npages must be between 1 and 1,000")
            }
            if(.thesis){
                        list(
                                    all.links(npages,city,type, .thesis = TRUE) # url
                        )
            } else {
                        list(
                                    all.links(npages,city,type) # url
                                    )
            }
}


#* Get the complete data from single links (not the raw)
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /complete/<npages:int>/<city:chr>/<type:chr>/<.thesis:bool>
function(npages = 10,
         city = "milano",
         type = "affitto",
         .thesis = F,
         req){
            
            if (npages > 300 & npages > 0){
                        stop("npages must be between 1 and 1,000")
            }
            
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


#* Store data.csv in shared directory
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /get_data/<npages:int>/<city:chr>/<type:chr>
function(npages = 10,
         city = "milano",
         type = "affitto",
         req){
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME)
            if (npages > 300 & npages > 0){
                        stop("npages must be between 1 and 1,000")
            }
            
            list(
                        get_data(npages, city, type)
            )
}


