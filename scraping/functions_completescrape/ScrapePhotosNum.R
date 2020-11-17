# here i take the photos 
# 
# 
# discutiamone se numerica o no 
# 
# ex. out: 
# [1] 17
# [1] 9


scrapephotosnum.imm = function(session){

  
  web = read_html(session) %>% 
    html_nodes(css = '.js-tab-media')  %>% 
    html_text(trim = T) %>% 
    str_squish() %>% 
    str_extract("[0-9]+")
  
    # as.numeric()
    
  return(web)
}
