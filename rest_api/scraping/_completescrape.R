## [ scrape.all.info ] ----
## it scrapes all the information inside a single link
## 

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

completescrape = function(links){
            
            cores = detectCores(logical = FALSE)
            cl = makeCluster(cores)
            registerDoParallel(cl, cores=cores)
            tic()
            ALL = foreach(i = seq_along(links),
                          .packages = vec.pacchetti,
                          .combine = "bind_rows",
                          .multicombine = TRUE,
                          .export = "links",
                          .verbose = TRUE,
                          .inorder = FALSE,
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
                                      
                                      
         
                                      
                                      len = function(x){
                                                  length(x) %>% 
                                                              print()
                                      }
                                      
                                      
                                      ## [ set default bind_rows ] ----
                                      
                                      
                                      bind_rows = dplyr::bind_rows
                                      
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
                                                              condom = cssquery[pos+1] 
                                                              return(condom) %>%  
                                                                          str_extract("[0-9]+")
                                                  } else {
                                                              
                                                              json = web %>%
                                                                          html_nodes(xpath = "/html/body/script[2]") %>%
                                                                          html_text() %>%
                                                                          fromJSON()
                                                              condom = json$listing$properties$costs$condominiumExpensesValue
                                                              if(is.null(condom)){
                                                                          return(NA_character_)
                                                              } else {
                                                                          return(condom)
                                                              }
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
                                                  
                                                  if ("Efficienza energetica" %in% web) {
                                                              pos = match("Efficienza energetica",web)
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
                                      
                                      
                                      ######### INS ----
                                      
                                      scrapenroomsINS.imm = function(session) {
                                                  
                                                  opensess = read_html(session)
                                                  nroom  = opensess %>% 
                                                              html_nodes(css =".im-mainFeatures__price+ .nd-list__item .im-mainFeatures__value") %>% 
                                                              html_text() %>%
                                                              str_trim() 
                                                  
                                                  if(is.null(nroom) || identical(nroom, character(0))) {
                                                              nroom2 = opensess %>%
                                                                          html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                                          html_text() %>%
                                                                          str_trim()
                                                              
                                                              if ("locali" %in% nroom2) {
                                                                          pos = match("locali",nroom2)
                                                                          return(nroom2[pos+1])  %>% 
                                                                                      str_extract("[0-9]+")
                                                              } else {
                                                                          return(NA_character_)
                                                              }
                                                  } else {
                                                              return(nroom)
                                                              
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapepriceINS.imm = function(session) {
                                                  
                                                  opensess = read_html(session)
                                                  price  = opensess %>% 
                                                              html_nodes(css =".im-mainFeatures__title") %>% 
                                                              html_text() %>%
                                                              str_trim() 
                                                  
                                                  if(is.null(price) || identical(price, character(0))) {
                                                              price2 = opensess %>%
                                                                          html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                                          html_text() %>%
                                                                          str_trim()
                                                              
                                                              if ("prezzo" %in% price2) {
                                                                          pos = match("prezzo",price2)
                                                                          return(price2[pos+1])  %>% 
                                                                                      str_replace_all(c("€"="","\\."="")) %>% 
                                                                                      str_extract( "\\-*\\d+\\.*\\d*") %>%  
                                                                                      str_replace_na() %>% 
                                                                                      str_replace("NA", "Prezzo Su Richiesta")
                                                              } else {
                                                                          return(NA_character_)
                                                              }
                                                  } else {
                                                              return(price) %>% 
                                                                          str_replace_all(c("€"="","\\."="")) %>% 
                                                                          str_extract( "\\-*\\d+\\.*\\d*") %>%  
                                                                          str_replace_na() %>% 
                                                                          str_replace("NA", "Prezzo Su Richiesta")
                                                              
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapesqfeetINS.imm = function(session) {
                                                  
                                                  opensess = read_html(session)
                                                  sqfeet  = opensess %>% 
                                                              html_nodes(css =".nd-list__item:nth-child(3) .im-mainFeatures__value") %>% 
                                                              html_text() %>%
                                                              str_trim() 
                                                  
                                                  if(is.null(sqfeet) || identical(sqfeet, character(0))) {
                                                              sqfeet2 = opensess %>%
                                                                          html_nodes(css ='.im-features__value , .im-features__title') %>% 
                                                                          html_text() %>%
                                                                          str_trim()
                                                              
                                                              if ("superficie" %in% sqfeet2) {
                                                                          pos = match("superficie",sqfeet2)
                                                                          return(sqfeet2[pos+1])  %>% 
                                                                                      str_extract("[0-9]+")
                                                              } else {
                                                                          return(NA_character_)
                                                              }
                                                  } else {
                                                              return(sqfeet) %>%  
                                                                          str_extract("[0-9]+")
                                                              
                                                  }
                                                  
                                      }
                                      
                                      ###
                                      
                                      scrapetitleINS.imm = function(session) {
                                                  
                                                  opensess = read_html(session)
                                                  title  = opensess %>% 
                                                              html_nodes(css =".im-titleBlock__title") %>% 
                                                              html_text() %>%
                                                              str_trim()
                                                  return(title)
                                                  
                                      }
                                      
                                      
                                      ### END FUNCTIONS_SINGOLOURL ----
                                      
                                      
                                      
                                      get.data.catsing = function(singolourl){
                                                  
                                                  # dormi()
                                                  
                                                  session = html_session(singolourl, user_agent(agents[sample(1)]))
                                                  if (class(session)=="session") {
                                                              session = session$response  
                                                  }
                                                  
                                                  result = tibble(
                                                              id         = tryCatch({scrapehouse.ID(session)}, error = function(e){ message("some problem occured in scrapehouse.ID") }),
                                                              lat        = tryCatch({scrapelat.imm(session)}, error = function(e){ message("some problem occured in scrapelat.imm") }),
                                                              long       = tryCatch({scrapelong.imm(session)}, error = function(e){ message("some problem occured in scrapelong.imm") }),
                                                              location   = tryCatch({take.address(session)}, error = function(e){ message("some problem occured in take.address") }),
                                                              condom     = tryCatch({scrapecondom.imm(session)}, error = function(e){ message("some problem occured in scrapecondom.imm") }),
                                                              buildage   = tryCatch({scrapeagebuild.imm(session)}, error = function(e){ message("some problem occured in scrapeagebuild.imm,") }),
                                                              floor      = tryCatch({scrapefloor.imm(session)}, error = function(e){ message("some problem occured in scrapefloor.imm") }),
                                                              indivsapt  = tryCatch({scrapetype.imm(session)}, error = function(e){ message("some problem occured in scrapetype.imm") }),
                                                              locali     = tryCatch({scrapecompart.imm(session)}, error = function(e){ message("some problem occured in scrapecompart.imm") }),
                                                              tpprop     = tryCatch({scrapeproptype.imm(session)}, error = function(e){ message("some problem occured in scrapeproptype.imm") }),
                                                              status     = tryCatch({scrapestatus.imm(session)}, error = function(e){ message("some problem occured in scrapestatus.imm") }),
                                                              heating    = tryCatch({scrapeheating.imm(session)}, error = function(e){ message("some problem occured in scrapeheating.imm") }),
                                                              ac         = tryCatch({scrapeaircondit.imm(session)}, error = function(e){ message("some problem occured in scrapeaircondit.imm")}),
                                                              date       = tryCatch({scrapeaddate.imm(session)}, error = function(e){ message("some problem occured in scrapeaddate.imm") }),
                                                              catastinfo = tryCatch({scrapecatastinfo.imm(session)}, error = function(e){ message("some problem occured in scrapecatastinfo.imm")}),
                                                              aptchar    = tryCatch({scrapeaptchar.imm(session)}, error = function(e){ message("some problem occured in scrapeaptchar.imm") }),
                                                              photosnum  = tryCatch({scrapephotosnum.imm(session)}, error = function(e){ message("some problem occured in scrapephotosnum.imm") }),
                                                              age        = tryCatch({scrapeage.imm(session)}, error = function(e){ message("some problem occured in scrapeage.imm") }),
                                                              enclass    = tryCatch({scrapeenclass.imm(session)}, error = function(e){ message("some problem occured in scrapeenclass.imm") }),
                                                              contr      = tryCatch({scrapecontr.imm(session)}, error = function(e){ message("some problem occured in scrapecontr.imm") }),
                                                              disp       = tryCatch({scrapedisp.imm(session)}, error = function(e){ message("some problem occured in scrapedisp.imm") }),
                                                              totpiani   = tryCatch({scrapetotpiani.imm(session)}, error = function(e){ message("some problem occured in scrapetotpiani.imm") }),
                                                              postauto   = tryCatch({scrapepostauto.imm(session)}, error = function(e){ message("some problem occured in scrapepostauto.imm") }),
                                                              review     = tryCatch({scrapereareview.imm(session)}, error = function(e){ message("some problem occured in scrapereareview.imm") }),
                                                              metrat     = tryCatch({scrapemetrature.imm(session)}, error = function(e){ message("some problem occured in scrapemetrature.imm") }),
                                                              multi      = tryCatch({scrapehasmulti.imm(session)}, error = function(e){ message("some problem occured in scrapehasmulti.imm") }),
                                                              lowprice   = tryCatch({scrapeloweredprice.imm(session)}, error = function(e){ message("some problem occured in scrapeloweredprice.imm") }),
                                                              ###
                                                              nrooms     = tryCatch({scrapenroomsINS.imm(session)}, error = function(e){ message("some problem occured in scrapenroomsINS.imm") }),
                                                              price      = tryCatch({scrapepriceINS.imm(session)}, error = function(e){ message("some problem occured in scrapepriceINS.imm") }),
                                                              sqfeet     = tryCatch({scrapesqfeetINS.imm(session)}, error = function(e){ message("some problem occured in scrapesqfeetINS.imm") }),
                                                              title      = tryCatch({scrapetitleINS.imm(session)}, error = function(e){ message("some problem occured in scrapetitleINS.imm") })
                                                              
                                                  )
                                                  
                                                  # combine = tibble(
                                                  #             ID        = id,
                                                  #             LAT       = lat,
                                                  #             LONG      = long,
                                                  #             LOCATION  = location,
                                                  #             CONDOM    = condom,
                                                  #             BUILDAGE  = buildage,
                                                  #             FLOOR     = floor,
                                                  #             INDIVSAPT = indivsapt,
                                                  #             LOCALI    = locali,
                                                  #             TPPROP    = tpprop,
                                                  #             STATUS    = status,
                                                  #             HEATING   = heating,
                                                  #             AC        = ac,
                                                  #             PUB_DATE  = date,
                                                  #             CATASTINFO= catastinfo,
                                                  #             APTCHAR   = aptchar,
                                                  #             PHOTOSNUM = photosnum,
                                                  #             AGE       = age,
                                                  #             ENCLASS   = enclass,
                                                  #             CONTR     = contr,
                                                  #             DISP      = disp,
                                                  #             TOTPIANI  = totpiani,
                                                  #             PAUTO     = postauto,
                                                  #             REVIEW    = review,
                                                  #             METRATURA = metrat,
                                                  #             HASMULTI  = multi,
                                                  #             LOWRDPRICE= lowprice,
                                                  #             ###
                                                  #             NROOMS    = nrooms,
                                                  #             PRICE     = price,
                                                  #             SQFEET    = sqfeet,
                                                  #             TITLE     = title)
                                                  # 
                                                  # combine %>% 
                                                  #             select(ID, CONDOM, FLOOR, LAT, LONG, INDIVSAPT, 
                                                  #                    LOCALI, STATUS, HEATING, AC, PUB_DATE, APTCHAR, 
                                                  #                    PHOTOSNUM, AGE, ENCLASS, DISP,TPPROP,  METRATURA, LOWRDPRICE, PAUTO, REVIEW, TOTPIANI, 
                                                  #                    BUILDAGE, CONTR, LOCATION, CATASTINFO, HASMULTI, NROOMS, PRICE, SQFEET, TITLE)
                                                  
                                                  return(result) 
                                                  
                                      }
                                      
                                      x = get.data.catsing(links[i])
                                      }
            toc()
            stopImplicitCluster()
            stopCluster(cl)
            return(ALL)
            
}




