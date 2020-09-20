## Plumber API 
## Scraping data from immobiliare.it
## 
## desc: these functions are designed to scrape immobiliare.it 
## website and to extract meaningful information for real estate RENTAL 
## market. On top an API is built

## Header End ----

## 1.0 load the LIBRARIES needed plus the plumber ----

library(plumber)

library(dplyr) #t
library(tibble) #t
library(magrittr)
library(rvest)
library(tidyr) #t
library(httr)
library(stringi)
library(lubridate)
library(jsonlite)
library(doParallel)
library(stringr) #t

lista.pacchetti = c("dplyr",
                    "tibble",
                    "magrittr",
                    "rvest",
                    "tidyr",
                    "httr",
                    "stringi",
                    "lubridate",
                    "jsonlite",
                    "doParallel",
                    "stringr")




## 2.0 MAIN FUNCTIONS ----


## [ scrape.all ] ----
## it scrapes all the available information in the grouping section

scrape.all = function(url =  "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
                      npages = 10){
            ## url is precomposed by my choices
            ## build the array url
            list.of.pages.imm = str_c(url, '&pag=', 2:npages) %>% 
                        append(url, after = 0)
            
            cl = makeCluster(detectCores()-1)
            registerDoParallel(cl)
            result = foreach(i = seq_along(list.of.pages.imm),
                             .packages = lista.pacchetti,
                             .combine = "bind_rows",
                             .multicombine = TRUE,
                             .verbose = FALSE,
                             .errorhandling='pass') %dopar% {
                                         
                                         ## Utils start----
                                         
                                         agents =  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                     'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                     'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                     'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
                                                     'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                     'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                     'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                     'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                     'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                                                     'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
                                         

                                         ## [ add other Headers ] ----
                                         
                                         
                                         mails = c('heurtee@triderprez.cf',
                                                   'nonliqui@famalsa.tk',
                                                   'bemerker@vagenland.gq',
                                                   'deutoplasm@c032bjik.buzz',
                                                   'controllably@mirider.ga')
                                         
                          
                                         len = function(x){
                                                     length(x) %>% 
                                                                 print()
                                         }
                                         
                                         
                                         ## [ set default bind_rows ] ----
                                         
                                         
                                         bind_rows = dplyr::bind_rows
                                         
                                         
                                         
                                         ## [ test if valid URL] ----
                                         
                                         is_url = function(url){
                                                     re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
                                                     grepl(re, url)
                                         }
                                         
                                         
                                         
                                         ##  [ test User agent ] ----
                                         
                                         get_ua = function(sess) {
                                                     stopifnot(is.session(sess))
                                                     stopifnot(is_url(sess$url))
                                                     ua = sess$response$request$options$useragent
                                                     return(ua)
                                         }
                                         
                                         
                                         
                                         ## [ sleep fucntion to simulate request delay  ] ----
                                         
                                         dormi = function() {
                                                     Sys.sleep(sample(seq(1, 2, by=0.001), 1))
                                         }
                                         
                                         ##  end utils ---
                                         
                                         
                                         
                                         
                                         ##  START FUNCTIONS_URL ----
                                         
                                         
                                         scrapehref.imm = function(session){
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.text-primary a') %>% 
                                                                 html_attr('href') %>%
                                                                 as.character()
                                                     return(web)
                                         }
                                         
                                         
                                         scrapeprice.imm = function(session){
                                                     
                                                     if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
                                                                 stop("Error: You are using the default user agent you might be caught.
         try sourcing the utils.R where agents are stored")
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.lif__item:nth-child(1)') %>% 
                                                                 html_text() %>%
                                                                 str_replace_all(c("€"="","\\."="")) %>% 
                                                                 str_extract( "\\-*\\d+\\.*\\d*") %>%  
                                                                 str_replace_na() %>% 
                                                                 str_replace("NA", 'Prezzo Su Richiesta')
                                                     return(web)
                                         }
                                         
                                         scrapeprimarykey.imm = function(session){
                                                     
                                                     if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
                                                                 stop("Error: You are using the default user agent you might be caught.
         try sourcing the utils.R where agents are stored")
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.text-primary a') %>% 
                                                                 html_attr('href') %>% 
                                                                 str_extract('\\d+') %>%
                                                                 as.numeric()
                                                     return(web)
                                         }
                                         
                                         scraperooms.imm = function(session){
                                                     
                                                     if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
                                                                 stop("Error: You are using the default user agent you might be caught.
         try sourcing the utils.R where agents are stored")
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.lif__item:nth-child(2) .text-bold') %>% 
                                                                 html_text() %>% 
                                                                 str_trim() %>% 
                                                                 as.numeric()
                                                     
                                                     return(web)
                                         }
                                         
                                         scrapespace.imm = function(session){
                                                     
                                                     if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
                                                                 stop("Error: You are using the default user agent you might be caught.
         try sourcing the utils.R where agents are stored")
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.lif__item:nth-child(3) .text-bold') %>% 
                                                                 html_text() %>% 
                                                                 as.numeric() 
                                                     return(web)
                                         }
                                         
                                         scrapetitle.imm = function(session){
                                                     
                                                     if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
                                                                 stop("Error: You are using the default user agent you might be caught.
         try sourcing the utils.R where agents are stored")
                                                     
                                                     if(is_url(session)[1]) 
                                                                 stop("Error: you are entering a URL instead of a SESSION object,
         try with the .$response workaround")
                                                     
                                                     
                                                     
                                                     web = read_html(session) %>% 
                                                                 html_nodes(css = '.text-primary a') %>% 
                                                                 html_text() %>% 
                                                                 str_replace_all('\n','') %>% 
                                                                 str_squish() %>% 
                                                                 as.character()
                                                     return(web)
                                         }
                                         
                                         ## end singolo_url ----
                                         
                                         ## START GROUPING FUN ----
                                         get.data.caturl = function(url){
                                                     
                                                     session = html_session(url,user_agent(agent = agents[sample(1)]))
                                                     
                                                     ad       = tryCatch({scrapetitle.imm(session)}, error = function(e){ message("some problem occured in scrapetitle.imm") })
                                                     price    = tryCatch({scrapeprice.imm(session)}, error = function(e){ message("some problem occured in scrapeprice.imm") })
                                                     room     = tryCatch({scraperooms.imm(session)}, error = function(e){ message("some problem occured in scraperooms.imm") })
                                                     sqmeter  = tryCatch({scrapespace.imm(session)}, error = function(e){ message("some problem occured in scrapespace.imm") })
                                                     primar   = tryCatch({scrapeprimarykey.imm(session)}, error = function(e){ message("some problem occured in scrapeprimarykey.imm") })
                                                     
                                                     combine = tibble(TITLE   = ad,
                                                                      MONTHLYPRICE  = price, 
                                                                      NROOM  = room,
                                                                      SQMETER = sqmeter,
                                                                      PRIMARYKEY = primar)
                                                     
                                                     combine %>%
                                                                 select(PRIMARYKEY,TITLE, SQMETER, NROOM, MONTHLYPRICE) 
                                                     return(combine) 
                                         }
                                         
                                         ## END GROUPING FUN ----
                                         
                                         x = get.data.caturl(list.of.pages.imm[i])}
            
            on.exit(stopCluster(cl))
            
            return(result) ## RETURN ALL THE STUFF ----
}

## [ all.links ] ----
## it extracts all the links, which are the single house ad
## inside a single agglomerative url

all.links= function(url  = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
                    npages = 10) {
            cl = makeCluster(detectCores()-1) #using max cores - 1 for parallel processing
            registerDoParallel(cl)
            
            ## build the url array 
            list.of.pages.imm = str_c(url, '&pag=', 2:npages) %>% 
                        append(url, after = 0)
            
            listone = foreach(i = seq_along(list.of.pages.imm),
                              .packages = lista.pacchetti,
                              .combine = "c",
                              .multicombine = TRUE,
                              .verbose = FALSE,
                              .errorhandling='pass') %dopar% {
                                          ## Utils start----
                                          
                                          
                                          agents =  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
                                          
                                          
                                          ## [ add other Headers ] ----
                                          
                                          
                                          mails = c('heurtee@triderprez.cf',
                                                    'nonliqui@famalsa.tk',
                                                    'bemerker@vagenland.gq',
                                                    'deutoplasm@c032bjik.buzz',
                                                    'controllably@mirider.ga')
                                          
                                          
                                          len = function(x){
                                                      length(x) %>% 
                                                                  print()
                                          }  
                                          
                                          ## [ sleep fucntion to simulate request delay  ] ----
                                          
                                          dormi = function() {
                                                      Sys.sleep(sample(seq(1, 2, by=0.001), 1))
                                          }
                                          
                                          ##  end utils ----

                                          ## [ scrapehref.imm MOD] ----
                                          
                                          scrapehref.imm = function(url){
                                                      
                                                      session = html_session(url,user_agent(agent = agents[sample(1)]))
                                                      
                                                      web = read_html(session) %>% 
                                                                  html_nodes(css = '.text-primary a') %>% 
                                                                  html_attr('href') %>%
                                                                  as.character()
                                                      return(web)
                                          }
                                          
                                          x = scrapehref.imm(list.of.pages.imm[i]) 
                              }
            stopCluster(cl)
            return(listone)
}

## [ scrape.all.info ] ----
## it scrapes all the information inside a single link
## 

scrape.all.info = function(links,
                           npages = 10){
            
            cl = makeCluster(detectCores()-1)
            registerDoParallel(cl)
            
            ALL = foreach(i = seq_along(links),
                          .packages = lista.pacchetti,
                          .combine = "bind_rows",
                          .multicombine = FALSE,
                          .export = "links",
                          .verbose = TRUE,
                          .errorhandling="pass") %dopar% {
                                      
                                      ## Utils start----
                                      
                                      agents =  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                  'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
                                                  'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                  'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                                                  'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
                                      
                                      
                                      ## [ add other Headers ] ----
                                      
                                      
                                      mails = c('heurtee@triderprez.cf',
                                                'nonliqui@famalsa.tk',
                                                'bemerker@vagenland.gq',
                                                'deutoplasm@c032bjik.buzz',
                                                'controllably@mirider.ga')
                                      
                                      
                                      len = function(x){
                                                  length(x) %>% 
                                                              print()
                                      }
                                      
                                      
                                      ## [ set default bind_rows ] ----
                                      
                                      
                                      bind_rows = dplyr::bind_rows
                                      
                                      
                                      
                                      ## [ test if valid URL] ----
                                      
                                      is_url = function(url){
                                                  re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
                                                  grepl(re, url)
                                      }
                                      
                                      
                                      
                                      ##  [ test User agent ] ----
                                      
                                      get_ua = function(sess) {
                                                  stopifnot(is.session(sess))
                                                  stopifnot(is_url(sess$url))
                                                  ua = sess$response$request$options$useragent
                                                  return(ua)
                                      }
                                      
                                      
                                      
                                      ## [ sleep fucntion to simulate request delay  ] ----
                                      
                                      dormi = function() {
                                                  Sys.sleep(sample(seq(1, 2, by=0.001), 1))
                                      }
                                      
                                      ##  end utils ---
                                      
                                      ## START FUNCTIONS_SINGOLOURL
                                      
                                      scrapeaddate.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("riferimento e Data annuncio" %in% web) {
                                                              pos = match("riferimento e Data annuncio",web)
                                                              web[pos+1] %>% 
                                                                          str_sub(start =-10) %>%
                                                                          lubridate::dmy() %>% 
                                                                          return()
                                                              
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ####
                                      
                                      scrapeage.imm = function(session){
                                                  
                                                  
                                                  web = read_html(session)
                                                  
                                                  cssquery = web %>%  
                                                              html_nodes(css = ".im-lead__reference p") %>%
                                                              html_text()
                                                  
                                                  if (is.null(cssquery)) {
                                                              json = web %>% 
                                                                          html_nodes(xpath = "/html/body/script[2]") %>% 
                                                                          html_text() %>%
                                                                          fromJSON()
                                                              
                                                              agency = json$listing$advertiser$agency$displayName 
                                                              if (!is.na(agency)) {
                                                                          return(agency)
                                                              } else  {
                                                                          cssquery = NA
                                                                          return(cssquery)
                                                              }
                                                              
                                                  }
                                                  return(cssquery[1])
                                      }
                                      
                                      ###
                                      
                                      scrapeagebuild.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>%
                                                              str_trim() 
                                                  
                                                  if ("anno di costruzione" %in% web) {
                                                              pos = match("anno di costruzione",web)
                                                              web[pos+1] %>%
                                                                          return()
                                                  } else {
                                                              return(NA_character_)
                                                              
                                                  }
                                      }
                                      
                                      ###
                                      
                                      scrapeaircondit.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("Climatizzazione" %in% web) {
                                                              pos = match("Climatizzazione",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapeaptchar.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>% 
                                                              str_replace_all('\\n','-') %>%
                                                              unique() %>% 
                                                              str_squish() %>% 
                                                              tolower() 
                                                  
                                                  
                                                  if ("altre caratteristiche" %in% web) {
                                                              pos = match("altre caratteristiche",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapecatastinfo.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("informazioni catastali" %in% web) {
                                                              pos = match("informazioni catastali",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                      }
                                      
                                      ###
                                      
                                      scrapecompart.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("locali" %in% web) {
                                                              pos = match("locali",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapecondom.imm = function(session) {
                                                  
                                                  
                                                  web = read_html(session)
                                                  
                                                  cssquery = web %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_squish() %>% 
                                                              str_trim()
                                                  
                                                  if ("spese condominio" %in% cssquery) {
                                                              pos = match("spese condominio",cssquery)
                                                              return(cssquery[pos+1])
                                                  } else {
                                                              json = web %>%
                                                                          html_nodes(xpath = "/html/body/script[2]") %>% 
                                                                          html_text() %>%
                                                                          fromJSON()
                                                              condom = json$listing$properties$costs$condominiumExpensesValue
                                                              return(condom)
                                                              
                                                              
                                                  }
                                      }
                                      
                                      ###
                                      
                                      scrapecontr.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("contratto" %in% web) {
                                                              pos = match("contratto",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapedisp.imm = function(session) {
                                                  
                                                  web = read_html(session) %>% 
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>%
                                                              str_trim() %>% 
                                                              str_squish()
                                                  
                                                  if ("disponibilità" %in% web) {
                                                              pos = match("disponibilità",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapeenclass.imm = function(session) {
                                                  
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>% 
                                                              str_trim()
                                                  
                                                  if ("Classe energetica" %in% web) {
                                                              pos = match("Classe energetica",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapefloor.imm = function(session){
                                                  
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("piano" %in% web) {
                                                              pos = match("piano",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }   
                                      
                                      ###
                                      
                                      scrapehasmulti.imm = function(session) {
                                                  
                                                  json = read_html(session) %>% 
                                                              html_nodes(xpath = "/html/body/script[2]") %>% 
                                                              html_text() %>%
                                                              fromJSON()
                                                  
                                                  hasmultimedia = json$listing$properties$multimedia$hasMultimedia
                                                  
                                                  return(hasmultimedia)
                                      }
                                      
                                      ###
                                      
                                      scrapeheating.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("riscaldamento" %in% web) {
                                                              pos = match("riscaldamento",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapehouse.ID= function(session) {
                                                  
                                                  ID = session %>%
                                                              .$url %>% 
                                                              as.character() %>% 
                                                              # str_trunc(45) %>% 
                                                              str_extract('\\d+') %>% 
                                                              forcats::as_factor()
                                                  return(ID)
                                      }
                                      
                                      ###
                                      
                                      scrapehousetxtdes.imm = function(session) {
                                                  
                                                  text = read_html(session) %>%
                                                              html_nodes(css ='.js-readAllText') %>% 
                                                              html_text() %>%
                                                              str_trim() %>% 
                                                              str_squish()
                                                  
                                                  return(text)
                                      }
                                      
                                      ###
                                      
                                      scrapelat.imm = function(session){
                                                  
                                                  web = read_html(session) %>% 
                                                              html_nodes(xpath = '//*[@id="js-hydration"]') %>% 
                                                              html_text() %>% 
                                                              fromJSON()
                                                  lat = web$listing$properties$location$latitude
                                                  return(lat)
                                      }
                                      
                                      ###
                                      
                                      scrapelong.imm = function(session){
                                                  
                                                  web = read_html(session) %>% 
                                                              html_nodes(xpath = '//*[@id="js-hydration"]') %>% 
                                                              html_text() %>% 
                                                              fromJSON()
                                                  long = web$listing$properties$location$longitude
                                                  return(long)
                                      }
                                      
                                      ###
                                      
                                      scrapeloweredprice.imm = function(session) {
                                                  
                                                  json = read_html(session) %>% 
                                                              html_nodes(xpath = "/html/body/script[2]") %>% 
                                                              html_text() %>%
                                                              fromJSON()
                                                  
                                                  lowprice = json$listing$properties$price$loweredPrice
                                                  if (is.na(lowprice) || is.null(lowprice)) {
                                                              tibble(
                                                                          originalPrice =NA_character_,
                                                                          currentPrice  = NA_character_,
                                                                          passedDays = NA_character_,
                                                                          date = NA_character_,
                                                                          
                                                              ) %>% 
                                                                          return()
                                                  } else {
                                                              originalPrice =lowprice$originalPrice
                                                              currentPrice  = lowprice$currentPrice
                                                              passedDays = lowprice$passedDays
                                                              date = lowprice$passedDays
                                                              
                                                              tibble(
                                                                          originalPrice,
                                                                          currentPrice,
                                                                          passedDays,
                                                                          date
                                                              ) %>%  
                                                                          mutate_all(as.character) %>% 
                                                                          return()
                                                  }
                                      }
                                      
                                      
                                      ###
                                      
                                      scrapemetrature.imm = function(session) {
                                                  
                                                  json = read_html(session) %>% 
                                                              html_nodes(xpath = "/html/body/script[2]") %>% 
                                                              html_text() %>%
                                                              fromJSON()
                                                  
                                                  
                                                  metrature = json$listing$properties$surfaceConstitution %>% 
                                                              tibble() %>% 
                                                              select(-totalCommercialSurface) %>%  
                                                              unnest_wider(col = surfaceConstitutionElements) %>%  
                                                              mutate_all(as.character)
                                                  
                                                  return(metrature)
                                      }
                                      
                                      ###
                                      
                                      scrapephotosnum.imm = function(session){
                                                  
                                                  
                                                  web = read_html(session) %>% 
                                                              html_nodes(css = '.js-tab-media')  %>% 
                                                              html_text(trim = T) %>% 
                                                              str_squish() %>% 
                                                              str_extract("[0-9]+")
                                                  return(web)
                                      }
                                      
                                      ###
                                      
                                      scrapepostauto.imm = function(session) {
                                                  
                                                  posauto = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("Posti Auto" %in% posauto) {
                                                              pos = match("Posti Auto",posauto)
                                                              return(posauto[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapeproptype.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("Tipo proprietà" %in% web) {
                                                              pos = match("Tipo proprietà",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                      }
                                      
                                      ###
                                      
                                      scrapereareview.imm = function(session){
                                                  
                                                  
                                                  review = read_html(session) %>%
                                                              html_nodes(css ='.js-readAllText') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  return(review)
                                      }   
                                      
                                      ###
                                      
                                      scrapestatus.imm = function(session) {
                                                  
                                                  web = read_html(session)
                                                  cssquery = web %>% 
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("stato" %in% cssquery) {
                                                              pos = match("stato",cssquery)
                                                              return(cssquery[pos+1])
                                                  } else {
                                                              json = web %>%
                                                                          html_nodes(xpath = "/html/body/script[2]") %>% 
                                                                          html_text() %>%
                                                                          fromJSON()
                                                              status =  json$listing$properties$condition
                                                              return(status)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapetotpiani.imm = function(session) {
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  
                                                  if ("totale piani edificio" %in% web) {
                                                              pos = match("totale piani edificio",web)
                                                              return(web[pos+1])
                                                  } else {
                                                              return(NA_character_)
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapetype.imm = function(session) {
                                                  
                                                  web = read_html(session)
                                                              cssquery = web %>% 
                                                              html_nodes(css ='.im-features__value , .im-features__title') %>%
                                                              html_text() %>%
                                                              str_trim()
                                                  
                                                  if ("tipologia" %in% cssquery) {
                                                              pos = match("tipologia",cssquery)
                                                              return(cssquery[pos+1])
                                                  } else {
                                                              json = web %>% 
                                                                          html_nodes(xpath = "/html/body/script[2]") %>%
                                                                          html_text() %>%
                                                                          fromJSON()
                                                              
                                                              type =  json$listing$properties$typology$name
                                                              return(type)
                                                  }
                                      }
                                      
                                      ###
                                      
                                      take_spatialJSON = function(session) {
                                                  
                                                  json = read_html(session) %>% 
                                                              html_nodes(xpath = "/html/body/script[2]") %>%
                                                              html_text() %>%
                                                              fromJSON()
                                                  
                                                  spatial = json$listing$properties$location %>%
                                                              tibble() %>%  
                                                              mutate_if(is.character, list(~na_if(., ""))) %>% 
                                                              .[1,]
                                                  
                                                  return(spatial)
                                      }
                                      
                                      ###
                                      
                                      take.address = function(session){
                                                  
                                                  web = read_html(session) %>%
                                                              html_nodes(css = '.im-titleBlock__title') %>%
                                                              html_text() %>% 
                                                              str_replace('Monolocale', '') %>% 
                                                              str_replace('Bilocale', '') %>% 
                                                              str_replace('Trilocale', '') %>% 
                                                              str_replace('Quadrilocale', '') %>% 
                                                              str_replace('Appartamento', '') %>%  
                                                              str_replace('Attico', '') %>%
                                                              str_replace('Mansarda', '') %>% 
                                                              str_replace('Loft', '') %>% 
                                                              str_replace('Milano', '') %>% 
                                                              str_remove("[^\\w\\s]") %>%
                                                              str_trim() %>% 
                                                              tolower()
                                                  
                                                  if (!grepl(web,pattern = "\\d+")) {
                                                              
                                                              civico = take_spatialJSON(session) %>% 
                                                                          .$streetNumber
                                                              if (is.na(civico)) {
                                                                          civico = "C.A."
                                                              }
                                                              web_n = paste(web,civico)
                                                              return(web_n)
                                                  } else {
                                                              return(web)
                                                  }
                                      }
                                      
                                      ### END FUNCTIONS_SINGOLOURL ----
                                      
                                      
                                      
                                      get.data.catsing = function(singolourl){
                                                  
                                                  # dormi()
                                                  
                                                  session = html_session(singolourl, user_agent(agents[sample(1)]))
                                                  if (class(session)=="session") {
                                                              session = session$response  
                                                  }
                                                  
                                                  id         = tryCatch({scrapehouse.ID(session)}, error = function(e){ message("some problem occured in scrapehouse.ID") })
                                                  lat        = tryCatch({scrapelat.imm(session)}, error = function(e){ message("some problem occured in scrapelat.imm") })
                                                  long       = tryCatch({scrapelong.imm(session)}, error = function(e){ message("some problem occured in scrapelong.imm") })
                                                  location   = tryCatch({take.address(session)}, error = function(e){ message("some problem occured in take.address") })
                                                  condom     = tryCatch({scrapecondom.imm(session)}, error = function(e){ message("some problem occured in scrapecondom.imm") })
                                                  buildage   = tryCatch({scrapeagebuild.imm(session)}, error = function(e){ message("some problem occured in scrapeagebuild.imm") })
                                                  floor      = tryCatch({scrapefloor.imm(session)}, error = function(e){ message("some problem occured in scrapefloor.imm") })
                                                  indivsapt  = tryCatch({scrapetype.imm(session)}, error = function(e){ message("some problem occured in scrapetype.imm") })
                                                  locali     = tryCatch({scrapecompart.imm(session)}, error = function(e){ message("some problem occured in scrapecompart.imm") })
                                                  tpprop     = tryCatch({scrapeproptype.imm(session)}, error = function(e){ message("some problem occured in scrapeproptype.imm") })
                                                  status     = tryCatch({scrapestatus.imm(session)}, error = function(e){ message("some problem occured in scrapestatus.imm") })
                                                  heating    = tryCatch({scrapeheating.imm(session)}, error = function(e){ message("some problem occured in scrapeheating.imm") })
                                                  ac         = tryCatch({scrapeaircondit.imm(session)}, error = function(e){ message("some problem occured in scrapeaircondit.imm") })
                                                  date       = tryCatch({scrapeaddate.imm(session)}, error = function(e){ message("some problem occured in scrapeaddate.imm") })
                                                  catastinfo = tryCatch({scrapecatastinfo.imm(session)}, error = function(e){ message("some problem occured in scrapecatastinfo.imm") })
                                                  aptchar    = tryCatch({scrapeaptchar.imm(session)}, error = function(e){ message("some problem occured in scrapeaptchar.imm") })
                                                  photosnum  = tryCatch({scrapephotosnum.imm(session)}, error = function(e){ message("some problem occured in scrapephotosnum.imm") })
                                                  age        = tryCatch({scrapeage.imm(session)}, error = function(e){ message("some problem occured in scrapeage.imm") })
                                                  enclass    = tryCatch({scrapeenclass.imm(session)}, error = function(e){ message("some problem occured in scrapeenclass.imm") })
                                                  contr      = tryCatch({scrapecontr.imm(session)}, error = function(e){ message("some problem occured in scrapecontr.imm") })
                                                  disp       = tryCatch({scrapedisp.imm(session)}, error = function(e){ message("some problem occured in scrapedisp.imm") })
                                                  totpiani   = tryCatch({scrapetotpiani.imm(session)}, error = function(e){ message("some problem occured in scrapetotpiani.imm") })
                                                  postauto   = tryCatch({scrapepostauto.imm(session)}, error = function(e){ message("some problem occured in scrapepostauto.imm") })
                                                  review     = tryCatch({scrapereareview.imm(session)}, error = function(e){ message("some problem occured in scrapereareview.imm") })
                                                  metrat     = tryCatch({scrapemetrature.imm(session)}, error = function(e){ message("some problem occured in scrapemetrature.imm") })
                                                  multi      = tryCatch({scrapehasmulti.imm(session)}, error = function(e){ message("some problem occured in scrapehasmulti.imm") })
                                                  lowprice   = tryCatch({scrapeloweredprice.imm(session)}, error = function(e){ message("some problem occured in scrapeloweredprice.imm") })
                                                  
                                                  
                                                  combine = tibble(
                                                              ID        = id,
                                                              LAT       = lat,
                                                              LONG      = long,
                                                              LOCATION  = location,
                                                              CONDOM    = condom,
                                                              BUILDAGE  = buildage,
                                                              FLOOR     = floor,
                                                              INDIVSAPT = indivsapt,
                                                              LOCALI    = locali,
                                                              TPPROP    = tpprop,
                                                              STATUS    = status,
                                                              HEATING   = heating,
                                                              AC        = ac,
                                                              PUB_DATE  = date,
                                                              CATASTINFO= catastinfo,
                                                              APTCHAR   = aptchar,
                                                              PHOTOSNUM = photosnum,
                                                              AGE       = age,
                                                              ENCLASS   = enclass,
                                                              CONTR     = contr,
                                                              DISP      = disp,
                                                              TOTPIANI  = totpiani,
                                                              PAUTO     = postauto,
                                                              REVIEW    = review,
                                                              METRATURA = metrat,
                                                              HASMULTI  = multi,
                                                              LOWRDPRICE= lowprice)
                                                  
                                                  combine %>% 
                                                              select(ID, CONDOM, FLOOR, LAT, LONG, INDIVSAPT, 
                                                                     LOCALI, STATUS, HEATING, AC, PUB_DATE, APTCHAR, 
                                                                     PHOTOSNUM, AGE, ENCLASS, DISP,TPPROP,  METRATURA, LOWRDPRICE, PAUTO, REVIEW, TOTPIANI, 
                                                                     BUILDAGE, CONTR, LOCATION, CATASTINFO, HASMULTI)
                                                  
                                                  return(combine) 
                                                  
                                      }
                                      
                                      x = get.data.catsing(links[i])}
            
            stopCluster(cl)
            return(ALL)
}








## 3.0 REST API ENDPOINT  ----
# define APIs

#* @apiTitle immobiliare.it data
#* @apiDescription GET estensive data from immobiliare.it real estate rental
#* @apiVersion 0.0.1


#* Get fast raw data (5 covariates: title, price, num of rooms, sqmeter, primarykey)
#* @param url you you want to extract information by
#* @param npages the number of pages you want to scrape
#* @get /scrape
function(url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
         npages = 10){
            list(
                        data = scrape.all(url,npages)
            )
           
}



#* Get all the links  
#* @param url you you want to extract info
#* @param npages num of pages you are interested in
#* @get /links
function(url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
         npages = 10){
            list(
                        links = all.links(url,npages)
            )
            
}


#* Get the complete data from single links (not the raw)
#* @param url you you want to extract info from
#* @param npages num of pages you are interested starting from the url param
#* @get /complete
function(url = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
         npages = 10){
            links = all.links(url,npages)
            list(
                        complete = scrape.all.info(links)
                        
            )
            
}


