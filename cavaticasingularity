Bootstrap: docker
From: ubuntu
%files
    libpng12-0_1.2.54-1ubuntu1.1_amd64.deb 
    Mango /usr/bin
%post
    apt-get -y update
    apt-get install -y git
    apt-get install -y libglu1-mesa
    apt-get install -y ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
    apt-get install -y libgtk2.0-0
    git clone -b singularity_implementation https://github.com/TeamMango/cavatica.git
    chmod -R go+rw /cavatica/ 
    DEBIAN_FRONTEND=noninteractive apt-get install -y r-base 
    echo "install.packages(\"ggplot2\", repos=\"https://cran.rstudio.com\")" | R --no-save
    echo "install.packages(\"readr\", repos=\"https://cran.rstudio.com\")" | R --no-save
%runscript    
    cd /cavatica/data/output
    ln -s ../test/*.tsv .
    ../../code/script.sh
    find /cavatica/data/output -type l | xargs rm
%environment
    export PATH=/:$PATH
