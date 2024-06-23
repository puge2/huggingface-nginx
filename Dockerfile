FROM ubuntu:22.04

WORKDIR /home
RUN apt update -y \
	&& apt upgrade -y \
 	&& apt install -y nginx supervisor vim screen wget curl git sudo
	
RUN sed -i 's/^%sudo\s\+ALL=(ALL:ALL) ALL/# &/' /etc/sudoers && \
    echo "%sudo   ALL=NOPASSWD:ALL" >> /etc/sudoers	
	
RUN git clone https://github.com/puge2/huggingface-nginx.git
WORKDIR /home/huggingface-nginx

ADD configure.sh /configure.sh
COPY script/supervisord.conf /etc/supervisord.conf
COPY script /tmp
RUN /bin/bash -c 'chmod 755 /tmp/bin && mv /tmp/bin/* /bin/ && rm -rf /tmp/* '
RUN apt update -y \
	&& mkdir -p /run/screen \
	&& chmod -R 777 /run/screen \
	&& chmod +x /configure.sh \
	&& chmod +x /bin/frpc \
	&& chmod +x /bin/ttyd \
	&& rm -rf /etc/nginx/nginx.conf \
	&& mkdir -p /var/www/html/ttyd
COPY static-html /var/www/html	
COPY nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

ENV LANG C.UTF-8
WORKDIR /home
CMD /configure.sh