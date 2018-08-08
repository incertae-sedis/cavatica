FROM ubuntu:18.04

	RUN apt-get -y update && apt-get install -y git
#	RUN git clone -b docker_implementation https://github.com/TeamMango/cavatica.git
	RUN git clone https://github.com/incertae-sedis/cavatica.git
	RUN DEBIAN_FRONTEND=noninteractive apt-get install -y r-base && echo "install.packages(\"ggplot2\", repos=\"https://cran.rstudio.com\")" | R --no-save && echo "install.packages(\"readr\", repos=\"https://cran.rstudio.com\")" | R --no-save
	WORKDIR /cavatica/data/output 
	ENV PATH=/:$PATH
#	CMD ["ln -s cavatica/data/test/*.tsv ."]
	CMD ls
	CMD ["../../code/script.sh"]
		
	LABEL author="Jennifer Chang"
	LABEL title="Cavatica: A pipeline for identifying author adoption trends among software or methods"
	LABEL doi="10.1109/BIBM.2017.8217990"
	LABEL last-update="2018-07-25"


	
