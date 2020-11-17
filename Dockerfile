FROM rocker/tidyverse:latest

MAINTAINER Niccolo Salvini "niccolo.salvini27@gmail.com"

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev

# install R packages
RUN R -e "install.packages(c('magrittr','lubridate', 'plumber', 'rvest', 'stringi', 'jsonlite', 'here', 'purrr', 'mongolite', 'tictoc', 'future', 'here',  'parallel', 'furrr','glue'), dependencies = TRUE)"

# install 'iterators' dep for DoParallel
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/iterators/iterators_1.0.10.tar.gz', repos=NULL, type='source')"

# install 'foreach' dep for DoParallel
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/foreach/foreach_1.4.8.tar.gz', repos=NULL, type='source')"

# install DoParallel from source since not avail in 4.0.2
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/doParallel/doParallel_1.0.14.tar.gz', repos=NULL, type='source')"

COPY / /

# expose port
EXPOSE 8000

ENTRYPOINT ["Rscript", "main.R"]