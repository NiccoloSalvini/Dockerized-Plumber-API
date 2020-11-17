################################
######## [ DEPRECATED ] ########
################################
#
# ex. out:
# "Libero"
# "Libero"
# (mai visto roba diversa)
# 
# Problema con encoding, prende accenti e manda
# tutto a puttane, quindi prendo json


scrapedisp.imm = function(session) {
  
  web = read_html(session) %>% 
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim() %>% 
    str_squish()
  
  if ("disponibilità" %in% web) {
    pos = match("disponibilità",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
    }
  
}