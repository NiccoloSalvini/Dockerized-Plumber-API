###########################
###### [ nroooms  ] #######
###########################
#
# qui prendo il numero delle stanze 
# anche qui lo prendo sia all'esterno ceh all'interno
# sia con scrape.all chr con scrape.all.info
# 
# dalla mia esperienza la funzione non fallisce mai
# visto che tutto può mancare fuorchè la grandezza
# della casa
# 
# at first searched in the top span 
# then it searches in the table
# if both are not found an NA is thrown
# 
# 
# reprex:
# "3"
# "2"


#   ".im-mainFeatures__price+ .nd-list__item .im-mainFeatures__value"

scrapenroomsINS.imm = function(session) {
  
  opensess = read_html(session)
  nroom  = opensess %>% 
    html_nodes(css =".im-mainFeatures__price+ .nd-list__item .im-mainFeatures__value") %>% 
    html_text() %>%
    str_trim() 
  
  if(is.null(nroom) || identical(nroom, character(0))) {
    nroom2 = opensess %>%
      html_nodes(css ='.im-features__value , .im-features__title') %>% 
      html_text() %>%
      str_trim()
      
    if ("locali" %in% nroom2) {
      pos = match("locali",nroom2)
      return(nroom2[pos+1])  %>% 
        str_extract("[0-9]+")
    } else {
      return(NA_character_)
    }
  } else {
    return(nroom)
    
  }

}
