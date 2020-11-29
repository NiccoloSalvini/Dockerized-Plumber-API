## Scrape the space -----
## scrape the square meter footage of the house 

scrapespace_imm = function(session){
            
            space = read_html(session)
            space1 = space %>% 
                        html_nodes(css = '.lif__item:nth-child(3) .text-bold') %>% 
                        html_text()
            
            
            if(!length(space) == 25){
                        space2 = space %>% 
                                    html_nodes(xpath = '//*[@id="js-hydration"]/text()') %>% 
                                    html_text(trim = T) %>%  
                                    jsonlite::fromJSON() %>%
                                    .$ads %>%  
                                    tidyjson::spread_all() %>% 
                                    dplyr::as_tibble() %>% 
                                    select(superficie)
                        
            }
                        
                        return(space)
}
