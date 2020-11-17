## Plumber API 
## Scraping data from immobiliare.it
## 
## desc: these functions are designed to scrape immobiliare.it 
## website and to extract meaningful information for real estate 
## market. 

## Header End ----

## 1.0 load the LIBRARIES needed minus the plumber (in main.R) ----

vec_libs = c("dplyr",
             "tibble",
             "magrittr",
             "tictoc", ## newlib
             "future", ## newlib
             "here", ## newlib
             "rvest",
             "tidyr",
             "httr",
             "parallel", ## newlib al posto di doParallel
             "stringi",
             "furrr", ## new lib 
             "lubridate",
             "logger", ## newlib
             "jsonlite",
             "doParallel",
             "stringr",
             "glue",  ## newlib
             "purrr",
             "mongolite")


## Loading Packages
message("Loading Packages...")
invisible(lapply(vec.pacchetti, library, character.only = TRUE))

## 2.0 Source Helpers (UTILS), Scraping functions and logging (not yet)  ----
## utils helpers
source(here::here("helpers.R"))
sourceEntireFolder(here::here("scraping","functions_fastscrape"))
sourceEntireFolder(here::here("scraping","functions_completescrape"))
# ## append log info
# log_dir = "logs"
# if (!fs::dir_exists(log_dir)) fs::dir_create(log_dir)
# log_appender(appender_tee(tempfile("plumber_", log_dir, ".log")))

## three endpoints 
message("Sourcing endpoints functions...")
source(here::here("scraping","_fastscrape.R"))
source(here::here("scraping","_completescrape.R"))

## .csv generator --> connected with MongoDB ATLAS          
source(here::here("get_data.R"))

## 3.0 REST API ENDPOINT  ----
# define APIs endpoints

#* @apiTitle immobiliare.it data
#* @apiDescription GET real-time data from immobiliare.it Real Estate Rental market
#* @apiVersion 1.0.0
#* @apiLicense list(name = "Apache 2.0", url = "https://www.apache.org/licenses/LICENSE-2.0.html")


#* Log information
#* @filter logger
function(req){
            cat(as.character(Sys.time()), "-",
                req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
            plumber::forward()
}

#* User
#* @filter setuser
function(req){
            user = req$cookies$user
            # Make req$username available to endpoints
            req$username = user
            plumber::forward()
}


#* Get FAST data (6 predictors: title, price, num of rooms, sqmeter, primarykey )
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @param thesis [boolean] TRUE for data used in thesis analysis
#* @get /fastscrape/<npages:int>/<city:chr>/<type:chr>/<thesis:bool>
function(npages = 10,
         city = "milano",
         macrozone = c("fiera", "centro"),
         type = "affitto",
         thesis = FALSE,
         req,
         res){
            ## print port served and server name
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME,"\n")
            
            ## Anti DoSsing 
            if (npages > 300 & npages > 0){
                        msg = "npages has to stay between 1 and 300"
                        res$status = 500 # Bad request
                        stop(list(error=jsonlite::unbox(msg)))     
            }
            
            ## sanitize input 
            tipo = tolower(type) %>% str_trim()
            citta = tolower(city) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
            
            ## url composition reverse engineering NOT ELEGANT
            if(!missing("macrozone")){
                        macrozone = tolower(macrozone) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
                        idzone = list()
                        zone = fromJSON(here::here("ALLzone.json"))
                        for(i in seq_along(macrozone)){
                                    zone$name = zone$name %>%  tolower()
                                    if(grepl(macrozone[i], zone)[2]){
                                                pos = grepl(macrozone[i],zone$name, ignore.case = T)
                                                idzone[i] = zone[pos,] %>%  select(id)
                                    } else {
                                                stop(paste0("zone:", macrozone[i], " is not recognized"))}
                        }
                        idzone = idzone %>%  unlist() %>%  unique()
                        mzones =  glue::glue_collapse(x = idzone, "&idMZona[]=")
                        
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/?", mzones) 
                        npages_vec = str_c(stringa, '&pag=', 2:npages) %>% 
                                    append(stringa, after = 0) 
                        
            } else {
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/") # mzones
                        npages_vec = glue("{stringa}?pag={2:npages}") %>%
                                    append(stringa, after = 0)  
                        
            }
            
            if(thesis){
                        fix_url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069"
                        npages_vec = glue("{fix_url}?pag={2:npages}") %>%
                                    append(fix_url, after = 0)
                        cat(npages_vec[2])
            }
            
            cat("Query url sent:",npages_vec[2],"\n")
            
            ## endpoint scraping execution
            list(scrape(npages_vec))
           
}


#* Get the complete set of covariates data from each single adv
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @param thesis [boolean] TRUE for data used in thesis analysis
#* @get /completescrape/<npages:int>/<city:chr>/<type:chr>/<thesis:bool>
function(npages = 10,
         city = "milano",
         macrozone = c("fiera", "centro"),
         type = "affitto",
         thesis = F,
         req,
         res){
            ## print port served and server name
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME,"\n")
            
            ## Anti DoSsing 
            if (npages > 300 & npages > 0){
                        msg = "npages has to stay between 1 and 300"
                        res$status = 500 # Bad request
                        stop(list(error=jsonlite::unbox(msg)))     
            }
            
            
            ## sanitize input 
            tipo = tolower(type) %>% str_trim()
            citta = tolower(city) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
            
            ## url composition reverse engineering NOT ELEGANT
            if(!missing("macrozone")){
                        macrozone = tolower(macrozone) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
                        idzone = list()
                        zone = fromJSON(here::here("ALLzone.json"))
                        for(i in seq_along(macrozone)){
                                    zone$name = zone$name %>%  tolower()
                                    if(grepl(macrozone[i], zone)[2]){
                                                pos = grepl(macrozone[i],zone$name, ignore.case = T)
                                                idzone[i] = zone[pos,] %>%  select(id)
                                    } else {
                                                stop(paste0("zone:", macrozone[i], " is not recognized"))}
                        }
                        idzone = idzone %>%  unlist() %>%  unique()
                        mzones =  glue::glue_collapse(x = idzone, "&idMZona[]=")
                        
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/?", mzones) 
                        npages_vec = str_c(stringa, '&pag=', 2:npages) %>% 
                                    append(stringa, after = 0) 
                        
            } else {
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/") # mzones
                        npages_vec = glue("{stringa}?pag={2:npages}") %>%
                                    append(stringa, after = 0)  
                        
            }
            
            if(thesis){
                        fix_url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069"
                        npages_vec = glue("{fix_url}?pag={2:npages}") %>%
                                    append(fix_url, after = 0)
                        cat(npages_vec[2])
            }
            
            cat("Query url sent:",npages_vec[2],"\n")
            ## get links 
            links =  future_map(npages_vec, possibly( ~{
                        sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        scrapehref_imm(session = sesh) },NA_character_, quiet = FALSE)) %>%  flatten_chr()
            list(complete(links))
            
}


#* Store data.csv in shared directory
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @get /get_data/<npages:int>/<city:chr>/<type:chr>
function(npages = 10,
         city = "milano",
         type = "affitto",
         req,
         res){
            cat("\n\n port:" ,req$SERVER_PORT,
                "\n server_name:",req$SERVER_NAME)
            if (npages > 300 & npages > 0){
                        msg <- "npages must be between 1 and 1,000"
                        res$status <- 500 # Bad request
                        list(error=jsonlite::unbox(msg))
            }
            
            list(
                        get_data(npages, city, type)
            )
}
