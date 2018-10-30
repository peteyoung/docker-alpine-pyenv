FROM alpine

MAINTAINER Pete Young pete@simpli.fi

RUN adduser developer -D -G users
WORKDIR /home/developer

COPY bash_profile .bash_profile
COPY bashrc .bashrc
COPY setup_container.sh setup_container.sh

# dot files need to be explicit in ash shell (no dotglob)
RUN chown developer:users .bash_profile       && \
    chown developer:users .bashrc             && \
    chown developer:users setup_container.sh  && \
    chmod +x setup_container.sh               && \
    ./setup_container.sh
