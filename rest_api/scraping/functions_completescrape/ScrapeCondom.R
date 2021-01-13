# here i take the condominium, which is a crucial cost 
# to take into account, sorry for the function name :)
# 
# ex. out: 
# "130"
# "180"

scrapecondom.imm = function(session) {

  
  web = read_html(session)
  
  cssquery = web %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_squish() %>% 
    str_trim()
  
  if ("spese condominio" %in% cssquery) {
    pos = match("spese condominio",cssquery)
    condom = cssquery[pos+1] 
    return(condom) %>%  
      str_extract("[0-9]+")
  } else {
    
    json = web %>%
      html_nodes(xpath = "/html/body/script[2]") %>%
      html_text() %>%
      fromJSON()
    condom = json$listing$properties$costs$condominiumExpensesValue
    if(is.null(condom)){
      return(NA_character_)
      } else {
      return(condom)
    }
  }
}
