
# qui prendo informazioni del catasto nell'annuncio
# 
# da qui puoi prendere anche la RENDITA che è buona 
# variabile cosi capiamo quando il comune ci capisce
# di prezzi e affitti
# 
# ex. out:
# "Classe A/3, rendita € 568"
# "Classe A/3, rendita € 679"

scrapecatastinfo.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  
  if ("informazioni catastali" %in% web) {
    pos = match("informazioni catastali",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
}
