## Scrape the space -----
## scrape the square meter footage of the house 

scrapespace_imm = function(session){
            # 
            # if(get_ua(session) == "libcurl/7.64.1 r-curl/4.3 httr/1.4.1") 
            #   stop("Error: You are using the default user agent you might be caught.
            #        try sourcing the utils.R where agents are stored")
            
            web = read_html(session) %>% 
                        html_nodes(css = '.lif__item:nth-child(3) .text-bold') %>% 
                        html_text() 
            return(web)
}