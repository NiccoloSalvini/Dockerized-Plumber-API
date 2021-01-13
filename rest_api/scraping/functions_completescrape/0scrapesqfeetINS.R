###########################
###### [ sqfeet  ] ########
###########################
#
#qui prendo la metratura quadrata
# 
# qui è possibile che non sia specificato 
# anche se mooolto spesso c'è
# 
# at first searched in the top span 
# then it searches in the table
# if both are not found an NA is thrown
# 
# 
# reprex:
# "3"
# "2"


#   ".im-mainFeatures__price+ .nd-list__item .im-mainFeatures__value"

scrapesqfeetINS.imm = function(session) {
  
  opensess = read_html(session)
  sqfeet  = opensess %>% 
    html_nodes(css =".nd-list__item:nth-child(3) .im-mainFeatures__value") %>% 
    html_text() %>%
    str_trim() 
  
  if(is.null(sqfeet) || identical(sqfeet, character(0))) {
    sqfeet2 = opensess %>%
      html_nodes(css ='.im-features__value , .im-features__title') %>% 
      html_text() %>%
      str_trim()
    
    if ("superficie" %in% sqfeet2) {
      pos = match("superficie",sqfeet2)
      return(sqfeet2[pos+1])  %>% 
        str_extract("[0-9]+")
    } else {
      return(NA_character_)
    }
  } else {
    return(sqfeet) %>%  
      str_extract("[0-9]+")
    
  }
  
}
