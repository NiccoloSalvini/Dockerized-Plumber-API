# qui prendo l'aria condizionata 
# 
# ex. out: 
# "Autonomo, freddo/caldo"
# "Autonomo, freddo"

scrapeaircondit.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  if ("Climatizzazione" %in% web) {
    pos = match("Climatizzazione",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}
