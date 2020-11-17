# qui prendo il tipo di proprietà
# 
# out ex:
# "Intera proprietà, classe immobile signorile"
# "Intera proprietà, classe immobile media"

scrapeproptype.imm = function(session) {

  json = read_html(session) %>% 
    html_nodes(xpath = "/html/body/script[2]") %>% 
    html_text() %>%
    fromJSON()
  
  
  propcat = json$listing$properties$category$name
  if (is.na(propcat) || is.null(propcat)) {
    tibble(
      propcat = NA_character_
      
    ) %>% 
      return()
  } else {
    tibble(propcat = propcat) %>% 
      return()
  }
  
  # if ("Tipo propriet" %in% web) {
  #   pos = match("Tipo propriet",web)
  #   return(web[pos+1])
  # } else {
  #   return(NA_character_)
  # }

  
}
