############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM centos:latest

# File Author / Maintainer
MAINTAINER Christian Greweling


#Create a dedicated Opencast user.
#RUN useradd -d /opt/matterhorn opencast
#Install some Packages
RUN yum update -y
RUN yum install -y \
  tar \
  git \
  bzip2


#Install Opencast
RUN mkdir /opt/opencast
WORKDIR /opt/opencast
RUN git clone https://bitbucket.org/opencast-community/matterhorn.git .
RUN git checkout r/2.0.x 

# get repo.virtuos.uos.de for ffmpeg the repository sources list
ADD matterhorn.repo /etc/yum.repos.d/
ADD matterhorn-testing.repo /etc/yum.repos.d/
# get repo for maven 3.1
ADD http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo /etc/yum.repos.d/epel-apache-maven.repo

RUN yum update --skip broken && yum -y install epel-release


# Update the repository sources list
ADD matterhorn.repo /etc/yum.repos.d/
ADD matterhorn-testing.repo /etc/yum.repos.d/
RUN yum -y install epel-release --skip-broken
RUN sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/epel-testing.repo
RUN sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/epel.repo
#fix https://github.com/docker/docker/issues/6980 some updates with and ufs not possible
RUN yum -y update epel-release
#RUN yum -y install opencast-matterhorn16

ADD usr-sbin-matterhorn /usr/sbin/matterhorn

RUN yum -y install \
    ffmpeg \
    activemq-dist \
    apache-maven \
    tesseract \
    java-1.8.0-openjdk.x86_64 \
    java-1.8.0-openjdk-devel.x86_64

#Compile Opencast
RUN mvn clean install -DskipTests
#Port 8080
