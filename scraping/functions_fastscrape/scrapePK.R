##  scrape the primary key ----
## scrapoe the immobiliare ID of the the apt 
## for join reasons

scrapeprimarykey_imm = function(session){
             
            web = read_html(session) %>% 
                        html_nodes(css = '.text-primary a') %>% 
                        html_attr('href') %>% 
                        str_extract('\\d+')
            return(web)
}

# 
# if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
#   stop("Error: You are using the default user agent you might be caught.
#        try sourcing the utils.R where agents are stored")
