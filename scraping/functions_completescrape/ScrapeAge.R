# qui prendo l'agenzia, non potevo farlo su per via dei privati 
# 
# --> verifica che quando fetcha 'Privato' 
# lo prenda e non lo missi
# 
# ex. out: 
# "Daniela Ometti Agente Immobiliare"
# "Imperial Real Estate"

scrapeage.imm = function(session){
  
  
  web = read_html(session)
  
  cssquery = web %>%  
    html_nodes(css = ".im-lead__reference p") %>%
    html_text()
  
  if (is.null(cssquery)) {
    json = web %>% 
      html_nodes(xpath = "/html/body/script[2]") %>% 
      html_text() %>%
      fromJSON()
    
    agency = json$listing$advertiser$agency$displayName 
    if (!is.na(agency)) {
      return(agency)
    } else  {
      cssquery = NA
      return(cssquery)
    }
    
  }
  return(cssquery[1])
}
