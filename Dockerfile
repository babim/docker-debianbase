FROM debian:jessie-slim
# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

ENV TZ Asia/Ho_Chi_Minh
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: babim@matmagoc.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    echo "Babim Container Framework \l" > /etc/issue && \
    echo "Babim Container Framework" > /etc/issue.net && \
    touch "/(C) Babim"

RUN apt-get update && apt-get install -y \
	    locales wget nano openssh-server net-tools

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    update-locale LANG=C.UTF-8

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

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

