#####################################
###### [ Prezzo dentro adv  ] #######
#####################################
#
# Qui prendo il prezzi dentro l'ad perche voglio rendere 
# scrape all info autosufficiente, probabilmente joinare dopo
# sulla primary non conviene per nulla
#
# reprex: 
# "2450"
# "1700"
#


scrapepriceINS.imm = function(session) {
  
  tabella = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim()
  
  
  if ("prezzo" %in% tabella) {
    pos = match("prezzo",tabella)
    return(tabella[pos+1]) %>% 
      str_replace_all(c("€"="","\\."="")) %>% 
      str_extract( "\\-*\\d+\\.*\\d*") %>%  
      str_replace_na() %>% 
      str_replace("NA", "Prezzo Su Richiesta")
  } else { 
    return(NA_character_)
  }
  
}
scrapepriceINS.imm = function(session) {
  
  opensess = read_html(session)
  price  = opensess %>% 
    html_nodes(css =".im-mainFeatures__title") %>% 
    html_text(trim = T) 
  
  if(is.null(price) || identical(price, character(0))) {
    price2 = opensess %>%
      html_nodes(css ='.im-features__value , .im-features__title') %>% 
      html_text(trim = T)
    
    if ("prezzo" %in% price2) {
      pos = match("prezzo",price2)
      return(price2[pos+1])  %>% 
        str_replace_all(c("€"="","\\."="")) %>% 
        str_extract( "\\-*\\d+\\.*\\d*") %>%  
        str_replace_na() %>% 
        str_replace("NA", "Prezzo Su Richiesta")
    } else {
      return(NA_character_)
    }
  } else {
    return(price) %>% 
      str_replace_all(c("€"="","\\."="")) %>% 
      str_extract( "\\-*\\d+\\.*\\d*") %>%  
      str_replace_na() %>% 
      str_replace("NA", "Prezzo Su Richiesta")
      
  }
  
}
