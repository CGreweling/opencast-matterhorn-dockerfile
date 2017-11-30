
############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM centos:latest

# File Author / Maintainer
MAINTAINER Christian Greweling

#Create a dedicated Opencast user.
RUN useradd -d /home/opencast opencast
#Install some Packages
RUN yum install -y \
  tar \
  curl \
  wget \
  git


#Install Opencast
RUN mkdir /opt/opencast
WORKDIR /opt/opencast/
RUN wget https://bitbucket.org/opencast-community/opencast/downloads/opencast-dist-allinone-3.3.tar.xz
RUN tar -xf opencast-dist-allinone-3.3.tar.xz


RUN curl https://copr.fedorainfracloud.org/coprs/lkiesow/apache-activemq-dist/repo/epel-7/lkiesow-apache-activemq-dist-epel-7.repo -o /etc/yum.repos.d/lkiesow-apache-activemq-dist-epel-7.repo
# Install Apache ActiveMQ
RUN yum install -y activemq-dist


RUN yum update --skip broken && yum -y install epel-release
#ADD usr-sbin-matterhorn /usr/sbin/matterhorn

RUN yum -y install \
    bzip2 \
    ffmpeg \
    which \
    activemq-dist \
    apache-maven \
    tesseract \
    java-1.8.0-openjdk.x86_64 \
    java-1.8.0-openjdk-devel.x86_64

#ops
RUN sed -i s/'org.ops4j.pax.web.listening.addresses'/'#org.ops4j.pax.web.listening.addresses'/ /opt/opencast/opencast-dist-allinone/etc/org.ops4j.pax.web.cfg


#copy startscript
COPY startOpencast.sh /opt/opencast/


#Compile Opencast
RUN chown -R opencast:opencast /opt/opencast
#Port 8080
EXPOSE 8080
EXPOSE 61616

ENTRYPOINT /opt/opencast/startOpencast.sh
