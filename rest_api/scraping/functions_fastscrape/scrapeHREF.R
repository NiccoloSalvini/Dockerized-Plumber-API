## Scrape the href ----
## scrape the href of each single advs

scrapehref_imm = function(session){
            
            web = read_html(session) %>% 
                        html_nodes(css = '.text-primary a') %>% 
                        html_attr('href') %>%
                        as.character()
            return(web)
}


