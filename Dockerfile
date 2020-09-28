# Uses RStudio package 4.0.0 (should be faster) diff
FROM rocker/r-ver:4.0.0

MAINTAINER "Niccolo Salvini" niccolo.salvini27@gmail.com


RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libmariadb-client-lgpl-dev \
  libxml2-dev \
  libudunits2-dev
  

# install R packages
RUN R -e "install.packages('dplyr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tibble',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('plumber',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('magrittr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rvest',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('httr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('stringi',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lubridate',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('jsonlite',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('doParallel',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('stringr',dependencies=TRUE, repos='http://cran.rstudio.com/')"

# exposing the port
EXPOSE 8000

# copy everything from the current directory into the container
COPY / /

# when the container starts, start the main.R script diff
ENTRYPOINT ["R", "-e", \
"r = plumber::plumb('plumber.R'); \
r$run(host = '0.0.0.0', port= 8000)"]

CMD ["/plumber.R"]