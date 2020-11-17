
# qui tira fori i vani 
# 
# 
#################################
#################################
######  QUI DENTRO BAGNO ########
#################################
#################################
### 
### --> prova a tirare fuori il bagno!
### --> prova a fare raffronti con le rooms
### della casa
### 

scrapecompart.imm = function(session) {
  
  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  
  if ("locali" %in% web) {
    pos = match("locali",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }

}
