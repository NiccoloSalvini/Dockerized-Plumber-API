## 1.0 UTILS FUNCTIONS ----

# ## [ Agents ] ----
# 
# 
# agents =  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
#             'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
#             'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
#             'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
#             'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
#             'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
#             'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
#             'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
#             'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
#             'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
# 
# 
# 
# 
# ## [ add_Headers ] ### ----
# fake e-mial generator
url = "https://it.emailfake.com/"
fakemail = function(url = "https://it.emailfake.com/") {
            mail = url %>%
                        read_html() %>% 
                        html_node(css = "#email_ch_text")  %>%
                        html_text()
            return(mail)
                        
            
}
mail = url %>% read_html() %>% 
            html_node(css = "#email_ch_text")  %>%
            html_text()

# mails = c('heurtee@triderprez.cf',
#           'nonliqui@famalsa.tk',
#           'bemerker@vagenland.gq',
#           'deutoplasm@c032bjik.buzz',
#           'controllably@mirider.ga')

##  [ len ] ----
# so that I always type "lenght" lenhgt
# and some other monster stuff

len = function(x){
            length(x) %>% 
                        print()
}




## [ Source entire Folder ] ----


sourceEntireFolder = function(folderName, verbose=FALSE, showWarnings=TRUE) { 
            files = list.files(folderName, full.names=TRUE)
            
            # Grab only R files
            files = files[ grepl("\\.[rR]$", files) ]
            
            if (!length(files) && showWarnings)
                        warning("No R files in ", folderName)
            
            for (f in files) {
                        if (verbose)
                                    cat("sourcing: ", f, "\n")
                        ## TODO:  add caught whether error or not and return that
                        try(source(f, local=FALSE, echo=FALSE), silent=!verbose)
            }
            return(invisible(NULL))
}

##  [ get UA ] -----


get_ua = function(sess) {
            stopifnot(is.session(sess))
            stopifnot(is_url(sess$url))
            ua = sess$response$request$options$useragent
            return(ua)
}


##  [Get Robot.txt delay]   -----


get_delay = function(domain) {
            
            message(sprintf("Refreshing robots.txt data for %s...", domain))
            
            cd_tmp = robotstxt::robotstxt(domain)$crawl_delay
            
            if (length(cd_tmp) > 0) {
                        star = dplyr::filter(cd_tmp, useragent=="*")
                        if (nrow(star) == 0) star = cd_tmp[1,]
                        as.numeric(star$value[1])
            } else {
                        10L
            }
            
}



## [ Robot.txt ] ----


checkpermission = function(dom) {
            
            robot = robotstxt(domain = dom)
            vd = robot$check()[1] 
            return(vd)
}


## [ Dormi ]  ----

dormi = function() {
            Sys.sleep(sample(seq(1, 2, by=0.001), 1))
}




## [ test if url ] ----
## checks if it is a proper url according to regex

is_url = function(url){
            re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
            grepl(re, url)
}

## [convert _empty] ----
## for log append purposes

convert_empty <- function(string) {
            if (string == "") {
                        "-"
            } else {
                        string
            }
}




## [get_link] ----
## reverse engineer the link 
##  problemi conosciuti:
##  - la zona centro corrisponde a più zone perchè presente in più citta
##  - possibilità di selezionare più città insieme  più città insieme 
##  - quanfdo numero di pagine maggiore di quello esistente allora dirlo
##  ed adoperare tutto il numero di pagine possibile
##  - possibilità selection microzone (scrappabili)
##  - possibilità di selezionare ogni zona per città

get_link = function(npages,
                    city,
                    macrozone,
                    type) {
            
            ## sanitize input
            tipo = tolower(type) %>% str_trim()
            citta = tolower(city) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
            
            ## macrozone selection
            if(!missing("macrozone")){
                        
                        ## sanitize input
                        macroozone = tolower(macrozone) %>% iconv(to='ASCII//TRANSLIT') %>%  str_trim()
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
                        
                        if (length(idzone)==1){
                                    mzones = glue("&idMZona[]={idzone}")
                        } else {
                                    mzones =  glue::glue_collapse(glue("&idMZona[]={idzone}"), "&idMZona[]=")    
                                    }
                        
                        
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/", "?criterio=rilevanza", mzones) 
                        
                        if(is_url(stringa)){
                                    npages_vec = glue("{stringa}&pag={2:npages}") %>%
                                                append(stringa, after = 0)
                        } else {
                                    stop("url imputted does not seem to be Real")
                        }
                        
                        
            } else {
                        dom = "https://www.immobiliare.it/"
                        stringa = paste0(dom, tipo, "-case/", citta,"/", "?criterio=rilevanza") # mzones
                        if (is_url(stringa)){
                                    npages_vec = glue("{stringa}&pag={2:npages}") %>%
                                                append(stringa, after = 0)  
                        } else {
                                    stop("url imputted does not seem to be Real")
                        }
                        
            }
            return(npages_vec)
            
            # get_final_href = read_html(npages_vec[1]) %>% 
            #             html_node(css = ".pagination__number .disabled+ .disabled .disabled") %>%  
            #             html_text() %>%  
            #             as.integer()
            # if_else(length(npages_vec) > get_final_href,stop("npages inputted is greater than the already existing ones"), return(npages_vec))

            # if (length(npages_vec) > get_final_href) {
            # 
            #             return("npages inputted is greater than the already existing ones")
            # } else {
            # 
            #             return(npages_vec)
            # }

            
            
            
}


##  [FromNUllToNA]   -----
##  coercing NULL to NA to bind result in tibbles
FromNUllToNA = function(x) {
            ifelse(is.null(x), NA, x)
}






url %>% read_html() %>% 
            html_node(css = "#email_ch_text")  %>% 
            html_text()
