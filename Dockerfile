
############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM debian:latest

# File Author / Maintainer
MAINTAINER Christian Greweling

#Create a dedicated Opencast user.
RUN useradd -d /home/opencast opencast

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/stretch-backports.list

RUN apt-get update

RUN apt-get install -y -t \
    stretch-backports \
    openjdk-8-jre

#Install some Packages
RUN apt-get install -y \
  tar \
  curl \
  wget \
  apt-transport-https \
  ca-certificates \
  gnupg \
  gnupg1 \
  gnupg2



#Install Repo 
WORKDIR /etc/apt/sources.list.d/
RUN echo "deb https://[USERNAME]:[PASSWORD]@pkg.opencast.org/debian stable/" | tee /etc/apt/sources.list.d/opencast.list
RUN wget -qO - https://pkg.opencast.org/gpgkeys/opencast-deb.key | apt-key add -

RUN apt-get update
# Install Apache ActiveMQ
RUN apt-get install -y activemq-dist



RUN apt-get -y install \
    bzip2 \
    ffmpeg-dist \
    activemq-dist \
    tesseract-ocr \
    hunspell \
    openjdk-8-jre

RUN apt-get -y install opencast-4-allinone


#Make Opencast accesible outsite of the image
RUN sed -i s/'org.ops4j.pax.web.listening.addresses'/'#org.ops4j.pax.web.listening.addresses'/ /etc/opencast/org.ops4j.pax.web.cfg


#copy startscript
COPY startOpencast.sh /opt/opencast/


#Compile Opencast
RUN chown -R opencast:opencast /opt/opencast
#Port 8080
EXPOSE 8080
EXPOSE 61616

#ENTRYPOINT /opt/opencast/startOpencast.sh
