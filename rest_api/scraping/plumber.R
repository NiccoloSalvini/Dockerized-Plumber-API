## Plumber API 
## Scraping data from immobiliare.it
## 
## desc: these functions are designed to scrape immobiliare.it 
## website and to extract meaningful information for real estate 
## market. 

## Header End ----

## 1.0 load the LIBRARIES needed minus the plumber (in main.R) ----

# vec_libs = c("tidyverse",
#              "rvest",
#              "tictoc", 
#              "future", 
#              "here",
#              "robotstxt", 
#              "parallel",  
#              "stringi",
#              "furrr",
#              "glue",
#              "jsonlite",
#              "lubridate",
#              "httr",
#              "magrittr",
#              "tibble"
#              )
# 
# 
# 
# ## Loading Packages
# message("Loading Packages...")
# suppressMessages(invisible(lapply(vec_libs, library, character.only = TRUE)))

library(tidyverse, warn.conflicts = F) 
library(rvest, warn.conflicts = F) 
library(tictoc, warn.conflicts = F) 
library(future, warn.conflicts = F) 
library(here, warn.conflicts = F) 
library(stringi, warn.conflicts = F) 
library(tidyjson, warn.conflicts = F) 
library(furrr, warn.conflicts = F) 
library(glue, warn.conflicts = F) 
library(jsonlite, warn.conflicts = F) 
library(httr, warn.conflicts = F) 
library(magrittr, warn.conflicts = F) 
library(robotstxt, warn.conflicts = F)
library(tibble, warn.conflicts = F) 

#              
# "dplyr", # tidyverse --           
# "tibble", # tidyverse 
# "magrittr", # tidyverse 
# "rvest",# tidyverse 
# "tidyr",# tidyverse --- 
# "httr",# tidyverse
# "lubridate",# tidyverse 
# "jsonlite",# tidyverse 
# "stringr",# tidyverse ---
# "glue",# tidyverse
# "purrr"# tidyverse) ---
# 
# ## Loading Packages
# message("Loading Packages...")
# suppressMessages(invisible(lapply(vec_libs, library, character.only = TRUE)))

## 2.0 Source Helpers (UTILS), Scraping functions and logging (not yet)  ----
## utils helpers
source("helpers.R")
source("agents.R")
sourceEntireFolder("functions_fastscrape")
sourceEntireFolder("functions_completescrape")

# ## append log info
# log_dir = "logs"
# if (!fs::dir_exists(log_dir)) fs::dir_create(log_dir)
# log_appender(appender_tee(tempfile("plumber_", log_dir, ".log")))

## three endpoints 
message("Sourcing endpoints functions...")
# source(here::here("rest_api","scraping","_fastscrape.R"))
# source("_fastscrape2.R")
source("_fastscrape2.R")
# source("rest_api","scraping","_completescrape.R")
# source(("rest_api","scraping","_completescrape2.R")
source("_completescrape3.R")
## .csv generator --> connected with MongoDB ATLAS          
# source(here::here("shared_data","get_data.R"))

## 3.0 REST API ENDPOINT  ----
# define APIs endpoints

#* @apiTitle immobiliare.it data
#* @apiDescription GET real-time data from immobiliare.it Real Estate Rental market
#* @apiVersion 3.0.0
#* @apiLicense list(name = "Apache 2.0", url = "https://www.apache.org/licenses/LICENSE-2.0.html")



# 
# #* Log information
# #* @filter logger
# function(req){
#             cat(as.character(Sys.time()), "-",
#                 req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
#             plumber::forward()
# }
# # 
# #* User
# #* @filter setuser
# function(req){
#             user = req$cookies$user
#             # Make req$username available to endpoints
#             req$username = user
#             plumber::forward()
# }

workers = availableCores()
future::plan(multisession, workers = workers)

#* Get FAST data (6 predictors: title, price, num of rooms, sqmeter, primarykey )
#* @param city [chr string] the city you are interested to extract data (lowercase without accent)
#* @param npages [positive integer] default = 10, min  = 2, max = 300
#* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
#* @param thesis [boolean] TRUE for data used in thesis analysis
#* @param fixed_url [chr string] supply the target scraping url
#* @get /fastscrape/<npages:int>/<city:chr>/<type:chr>/<thesis:bool>
function(npages = 10,
         city = "milano",
         macrozone = c("fiera", "city life"),
         type = "affitto",
         thesis = FALSE,
         fixed_url = NA_character_,
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
            
            npages_vec = get_link(npages, city, macrozone, type)
            
            if(thesis){
                        fix_url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069"
                        npages_vec = glue("{fix_url}?pag={2:npages}") %>%
                                    append(fix_url, after = 0)
                        cat(npages_vec[2])
            }
            
            if(!missing(fixed_url)){
                        if (is_url(fixed_url)){
                                    npages_vec = glue("{fixed_url}?pag={2:npages}") %>%
                                                append(fixed_url, after = 0)
                        }
            }
            
            cat("Query url sent:",npages_vec[2],"\n")
            dplyr::if_else(paths_allowed(first(npages_vec)), "path is allowed", "path is not allowed according to robotxt")
            
            ## open parallel backend            
            
            ## tries to differentiate on future::lticore()
            ## orr with the .Platform$OS.type == "windows"
            ## unix needs multicore for forking
            list(fastscrape2(npages_vec))
            # plan(sequential)
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
            
            npages_vec = get_link(npages, city, macrozone, type)
                        
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
            
            
            list(completescrape3(links))
            # plan(sequential)
}




# #* @plumber
# function(pr) {
#             pr %>%
#                         pr_hook("postroute", function(req, value) { 
#                                     str(list(
#                                                 type = req$REQUEST_METHOD,
#                                                 path = req$PATH_INFO, 
#                                                 value = value
#                                     ))
#                                     # pass value through
#                                     value
#                         })
# }


# 
# #* Store data.csv in shared directory
# #* @param city [chr string] the city you are interested to extract data (lowercase without accent)
# #* @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
# #* @param type [chr string] affitto = rents, vendita  = sell (vendita no available for now)
# #* @param thesis [boolean] TRUE for data used in thesis analysis
# #* @get /get_data/<npages:int>/<city:chr>/<type:chr>/<thesis:bool>
# function(npages = 10,
#          city = "milano",
#          macrozone = c("fiera", "centro"),
#          type = "affitto",
#          thesis = F,
#          append = TRUE,
#          req,
#          res){
#             cat("\n\n port:" ,req$SERVER_PORT,
#                 "\n server_name:",req$SERVER_NAME)
#             
#             if (npages > 300 & npages > 0){
#                         msg <- "npages must be between 1 and 1,000"
#                         res$status <- 500 # Bad request
#                         list(error=jsonlite::unbox(msg))
#             }
#             npages_vec = get_link(npages, city, macrozone, type)
#             cat("Query url sent:",npages_vec[2],"\n")
#             
#             ## get links
#             links =  future_map(npages_vec, possibly( ~{
#                         sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
#                         scrapehref_imm(session = sesh) },NA_character_, quiet = FALSE)) %>%  flatten_chr()
#             
#             list(
#                         get_data(links)
#             )
# }
# 
# 
# 
# ## close parallel back end
# ## 
# # future::plan(sequential)
