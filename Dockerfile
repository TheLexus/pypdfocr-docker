FROM ubuntu

ENV PDFOCR_BASEPATH /srv
ENV T_LANG deu

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN set -x \
	&& apt-get update && apt-get install -y python python-pip tesseract-ocr tesseract-ocr-${T_LANG} ghostscript imagemagick poppler-utils\
	&& pip install pypdfocr \
	&& mkdir ${PDFOCR_BASEPATH}/pdfinput \
	&& mkdir ${PDFOCR_BASEPATH}/documents \
	&& apt-get purge -y --auto-remove
	
WORKDIR /
COPY pypdfocr.conf /etc

VOLUME ${PDFOCR_BASEPATH}/documents ${PDFOCR_BASEPATH}/pdfinput
CMD ["/usr/local/bin/pypdfocr","-l","${T_LANG}","-w","${PDFOCR_BASEPATH}/pdfinput","-f","-c",/etc/pypdfocr.conf","-n"]

