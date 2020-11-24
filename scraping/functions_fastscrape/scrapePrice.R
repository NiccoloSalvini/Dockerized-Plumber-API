## Scrape the price ----
## scrape the house price 

scrapeprice_imm = function(session){
            
            parse_html = read_html(session) %>% 
                        html_nodes(css = '.lif__item:nth-child(1)') %>% 
                        html_text(trim = T) %>%
                        str_extract( "\\-*\\d+\\.*\\d*") %>%  
                        str_remove("\\.") %>%
                        str_replace_all("Prezzo Su Richiesta", NA_character_ )
                        # str_replace_all(c("€"="","\\."="")) %>% 
                        # str_extract( "\\-*\\d+\\.*\\d*") %>% 
                        # str_replace_na() %>%
                        # str_replace("NA", 'Prezzo Su Richiesta')
            return(parse_html)
} 

