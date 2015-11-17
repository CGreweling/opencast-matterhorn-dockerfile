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
  git


#Install Opencast
RUN mkdir /opt/opencast
WORKDIR /opt/opencast/
RUN git clone https://bitbucket.org/opencast-community/matterhorn.git .
RUN git checkout r/2.1.x

# get repo.virtuos.uos.de for ffmpeg the repository sources list
ADD matterhorn.repo /etc/yum.repos.d/
ADD matterhorn-testing.repo /etc/yum.repos.d/
# get repo for maven r/3.1
ADD http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo /etc/yum.repos.d/epel-apache-maven.repo

RUN yum update --skip broken && yum -y install epel-release
ADD usr-sbin-matterhorn /usr/sbin/matterhorn

RUN yum -y install \
    bzip2 \
    ffmpeg \
    activemq-dist \
    apache-maven \
    tesseract \
    java-1.8.0-openjdk.x86_64 \
    java-1.8.0-openjdk-devel.x86_64

#Compile Opencast
RUN mvn clean install
WORKDIR /opt/opencast/build/
RUN mv opencast-dist-allinone-*/ /opt/opencast
RUN chown -R opencast:opencast /opt/opencast
#Port 8080
EXPOSE 8080
