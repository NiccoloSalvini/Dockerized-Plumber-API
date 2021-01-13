#############################
###### [ Scrape LONG ] ######
#############################
#
# dependecies: jsonlite
# 
# ex. out: (as.numeric)
# [1] 9.2079
# [1] 9.1653


scrapelong.imm = function(session){

  web = read_html(session) %>% 
    html_nodes(xpath = '//*[@id="js-hydration"]') %>% 
    html_text() %>% 
    fromJSON()
  long = web$listing$properties$location$longitude
  return(long)
}
