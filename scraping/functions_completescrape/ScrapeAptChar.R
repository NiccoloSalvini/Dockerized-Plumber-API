# Here I pick up the char of the apt
# 
# ex. out:
# "- - Cancello elettrico- - - Fibra ottica- - - Porta blindata- - - Esposizione interna- 
# - - Balcone- - - Portiere intera giornata- - - Impianto tv centralizzato- - - Arredato- 
# - - Giardino comune- - - Infissi esterni in doppio vetro / legno- -"
# 
# "- - Cancello elettrico- - - Fibra ottica- - - Porta blindata- - - Armadio a muro- - - Balcone- 
# - - Portiere mezza giornata- - - Impianto tv centralizzato- - - Arredato- - - Cantina- -
#  - Infissi esterni in triplo vetro / metallo- - - Esposizione doppia- -"
# 

scrapeaptchar.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>% 
    str_replace_all('\\n','-') %>%
    unique() %>% 
    str_squish() %>% 
    tolower() 
  
  
  if ("altre caratteristiche" %in% web) {
    pos = match("altre caratteristiche",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}
