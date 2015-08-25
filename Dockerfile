############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM centos:centos7

# File Author / Maintainer
MAINTAINER Christian Greweling

#Create a dedicated Opencast user.
#RUN useradd -d /opt/matterhorn opencast
#Install some Packages
RUN yum install -y \
  tar \
  bzip2 \
  git


#Install Opencast
RUN mkdir /opt/matterhorn
WORKDIR /opt/matterhorn/
RUN git clone https://bitbucket.org/opencast-community/matterhorn.git .
RUN git checkout develop
ADD usr-sbin-matterhorn /usr/sbin/matterhorn

# get repo.virtuos.uos.de for ffmpeg the repository sources list
ADD matterhorn.repo /etc/yum.repos.d/
ADD matterhorn-testing.repo /etc/yum.repos.d/

# get repo for maven 3.1
ADD http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo /etc/yum.repos.d/epel-apache-maven.repo

RUN yum update --skip broken && yum -y install epel-release
RUN yum -y install \
    ffmpeg \
    activemq-dist \
    apache-maven \
    tesseract \
    java-1.8.0-openjdk.x86_64 \
    java-1.8.0-openjdk-devel.x86_64
#prepare activemq config
RUN cp docs/scripts/activemq/activemq.xml /etc/activemq/activemq.xml

#Compile Opencast
RUN mvn clean install -DdeployTo=/opt/matterhorn/

#Port 8080
EXPOSE 8080
