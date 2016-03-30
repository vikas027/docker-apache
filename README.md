# Docker Container for running apache on CentOS 6
The docker container is based on CentOS 6. 
Apache v2.2.15 has been installed to support php v5.6

More details are available on [Docker Hub Registry](https://registry.hub.docker.com/u/vikas027/centos-apache-php/).

### Docker Installation
Install [Docker](https://docs.docker.com/installation/) on your favourite distro and run the container

### Run Container
Run the below commands to run the container

```bash
docker pull vikas027/centos-apache-php

OR

docker run --name <any_name> -e 'TIMEZONE=Canada/Central' -e 'ROOT_PASS=secret' -d -p <host_http_port>:80 -p <host_ssh_port>:22 -v <path_of_website_files>:/var/www/html vikas027/centos-apache-php
```
