#########################################
###### [ Totale Piani Edificio  ] #######
#########################################
#
# valutare se togliere la partola piani
#
# ex. out:
# "4 piani"
# "5 piani"
# 

scrapetotpiani.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim()
  
  
  if ("totale piani edificio" %in% web) {
    pos = match("totale piani edificio",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}
