FROM alpine

MAINTAINER Pete Young pete@simpli.fi

COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc

COPY setup_container.sh /root/setup_container.sh
RUN  chmod +x /root/setup_container.sh && /root/setup_container.sh
