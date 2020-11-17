## Scrape the price ----
## scrape the house price 

scrapeprice_imm = function(session){
            
            web = read_html(session) %>% 
                        html_nodes(css = '.lif__item:nth-child(1)') %>% 
                        html_text() %>%
                        str_replace_all(c("€"="","\\."="")) %>% 
                        str_extract( "\\-*\\d+\\.*\\d*") %>% 
                        str_replace_na() %>%
                        str_replace("NA", 'Prezzo Su Richiesta')
            return(web)
} 

