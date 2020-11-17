## scrape the title -----
## scrape the rental title advertisement


scrapetitle_imm = function(session){
            
            web = read_html(session) %>% 
                        html_nodes(css = '.text-primary a') %>% 
                        html_text() %>% 
                        str_replace_all('\n','') %>% 
                        str_squish() %>% 
                        as.character()
            return(web)
}



# 
# if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
#   stop("Error: You are using the default user agent you might be caught.
#        try sourcing the utils.R where agents are stored")
# 
# if(is_url(session)[1]) 
#   stop("Error: you are entering a URL instead of a SESSION object,
#        try with the .$response workaround")
# 

