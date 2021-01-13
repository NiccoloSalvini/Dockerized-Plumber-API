### qui si prendono le metreature 
### della casa stanza per stanza
### 
### questa prende 4 colonne e se non
### le trova per via di una mancanza  in JSON
### allora le setta uguali a
###



scrapemetrature.imm = function(session) {
  
  json = read_html(session) %>% 
    html_nodes(xpath = "/html/body/script[2]") %>% 
    html_text() %>%
    fromJSON()
  

  metrature = json$listing$properties$surfaceConstitution %>% 
    tibble() %>%
    unnest_wider(col = surfaceConstitutionElements) %>%  
    mutate_all(as.character) 
    

  if(!identical(dim(metrature), as.integer(c(1,8)))){
    constitution  = NA_character_
    floor =NA_character_
    surface =NA_character_
    percentage =NA_character_
    metrature1 = tibble(constitution,floor,surface,percentage)
    return(metrature1)

    } else {
    return(metrature) %>%  
        select(constitution:percentage)
    }
  
  
}
