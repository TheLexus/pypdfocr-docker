FROM ubuntu:latest

# configuration
ENV PDFOCR_CONFIG /etc/pypdfocr.conf
ENV PDFOCR_BASEPATH /srv
ENV T_LANG deu

# install software
RUN sh -c "set -x \
	&& apt-get update && apt-get install -y locales python python-pip tesseract-ocr tesseract-ocr-${T_LANG} ghostscript imagemagick poppler-utils\
	&& pip install pypdfocr \
	&& apt-get purge -y --auto-remove"

# setup locales
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# copy orientation data
RUN cp /usr/share/tesseract-ocr/tessdata/${T_LANG}.traineddata /usr/share/tesseract-ocr/tessdata/osd.traineddata

# copy default configuration file
WORKDIR /
COPY pypdfocr.conf ${PDFOCR_CONFIG}

# Patch for regex
COPY regex.patch .
RUN patch -l /usr/local/lib/python2.7/dist-packages/pypdfocr/pypdfocr_pdffiler.py -i regex.patch

# define volumes
VOLUME ${PDFOCR_BASEPATH}/documents ${PDFOCR_BASEPATH}/pdfinput

CMD ["sh","-c","/usr/local/bin/pypdfocr --skip-preprocess -l ${T_LANG} -w ${PDFOCR_BASEPATH}/pdfinput -f -c ${PDFOCR_CONFIG} -n"]
#CMD ["/bin/bash"]
