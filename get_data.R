## [ get_data ] ----
## first endpoint function 
options(future.rng.onMisuse="ignore")

get_data = function(links) {
            
            date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
            filename = paste0('shared-data/imm-',date,'.csv')
            all = completescrape2(links)
            
            url_path  = "mongodb+srv://salvini:mucrini27@cluster0.qs3zp.mongodb.net/api-immobiliare?retryWrites=true&w=majority"
            db = mongo(
                        collection = "test",
                        db = "api-immobiliare",
                        url = url_path,
                        verbose = TRUE,
            )
            db$insert(all)
            
}