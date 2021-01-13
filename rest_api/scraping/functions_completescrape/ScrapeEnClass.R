# Here I scarpe the Energy Class
# Vale la pena staccare la lettera che 
# inquadra la classe energetica 
# dalla consumo in  kWh/m²anno
# 
# ex. out:
# "F 189,81 kWh/m²anno"
# "E 126,41 kWh/m²anno"
# 
# 
############################
############################
### stacca Lettera Class ###
############################
############################
                

scrapeenclass.imm = function(session) {
  
  
  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>% 
    str_trim()
  
  if ("Classe energetica" %in% web) {
    pos = match("Classe energetica",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }

}
