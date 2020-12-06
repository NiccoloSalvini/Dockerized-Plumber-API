## [ completescrape ] ----
## It scrapes the complete set of information avail on each ad link
options(future.rng.onMisuse="ignore")

## integrare POSSIBLY QUI DENTRO
## 

completescrapeJSON = function(session_response) {
            
            json_list = session_response %>% 
                        read_html() %>% 
                        html_nodes(xpath = "/html/body/script[2]/text()") %>%
                        html_text() %>%  
                        jsonlite::fromJSON() %>%  
                        pluck("listing") 
            
            properties = json_list %>%
                        pluck("properties") %>% 
                        as_tibble(.name_repair = "unique") 
            
            ## qui AGENCY avere più di un valore il flatten() non va bene  ----
            ## occhio qua a non avere doppio numero di telefono

            agency = json_list %>%
                        pluck("advertiser", "agency") %>% 
                        map(FromNUllToNA) %>% 
                        as_tibble() %>%
                        mutate_if(is_logical, as.character) %>%
                        mutate_if(is_list, as.character) %>% 
                        slice(1)
            
            if(is_empty(agency)){
                        
                        agency = as_tibble_row(c("id" = 22 ,"type" = "privato","customType" = NA_character_,
                                                "label" = NA_character_,"displayName" = NA_character_,"imageUrl" = NA_character_,
                                                "agencyUrl" = NA_character_,"phones" = NA_character_,"externalLinks" = NA_character_,
                                                "text" = NA_character_,"track" = NA_character_,"guaranteed" = NA_character_,
                                                "isPaid" = NA_character_)) %>% 
                                    mutate(id = as.integer(id)) %>%
                                    mutate(guaranteed = as.logical(guaranteed),
                                           isPaid  = as.logical(guaranteed))

            }
            
            
            # agency_supervisor = json_list[["advertiser"]][["supervisor"]]

            contract = json_list %>%
                        pluck("contract")%>%
                        as_tibble_row() %>% 
                        rename(contract_type = type,
                               contract_value = value) %>% 
                        select(-starts_with("name"))
            
            ## title ----
            title_apt = json_list %>% 
                        pluck("title", .default = NA_character_) %>% 
                        as_tibble_col(column_name = "title_apt") 
            
            ## id ----
            id_apt = json_list %>%
                        pluck("id", .default = NA_character_) %>% 
                        as_tibble_col(column_name = "id_apt")
            
            result_df = bind_cols(properties, agency, title_apt,id_apt, contract)
            return(result_df)
}

completescrape3 = function(links){
            
            tic()
            result =future_map(links, possibly( ~{
                                 prova =  sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    suppressMessages(completescrapeJSON(session = sesh))},NA_character_, quiet = FALSE))
            toc()
            return(result %>%  map_dfr(bind_rows) %>%  janitor::clean_names())
            
}

######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
# 
# 
# 
# json_list = links[29] %>%
#             read_html() %>%
#             html_nodes(xpath = "/html/body/script[2]/text()") %>%
#             html_text() %>%
#             jsonlite::fromJSON() %>%
#             pluck("listing")
# 
# properties = json_list %>%
#             pluck("properties") %>%
#             as_tibble(.name_repair = "unique")
# 
# repair_miss = function(x) {x$id = 22,
#                            x$type = "privato",
#                            x$customType = NA_character_,
#                            x$label = NA_character_,
#                            x$displayName = NA_character_,
#                            x$imageUrl = NA_character_,
#                            x$agencyUrl = NA_character_,
#                            x$phones = NA_character_,
#                            x$externalLinks = NA_character_,
#                            x$text = NA_character_,
#                            x$track = NA_character_,
#                            x$guaranteed = NA_character_,
#                            x$isPaid =NA_character_
# }
# my_element <- function(x) x[[2]]$elt
# 
# 
# repair_miss = function() {
#             list("id_age" = 22 ,"agency_type" = "privato","customType" = NA_character_,
#                                 "label" = NA_character_,"displayName" = NA_character_,"imageUrl" = NA_character_,
#                                 "agencyUrl" = NA_character_,"externalLinks" = NA_character_,
#                                 "text" = NA_character_,"track" = NA_character_,"guaranteed" = NA_character_,
#                                 "isPaid" = NA_character_)
# }
# 

## qui AGENCY avere più di un valore il flatten() non va bene  ----
## occhio qua a non avere doppio numero di telefono

# agency2 = json_list %>%
#             pluck("advertiser", "agency")
#             map(FromNUllToNA) %>%
#             as_tibble() %>% 
#             mutate_if(is_logical, as.character)

# if(!is_empty(agency)){
#             rename(agency,
#                    agency_type = type,
#                    id_age = id
#                    ) %>%
#                         select(-starts_with("phones"))
# } else {
#             agency = as_tibble_row(c("id_age" = 22 ,"agency_type" = "privato","customType" = NA_character_,
#                                  "label" = NA_character_,"displayName" = NA_character_,"imageUrl" = NA_character_,
#                                  "agencyUrl" = NA_character_,"externalLinks" = NA_character_,
#                                  "text" = NA_character_,"track" = NA_character_,"guaranteed" = NA_character_,
#                                  "isPaid" = NA_character_)) %>%
#             mutate(id = as.integer(id)) %>%
#             mutate(guaranteed = as.logical(guaranteed),
#                    isPaid  = as.logical(guaranteed))
#             
# }


# agency_supervisor = json_list[["advertiser"]][["supervisor"]]

# contract = json_list %>%
#             pluck("contract")%>%
#             as_tibble_row() %>%
#             rename(contract_type = type,
#                    contract_value = value) %>%
#             select(-starts_with("name"))
# 
# ## title ----
# title_apt = json_list %>%
#             pluck("title", .default = NA_character_) %>%
#             as_tibble_col(column_name = "title_apt")
# 
# ## id ----
# id_apt = json_list %>%
#             pluck("id", .default = NA_character_) %>%
#             as_tibble_col(column_name = "id_apt")
# 
# result_df = bind_cols(properties, title_apt,id_apt, contract)

