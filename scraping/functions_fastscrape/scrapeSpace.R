## Scrape the space -----
## scrape the square meter footage of the house 

scrapespace_imm = function(session){
            
            web = read_html(session) %>% 
                        html_nodes(css = '.lif__item:nth-child(3) .text-bold') %>% 
                        html_text()
            return(web)
}
