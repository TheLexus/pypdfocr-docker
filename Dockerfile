FROM ubuntu:latest

ENV PDFOCR_CONFIG /etc/pypdfocr.conf
ENV PDFOCR_BASEPATH /srv
ENV PDFOCR_ARGS "-l ${T_LANG} -w ${PDFOCR_BASEPATH}/pdfinput -f -c ${PDFOCR_CONFIG} -n"
ENV T_LANG deu

RUN sh -c "set -x \
	&& apt-get update && apt-get install -y locales python python-pip tesseract-ocr tesseract-ocr-${T_LANG} ghostscript imagemagick poppler-utils\
	&& pip install pypdfocr \
	&& apt-get purge -y --auto-remove"
	
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
	
WORKDIR /
COPY pypdfocr.conf ${PDFOCR_CONFIG}

VOLUME ${PDFOCR_BASEPATH}/documents ${PDFOCR_BASEPATH}/pdfinput
CMD ["sh","-c","/usr/local/bin/pypdfocr ${PDFOCR_ARGS}"]
#CMD ["/bin/bash"]
