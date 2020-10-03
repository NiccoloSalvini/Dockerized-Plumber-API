## [ scrape.all ] ----
## it scrapes all the available information in the grouping section

scrape = function(npages = 10,
                  city  = "milano",
                  type  = "affitto"){
            
            
            ## sanitize iput from user 
            # if (as.character(city)){city = stringi::stri_trans_general(city,"Latin-ASCII")}
            # if (!type %in% c("affitto", "vendita")){ stop("type has only 2 options: 'affitto' o 'vendita'")}
            ## default url corresponds to Milan rental Real Estate
            ## compose target url
            dom = "https://www.immobiliare.it/"
            stringa = paste0(dom,type,"-case/",city,"/")
            list.of.pages.imm = str_c(stringa, '?pag=', 2:npages) %>% 
                        append(stringa, after = 0) 
            
            cl = makeCluster(detectCores()-1)
            registerDoParallel(cl)
            result = foreach(i = seq_along(list.of.pages.imm),
                             .packages = vec.pacchetti,
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
