FROM centos:6.6

MAINTAINER Vikas Kumar "vikas@reachvikas.com"

# Set timezone
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Additional Repos
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    http://rpms.famillecollet.com/enterprise/remi-release-6.rpm \
    yum-utils wget unzip && \
    yum-config-manager --enable remi,remi-php56,remi-php56-debuginfo

# Webserver with php
RUN yum groupinstall "Web Server" "PHP Support" "MySQL Database client" -y

# Clean up, reduces container size
RUN rm -rf /var/cache/yum/* && yum clean all

# Apache start up script 
ADD start-httpd.sh /start-httpd.sh
RUN chmod +x start-httpd.sh -v

EXPOSE 80 443

CMD ["/start-httpd.sh"]
