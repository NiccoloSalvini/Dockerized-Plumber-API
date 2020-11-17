#############################
###### [ Scrape LAT  ] #######
#############################
#
# dependecies: jsonlite
# 
# ex. out: (as.numeric)
# [1] 45.4582
# [1] 45.4668


scrapelat.imm = function(session){

  web = read_html(session) %>% 
    html_nodes(xpath = '//*[@id="js-hydration"]') %>% 
    html_text() %>% 
    fromJSON()
  lat = web$listing$properties$location$latitude
  return(lat)
}
