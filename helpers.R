## 1.0 UTILS FUNCTIONS ----

## [ Agents ] ----


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


## [ add_Headers ] ### ----


mails = c('heurtee@triderprez.cf',
          'nonliqui@famalsa.tk',
          'bemerker@vagenland.gq',
          'deutoplasm@c032bjik.buzz',
          'controllably@mirider.ga')

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


## [ test if URL]  ----


is_url = function(url){
            re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
            grepl(re, url)
}



##  [ get UA ] -----


get_ua = function(sess) {
            stopifnot(is.session(sess))
            stopifnot(is_url(sess$url))
            ua = sess$response$request$options$useragent
            return(ua)
}


##  [Get Robot.txt delay]   -----


.get_delay = function(domain) {
            
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
            if (vd) {
                        cat("\nrobot.txt dice: va bene, puoi!")
            } else {cat("\nrobot.txt dice: non puoi, smettila")}
}


## [ Dormi ]  ----

dormi = function() {
            Sys.sleep(sample(seq(1, 2, by=0.001), 1))
}




## [ is url] ----
## checks if the url inputted is well composed according to regex

is_url = function(url){
            re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
            grepl(re, url)
}

## [get_link] ----
## return composition of the url 
## deprecated...

get_link = function(city = "milano",
                    type = "affitto",
                    npages = 10,
                    .url,
                    # .macrozone= c("fiera", "centro"),
                    .list = FALSE) {
            tipo = tolower(type)
            citta = tolower(city) %>% iconv(to='ASCII//TRANSLIT')
            macrozone = tolower(.macrozone) %>% iconv(to='ASCII//TRANSLIT')
            
            if(!tipo %in% c("affitto", "vendita")){stop("Affitto has to be specified")}
            # if(!identical(tipo, "affitto")){stop("Affitto has to be specified")}
            
            # if(!identical(macrozone, c("fiera", "centro"))){
            #             idzone = list()
            #             for(i in seq_along(macrozone)){
            #                         zone = fromJSON("zone.json")
            #                         zone$name = zone$name %>%  tolower()
            #                         if(grepl(macrozone[i], zone)[2]){
            #                                     pos = grepl(macrozone[i],zone$name, ignore.case = T)
            #                                     idzone[i] = zone[pos,] %>%  select(id)
            #                         } else { 
            #                                     stop(paste0("zone:", macrozone[i], " is not recognized"))
            #                                     }
            #             }
            #             idzone = idzone %>%  unlist() %>%  unique()
            #             mzones =  glue::glue_collapse(x = idzone, "&idMZona[]=") %>% 
            #                         paste0("?idMZona[]=",.)
            #             
            #             dom = "https://www.immobiliare.it/"
            #             stringa = paste0(dom,tipo,"-case/",citta,"/",mzones)
            #             lista = c()
            #             url = list(stringa = stringa, lista = lista)
            # }
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

## [convert _empty] ----
## for log append purposes
convert_empty <- function(string) {
            if (string == "") {
                        "-"
            } else {
                        string
            }
}

