FROM ubuntu:latest
MAINTAINER david <david@cninone.com>

RUN apt-get update && apt-get install -y software-properties-common python-software-properties openssh-server supervisor \
    wget curl git build-essential vim emacs \
    libreadline-dev libncurses5-dev libssl-dev
RUN mkdir /var/run/sshd
RUN echo 'root:freego' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir -p /usr/local/src && cd /usr/local/src \
    && wget http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.13.tar.gz \
    && tar zxf squid-3.5.13.tar.gz \
    && cd squid-3.5.13 \
    && ./configure \
        --prefix=/usr \
        --localstatedir=/var \
        --libexecdir=${prefix}/lib/squid \
        --datadir=${prefix}/share/squid \
        --sysconfdir=/etc/squid \
        --with-default-user=proxy \
        --with-logdir=/var/log/squid \
        --with-pidfile=/var/run/squid.pid
    && aptitude build-dep squid \
    && make \
    && make install \
    && rm -rf /usr/local/src/squid-3.5.13
    
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#1723/TCP(PPTP) 1701/UDP(L2TP) 
#500/UDP(IPSec using IKE/IKEv2, e.g. used by L2TP) 
#4500/UDP(IKE/IKEv2 and NAT-T)
EXPOSE 22 500/udp 4500/udp 1701/tcp 443/tcp 992/tcp 5555/tcp

CMD ["/usr/bin/supervisord"]