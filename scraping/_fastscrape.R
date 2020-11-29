## [ fastscrape ] ----
## first endpoint function 
options(future.rng.onMisuse="ignore")

## posso renderla ancora più velcoe se cerco il JSON
## 
## makechunk


fastscrape = function(npages_vec){
            tic()
            result = tibble(
                        
                        ## anche approccio con invoke_map() ma un po' troppo under the hood
                        title =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                    scrapetitle_imm(session = sesh)},NA_character_, quiet = FALSE)) %>% flatten_chr(),
                        
                        monthlyprice =  future_map(npages_vec, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                    scrapeprice_imm(session = sesh) },NA_character_, quiet = FALSE))%>% flatten_chr(),
                        
                        nroom =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                    scraperooms_imm(session = sesh) },NA_character_, quiet = FALSE))%>% flatten_chr(),
                        
                        sqmeter =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                    scrapespace_imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        href =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                    scrapehref_imm(session = sesh) },NA_character_, quiet = FALSE))%>% flatten_chr()
                        
            )
            
            toc()
            return(result) %>% 
                        # tidyr::unnest(cols = c(title, monthlyprice, nroom, sqmeter, href)) %>% 
                        mutate(pk = str_extract(href, '\\d+'))

}
