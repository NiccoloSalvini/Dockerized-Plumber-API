GuardaDip = function(pkg) {
            API = "https://sysreqs.r-hub.io/pkg"
            content = httr::GET(paste0(API,"/",pkg)) %>% 
                        httr::content() %>%
                        chuck(1) %>% 
                        pluck(1)
            
            return(content)
}
