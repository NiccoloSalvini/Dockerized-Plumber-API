## Scrape the number of room ----
## scrape the number of  rooms in the apartements


scraperooms_imm = function(session){
            
            web = read_html(session) %>% 
                        html_nodes(css = '.lif__item:nth-child(2) .text-bold') %>% 
                        html_text() %>% 
                        str_trim() 
            
            return(web)
}  


# if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
#   stop("Error: You are using the default user agent you might be caught.
#        try sourcing the utils.R where agents are stored")
# 