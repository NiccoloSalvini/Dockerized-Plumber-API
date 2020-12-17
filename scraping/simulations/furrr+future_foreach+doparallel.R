## first run plumber$run() or load packages vec_pacchetti
library(ggplot2)
library(furrr)
library(patchwork)

sourceEntireFolder("functions_url") ## for scrapehref_imm




theme_nicco = function (base_size = 11, base_family = "") {
            theme_bw() %+replace% 
                        theme(
                                    text = element_text(family = "sans", size = 12),
                                    plot.title = element_text(face = "bold", size = 14, margin=margin(0,0,30,0)),
                                    panel.background  = element_blank(),
                                    axis.ticks = element_line(colour = "grey70", size = 0.2),
                                    plot.background = element_rect(fill="white", colour=NA),
                                    panel.border = element_rect(linetype = "blank", fill = NA),
                                    legend.background = element_rect(fill="transparent", colour=NA),
                                    legend.key = element_rect(fill="transparent", colour=NA)
                        )
}


## [ REPLICATE furrr ] ----
## plot1
npages_vec = get_link(npages = 100, city = "milano", type = "affitto")
links =  future_map(npages_vec, possibly( ~{
            sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
            scrapehref_imm(session = sesh) },NA_character_, quiet = FALSE)) %>%  flatten_chr()

fastscrape2_mod = function(npages_vec){
            result =  future_map(npages_vec, possibly( ~{
                        sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                        scraperjson(session = sesh)},NA_character_, quiet = FALSE)) 
            print(result) %>%  dplyr::bind_rows()
}


furrr_options(seed = TRUE, scheduling = 2L) 
plan(multisession, workers = parallel::detectCores(logical = FALSE))
df_plot2_furrr= replicate(20, {tm1 = system.time({fastscrape2_mod(npages_vec = npages_vec)})}) 
plan(sequential)

df_plot2_furrr = df_plot2_furrr %>% 
            t() %>% 
            as_tibble() 

furrr1 = ggplot(df_plot2_furrr, aes(x = 1:20, y = elapsed))+
            geom_point() +
            geom_line() +
            expand_limits(y = 10) +
            geom_smooth(method = "lm")+
            labs(x = "# of simulations",
                 y = "time elapsed (seconds)",
            title = "Run time Parallel scraping simulation with furrr+Future")+
            scale_x_continuous(labels = label_ordinal(big.mark = " ", rules = ordinal_english()), n.breaks = 20)+ 
            scale_y_continuous(labels = label_number(suffix = "``"), n.breaks = 10)+ 
            theme_nicco()
furrr1

## [ REPLICATE foreach] ----
## plot1

library(foreach)
library(doFuture)

scrapingfor = function(npages_vec){ 
            result = foreach(i = seq_along(npages_vec),
                             .combine = "bind_rows",
                             .multicombine = TRUE,
                             .verbose = TRUE,
                             .errorhandling='pass') %dopar% {
                                         sesh = html_session(npages_vec[i], user_agent(agent = agents[sample(1)]))
                                         if(sesh$response$status_code==200){invisible()}else{stop(glue("status code: {sesh$response$status_code}"))}
                                         x = scraperjson(sesh)
                             }
            return(result)
            
}

registerDoFuture()
plan(multisession, workers = parallel::detectCores(logical = FALSE))
df_plot2_foreach= replicate(20, {tm1 = system.time({scrapingfor(npages_vec = npages_vec)})}) 
plan(sequential)

df_plot2_foreach = df_plot2_foreach %>% 
            t() %>% 
            as_tibble() 

foreach1 = ggplot(df_plot2_foreach, aes(x = 1:20, y = elapsed))+
            geom_point() +
            geom_line() +
            expand_limits(y = 15) +
            geom_smooth(method = "lm")+
            labs(x = "# of simulations",
                 y = "time elapsed (seconds)",
                 title = "Run time Parallel scraping simulation with foreach+doParallel")+
            scale_x_continuous(labels = label_ordinal(big.mark = " ", rules = ordinal_english()), n.breaks = 20)+ 
            scale_y_continuous(labels = label_number(suffix = "``"), n.breaks = 10)+ 
            theme_nicco()
foreach1



## [ cumsum urls furrr] ----
## plot2


# 
# vettoelaps = c()
# start = c()
# end = c()
# 
# 
# vettoelaps_2 = c()
# start_2 = c()
# end_2 = c()
# 
# 
# 
# vettoelaps_3 = c()
# start_3 = c()
# end_3 = c()
# 



