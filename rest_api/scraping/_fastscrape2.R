## [ fastscrape ] ----
## first endpoint function
## 
## prossimamente togliere l'obsoleteo
## tidyjson che è ridicolo

# scraperjson = function(session) {
#             result = session %>%
#                         html_nodes(xpath = '//*[@id="js-hydration"]/text()') %>% 
#                         html_text(trim = T) %>%  
#                         jsonlite::fromJSON() %>%
#                         .$ads %>%  
#                         tidyjson::spread_all() %>% 
#                         dplyr::as_tibble() %>% 
#                         select(pk, posizione, dataCreazione, bagni, locali, prezzo, idAgenzia)
#             
#             return(result)
# }



scraperjson = function(session) {
            result = session %>%
                        html_nodes(xpath = '//*[@id="js-hydration"]/text()') %>% 
                        html_text(trim = T) %>%
                        fromJSON() %>%
                        .$ads %>%  
                        tidyjson::spread_all() %>%
                        dplyr::as_tibble() %>%
                        select(pk, posizione, dataCreazione, bagni, locali, prezzo, idAgenzia)
            
            return(result)
}




fastscrape2 = function(npages_vec){
            tic()
            result =  future_map(npages_vec, possibly( ~{
                        sesh = html_session(.x, 
                                            user_agent(agent = agents[sample(1)]),
                                            add_headers("From" = fakemail()))
                                            # "project" = "https://github.com/NiccoloSalvini/Dockerized-Plumber-API",
                                            # "disclaimer" = "I will not distribute neither publish any data I will exclusively
                                            #             use it for my thesis purposes."
                        # if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                        scraperjson(session = sesh)}, NA_character_ , quiet = FALSE)) 
            
            toc()
            result %>%
                        bind_rows() %>% 
                        return()
            
}
