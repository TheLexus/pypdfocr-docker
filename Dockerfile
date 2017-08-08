FROM ubuntu:latest

ENV PDFOCR_BASEPATH /srv
ENV T_LANG deu

RUN set -x \
	&& apt-get update && apt-get install -y locales python python-pip tesseract-ocr tesseract-ocr-${T_LANG} ghostscript imagemagick poppler-utils\
	&& pip install pypdfocr \
	&& apt-get purge -y --auto-remove
	
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
	
WORKDIR /
COPY pypdfocr.conf /etc

VOLUME ${PDFOCR_BASEPATH}/documents ${PDFOCR_BASEPATH}/pdfinput
#CMD ["/usr/local/bin/pypdfocr","-l","${T_LANG}","-w","${PDFOCR_BASEPATH}/pdfinput","-f","-c","/etc/pypdfocr.conf","-n"]
CMD ["/bin/bash"]
