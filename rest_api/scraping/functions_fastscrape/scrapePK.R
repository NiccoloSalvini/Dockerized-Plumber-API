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

