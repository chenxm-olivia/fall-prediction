FROM rocker/rstudio:latest
RUN R -e "install.packages(c('tidyverse','haven','tableone','glmnet','pROC','markdown'))"
# Install system dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common
# Add Git and Git LFS repositories and install them
RUN add-apt-repository ppa:git-core/ppa && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y git git-lfs
