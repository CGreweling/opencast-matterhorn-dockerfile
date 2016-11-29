############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM centos:latest

# File Author / Maintainer
MAINTAINER Christian Greweling
RUN yum install -y \
  tar\
  bzip2\
  wget

## RHEL/CentOS 7 64-Bit ##
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
RUN rpm -ivh epel-release-7-8.noarch.rpm


#ADD Opencast Repository
WORKDIR /etc/yum.repos.d
RUN curl -O https://pkg.opencast.org/opencast.repo -d os=el -d version=7 -u [your_username]:[password]
RUN yum update -y

RUN yum install -y \
    ffmpeg \
    activemq \
    maven \
    openjdk-8-jdk\
    tesseract\
    hunspell\
    sox \
    activemq-dist

# Install Opencast
RUN yum install -y\
    opencast22-allinone

# copy activemq
  RUN cp /usr/share/opencast/docs/scripts/activemq/activemq.xml /etc/activemq/activemq.xml

# make Opencast accessable
RUN sed -i -e 's/org.ops4j.pax.web.listening.addresses=127.0.0.1/#org.ops4j.pax.web.listening.addresses=127.0.0.1/g' /etc/opencast/custom.properties

#Port 8080
EXPOSE 8080
