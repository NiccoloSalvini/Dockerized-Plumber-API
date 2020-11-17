## [ fastscrape ] ----
## first endpoint function 
options(future.rng.onMisuse="ignore")
scrape = function(npages_vec){
            tic()
            suppressWarnings(plan(multisession, workers = availableCores())) ## sviluppa strategia
            result = tibble(
                        title =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    scrapetitle_imm(session = sesh)},NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        monthlyprice =  future_map(npages_vec, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    scrapeprice_imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        nroom =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    scraperooms_imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        sqmeter =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    scrapespace_imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        href =  future_map(npages_vec, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    scrapehref_imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr()
                        
            )
            
            toc()
            return(result)

            

}
