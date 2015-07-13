############################################################
# Dockerfile to build Matterhorn container images
# Based on CentOS 7
############################################################


# Set the base image to centos
FROM centos:centos7

# File Author / Maintainer
MAINTAINER Christian Greweling


# Update the repository sources list
ADD matterhorn.repo /etc/yum.repos.d/
ADD matterhorn-testing.repo /etc/yum.repos.d/
RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install opencast-matterhorn16
ADD usr-sbin-matterhorn /usr/sbin/matterhorn
ADD /etc/ /etc/matterhorn/

##################### INSTALLATION END #####################

# Expose the default port
EXPOSE 8080

CMD ["/usr/sbin/matterhorn", "--notty"]
