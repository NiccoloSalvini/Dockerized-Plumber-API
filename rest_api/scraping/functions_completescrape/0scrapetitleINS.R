###########################
###### [ sqfeet  ] ########
###########################
#
# qui prendo il titolo dell'annuncio, per prendere
# l'indirizzo c'è la funzione take.address
# la funzione è molto semplice, va dritta alla css query 
# senza exit chances
# 
# reprex:
# [1] "Trilocale via Podgora, Milano" 
# [1] "Trilocale via ANTONIO KRAMER  20, Milano"
# [1] "Bilocale via Aleardo Aleardi, Milano"


scrapetitleINS.imm = function(session) {
  
  opensess = read_html(session)
  title  = opensess %>% 
    html_nodes(css =".im-titleBlock__title") %>% 
    html_text() %>%
    str_trim()
  return(title)
  
}
