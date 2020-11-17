#tipologia : se appartamento villa o altro
#
#
### Ha anche il workaround della parsing json
### se non lo trova, ancora non implementato dentro
### la funzione per non appensatirla (gia messa dentro)
### 
### 
###### [ PRIMO TEST FUNZIONA ] #######

scrapetype.imm = function(session) {

  web = read_html(session)
  cssquery = web %>% 
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  if ("tipologia" %in% cssquery) {
    pos = match("tipologia",cssquery)
    return(cssquery[pos+1])
  } else {
    json = web %>% 
      html_nodes(xpath = "/html/body/script[2]") %>%
      html_text() %>%
      fromJSON()
    
    type =  json$listing$properties$typology$name
    return(type)
  }
} 

