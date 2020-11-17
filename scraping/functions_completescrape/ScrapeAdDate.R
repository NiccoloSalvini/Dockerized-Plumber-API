# qui prendo la data dell'annuncio
# 
# ex. out: (lubridate class Date)

scrapeaddate.imm = function(session) {
  
  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  
  if ("riferimento e Data annuncio" %in% web) {
    pos = match("riferimento e Data annuncio",web)
    web[pos+1] %>% 
      str_sub(start =-10) %>%
      lubridate::dmy() %>% 
      return()
      
  } else {
    return(NA_character_)
  }
  
}


