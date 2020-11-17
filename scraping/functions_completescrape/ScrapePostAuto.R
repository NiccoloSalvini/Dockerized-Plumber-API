##############################
###### [ Posti Auto  ] #######
##############################
#
# valutare se togliere all'esterno
# (ricorda che DB deve essere self explicative
# importante trafsormazioni nel preprocess)
# var molto poco presente 
#
# ex. out:
# "1 all'esterno"
# 

scrapepostauto.imm = function(session) {
  
  posauto = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim()
  
  
  if ("Posti Auto" %in% posauto) {
    pos = match("Posti Auto",posauto)
    return(posauto[pos+1])
  } else {
    return(NA_character_)
  }
  
}
