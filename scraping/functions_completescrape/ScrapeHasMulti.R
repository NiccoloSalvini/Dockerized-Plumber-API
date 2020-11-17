####### [ HAS MULTIMEDIA ]
####### 
#######   it flags if the ad has multimedia displayed
#######   


scrapehasmulti.imm = function(session) {
  
  json = read_html(session) %>% 
    html_nodes(xpath = "/html/body/script[2]") %>% 
    html_text() %>%
    fromJSON()
  
  hasmultimedia = json$listing$properties$multimedia$hasMultimedia
  
  return(hasmultimedia)
}
