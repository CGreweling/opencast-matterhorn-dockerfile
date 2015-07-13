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
RUN yum -y install epel-release --skip-broken
RUN sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/epel-testing.repo
RUN sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/epel.repo
#fix https://github.com/docker/docker/issues/6980 some updates with and ufs not possible
RUN yum -y update epel-release
RUN yum -y install opencast-matterhorn16
ADD usr-sbin-matterhorn /usr/sbin/matterhorn
ADD /etc/ /etc/matterhorn/

##################### INSTALLATION END #####################

# Expose the default port
EXPOSE 8080

CMD ["/usr/sbin/matterhorn", "--notty"]
