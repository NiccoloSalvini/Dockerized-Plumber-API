# here I scrape the house description given
# by the real estate agent
# 
# it gives back a string of text, #FeatureHashing
# #TextMining #WordCloud 
# 
# ex. out: 
# "Missori - Nella splendida cornice di Piazza Erculea, proponiamo luminoso appartamento con silenzioso 
# affaccio sulla Piazza e ampio box singolo compreso nel prezzo. L'abitazione è situata al primo piano 
# di un signorile stabile con portineria e ascensore ed è composta da doppi ingressi, salone doppio con
# balcone, cucina abitabile con secondo balcone, disimpegno, due ampie camere matrimoniali, bagno di
# servizio e bagno padronale, oltre ad una cantina e ad un comodo box singolo situato al piano terra
# dello stabile. Questa abitazione si presta alla realizzazione di una terza camera da letto o al
# frazionamento in due distinte unità . Piazza Erculea vanta una posizione strategica, riparata dal 
# traffico cittadino ma comodissima per la fermata della metro gialla Missori e servita dai numerosi 
# mezzi di superficie. Libero da ottobre 2020."
# 

scrapehousetxtdes.imm = function(session) {
  
  text = read_html(session) %>%
    html_nodes(css ='.js-readAllText') %>% 
    html_text() %>%
    str_trim() %>% 
    str_squish()
  
  return(text)
}
