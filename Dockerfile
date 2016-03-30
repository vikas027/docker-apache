FROM centos:6.6

MAINTAINER Vikas Kumar "vikas@reachvikas.com"

# Upgrade
RUN yum upgrade -y
RUN yum install -y wget tar gcc vim curl unzip telnet lsof

# Set timezone
ENV TIMEZONE Australia/Sydney
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# Additional Repos
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    http://rpms.famillecollet.com/enterprise/remi-release-6.rpm \
    yum-utils wget unzip && \
    yum-config-manager --enable remi,remi-php56,remi-php56-debuginfo

# install supervisord
RUN yum --enablerepo=epel install -y supervisor
RUN mv -f /etc/supervisord.conf /etc/supervisord.conf.org

# install rsyslog, crond
RUN yum install -y rsyslog cronie-noanacron && \
    cp -a /etc/pam.d/crond /etc/pam.d/crond.org && \
    sed -i -e 's/^\(session\s\+required\s\+pam_loginuid\.so\)/#\1/' /etc/pam.d/crond

# Make ssh, scp work
ENV ROOT_PASS password
RUN yum install -y openssh-server openssh-clients shadow-utils sudo && \
    sed -i 's/UsePAM\syes/UsePAM no/' /etc/ssh/sshd_config && \
    ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:${ROOT_PASS}" | chpasswd && \
    echo -e '\nDefaults:root   !requiretty' >> /etc/sudoers
ADD start_sshd.sh /start_sshd.sh
ADD info.php /var/www/html/info.php

# Webserver with php
RUN yum groupinstall "Web Server" "PHP Support" "MySQL Database client" -y
ADD start_httpd.sh /start_httpd.sh

# Clean up, reduces container size
RUN rm -rf /var/cache/yum/* && yum clean all

EXPOSE 80 22

ADD supervisord.conf /etc/
CMD ["/usr/bin/supervisord"]
