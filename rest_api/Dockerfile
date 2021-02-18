
FROM rocker/tidyverse:latest

MAINTAINER Niccolo Salvini "niccolo.salvini27@gmail.com"

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev

# install R packages
RUN R -e "install.packages(c('plumber', 'rvest' , 'janitor' , 'stringi', 'tidyjson', 'here', 'tictoc', 'future', 'furrr', 'robotstxt' ), dependencies = TRUE)"

COPY /scraping    /scraping

WORKDIR /scraping

# make all app files readable, gives rwe permisssion (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /scraping

# expose port
EXPOSE "8000"

ENTRYPOINT ["Rscript", "/scraping/main.R"]