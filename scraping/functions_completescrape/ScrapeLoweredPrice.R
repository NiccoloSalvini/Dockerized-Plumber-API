scrapeloweredprice.imm = function(session) {
  
  json = read_html(session) %>% 
    html_nodes(xpath = "/html/body/script[2]") %>% 
    html_text() %>%
    fromJSON()
  
  lowprice = json$listing$properties$price$loweredPrice
  if (is.na(lowprice) || is.null(lowprice)) {
    tibble(
      originalPrice =NA_character_,
      currentPrice  = NA_character_,
      passedDays = NA_character_,
      date = NA_character_,
      
    ) %>% 
      return()
  } else {
    originalPrice =lowprice$originalPrice
    currentPrice  = lowprice$currentPrice
    passedDays = lowprice$passedDays
    date = lowprice$passedDays
    
    tibble(
      originalPrice,
      currentPrice,
      passedDays,
      date
    ) %>%  
      mutate_all(as.character) %>% 
      return()
  }
}