plan(multisession, workers = 12)
assess_sample = sample(npages_vec,80)
for (i in 1:len(assess_sample)) {
            start_3[i] = Sys.time()
            cat("\n\n run iteration",i,"over",len(assess_sample) ,"total\n")
            assess_sample[1:i] %>%furrr::future_map(fastscrape2_mod)
            end_3[i] = Sys.time()
            vettoelaps_3[i] = end_3[i]-start_3[i]
}


plot1_furrr = tibble(start,
                     end,
                     vettoelaps) 

plot2_furrr = tibble(start_2,
                     end_2,
                     vettoelaps_2)

plot3_furrr = tibble(start_3,
                     end_3,
                     vettoelaps_3)




furrr2 = plot1_furrr %>% 
            ggplot(aes(x =1:80)) +
            geom_line(aes(y = vettoelaps), color = "darkred", size = 1.3) +
            geom_line(aes(y = vettoelaps_2), color = "steelblue", size = 1.3) +
            geom_line(aes(y = vettoelaps_3), color = "orange", size = 1.3) +
            expand_limits(y = 12) +
            labs(
                        x = "",
                 y = "time elapsed (seconds)") +
                 # title = "3 simulations for 80 cumulated urls evaluated with furrr+future") +
            scale_x_continuous(labels = scales::unit_format(unit = "url",scale = 1))+
            # scale_x_continuous(labels = label_ordinal(big.mark = " ", rules = ordinal_english()), n.breaks = 20)+ 
            scale_y_continuous(labels = label_number(suffix = "``"), n.breaks = 15)+ 
            theme_nicco()
furrr2




## [ cumsum urls foreach] ----
## plot2

# 
# vettoelaps_foreach = c()
# start_foreach = c()
# end_foreach = c()
# 
# 
# vettoelaps_foreach_2 = c()
# start_foreach_2 = c()
# end_foreach_2 = c()
# 


vettoelaps_foreach_3 = c()
start_foreach_3 = c()
end_foreach_3 = c()






registerDoFuture()
plan(multisession, workers = parallel::detectCores(logical = FALSE))
assess_sample = sample(npages_vec,80)
for (i in 1:len(assess_sample)) {
            start_foreach_3[i] = Sys.time()
            cat("\n\n run iteration",i,"over",len(assess_sample) ,"total\n")
            scrapingfor(npages_vec = assess_sample[1:i])
            end_foreach_3[i] = Sys.time()
            vettoelaps_foreach_3[i] = end_foreach_3[i]-start_foreach_3[i]
}


plot1_foreach = tibble(start_foreach,
                       end_foreach,
                       vettoelaps_foreach) 

plot2_foreach = tibble(start_foreach_2,
                       end_foreach_2,
                     vettoelaps_foreach_2)z

plot3_foreach = tibble(start_foreach_3,
                       end_foreach_3,
                     vettoelaps_foreach_3)





foreach2 = plot1_foreach %>% 
            ggplot(aes(x =1:80)) +
            geom_line(aes(y = vettoelaps_foreach), color = "darkred", size = 1.3) +
            geom_line(aes(y = vettoelaps_foreach_2), color = "steelblue", size = 1.3) +
            geom_line(aes(y = vettoelaps_foreach_3), color = "orange", size = 1.3) +
            stat_smooth(aes(y = vettoelaps_foreach), method = "lm") +
            labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                               "Intercept =",signif(fit$coef[[1]],5 ),
                               " Slope =",signif(fit$coef[[2]], 5),
                               " P =",signif(summary(fit)$coef[2,4], 5)))
            stat_poly_eq(parse=T, aes(label = vettoelaps_foreach), formula=y~x) +
            labs(x = "",
                 y = "time elapsed (seconds)") +
             # title = "3 simulations for 80 cumulated urls evaluated w\ foreach+doParallel") +
            scale_x_continuous(labels = scales::unit_format(unit = "url",scale = 1))+
            # scale_x_continuous(labels = label_ordinal(big.mark = " ", rules = ordinal_english()), n.breaks = 20)+ 
            scale_y_continuous(labels = label_number(suffix = "``"), n.breaks = 15)+ 
            theme_nicco()
foreach2












(furrr1/furrr2) 
            
(foreach1/foreach2)














