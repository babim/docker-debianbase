FROM debian:stretch-slim
# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

RUN apt-get update && apt-get install -y \
	    locales nano openssh-server net-tools bash curl

# copyright and timezone
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/copyright.sh | bash

RUN mkdir /var/run/sshd
# set password root
RUN echo 'root:root' | chpasswd
# allow root ssh
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile" LC_ALL C.UTF-8
RUN echo "export VISIBLE=now" >> /etc/profile

ADD runssh.sh /runssh.sh
RUN chmod +x /runssh.sh
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/runssh.sh"]
EXPOSE 22

