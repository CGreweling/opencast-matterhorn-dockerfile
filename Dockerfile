############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM ubuntu:latest

# File Author / Maintainer
MAINTAINER Christian Greweling

#Create a dedicated Opencast user.
RUN useradd -d /home/opencast opencast
RUN apt-get update
#Install some Packages
RUN apt-get install -y \
  tar \
  git


#Install Opencast
RUN mkdir /opt/opencast
WORKDIR /opt/opencast/
#ADD ../opencast/* /opt/opencast/
RUN git clone https://bitbucket.org/opencast-community/matterhorn.git .
RUN git checkout r/2.2.x

# get repo.virtuos.uos.de for ffmpeg the repository sources list
#ADD opencast.repo /etc/yum.repos.d/
#ADD opencast-testing.repo /etc/yum.repos.d/
# get repo for maven r/3.1
#ADD http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo /etc/yum.repos.d/epel-apache-maven.repo

#RUN apt-get update --skip broken && yum -y install epel-release
#ADD usr-sbin-matterhorn /usr/sbin/matterhorn

RUN apt-get -y install \
    bzip2 \
    ffmpeg \
    activemq \
    maven \
    openjdk-8-jdk 
    

#Compile Opencast
RUN mvn clean install -DskipTests
#RUN mv opencast-dist-allinone-*/* /opt/opencast
RUN chown -R opencast:opencast /opt/opencast
#Port 8080
EXPOSE 8080
