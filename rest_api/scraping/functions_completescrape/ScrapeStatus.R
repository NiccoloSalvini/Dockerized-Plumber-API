
# qui prendo lo stato (potresti dividere in due status e condizioni edificio)
# 
# ex out: 
# "Ottimo / Ristrutturato"
# "Da ristrutturare"

scrapestatus.imm = function(session) {

  web = read_html(session)
  cssquery = web %>% 
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  if ("stato" %in% cssquery) {
    pos = match("stato",cssquery)
    return(cssquery[pos+1])
  } else {
    json = web %>%
      html_nodes(xpath = "/html/body/script[2]") %>% 
      html_text() %>%
      fromJSON()
    status =  json$listing$properties$condition
    return(status)
  }
  
}
