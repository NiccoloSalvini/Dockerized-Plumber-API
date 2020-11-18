# It takes the ad's title, and actually gets the address
# singolo = 'https://www.immobiliare.it/annunci/78398083/'
# 
# ex. out: 
# [1] "piazza Erculea 5"
# [1] "via Piero della Francesca 51"
# 
# 
# da questo puoi prendere la categoria della casa
# - Monolocale
# - Bilocale
# - Quadrilocale
# Cosa che per il momento ho escluso perchè non sempre
# nel titolo p specificata la categoria, spesso viene 
# accompagnata da "Splendido Bilocale", difficile differenziarla
# 
# c'è un altro modo per farla in un altro nodo
# non so se mi conviene stravolgerlo 
# visto che nell'altro modo non compare il civico 
# mentre nel primo s
# 
# ì, quindi sotto la scrivo per 
# completezza ma non penso di applicarlo, prende meno linee di codice 
# di sicuro 



take_spatialJSON = function(session) {
  
  json = read_html(session) %>% 
    html_nodes(xpath = "/html/body/script[2]") %>%
    html_text() %>%
    fromJSON()
  
  spatial = json$listing$properties$location %>%
    tibble() %>%  
    mutate_if(is.character, list(~na_if(., ""))) %>% 
    .[1,]
  
  return(spatial)
} 


take.address = function(session){

  web = read_html(session) %>%
    html_nodes(css = '.im-titleBlock__title') %>%
    html_text() %>% 
    str_replace('Monolocale', '') %>% 
    str_replace('Bilocale', '') %>% 
    str_replace('Trilocale', '') %>% 
    str_replace('Quadrilocale', '') %>% 
    str_replace('Appartamento', '') %>%  
    str_replace('Attico', '') %>%
    str_replace('Mansarda', '') %>% 
    str_replace('Loft', '') %>% 
    str_replace('Milano', '') %>% 
    str_remove("[^\\w\\s]") %>%
    str_trim() %>% 
    tolower()
  
  if (!grepl(web,pattern = "\\d+")) {
    
    civico = take_spatialJSON(session) %>% 
      .$streetNumber
    if (is.na(civico)) {
      civico = "C.A."
    }
    web_n = paste(web,civico)
    return(web_n)
  } else {
    return(web)
    }
}


### altenrative 
take.addressALT = function(session){
  
  web = read_html(session) %>%
    html_nodes(css = ".im-location~ .im-location+ .im-location") %>%
    html_text() %>% 
    .[1]
  
  
  
  if (!grepl(web,pattern = "\\d+")) {
    
    civico = take_spatialJSON(session) %>% 
      .$streetNumber
    if (is.na(civico)) {
      civico = "C.A."
    }
    web_n = paste(web,civico)
    return(web_n)
  } else {
    return(web[1]) %>% 
      str_trim()
  }
}



  
