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
    chown developer:users setup_container.sh

# Install development related packages
RUN chmod +x setup_container.sh && \
    ./setup_container.sh

# setup developer user with sudo privileges
RUN addgroup sudo && adduser developer sudo
RUN apk add sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer

# install pyenv pyenv-doctor pyenv-installer pyenv-update pyenv-virtualenv pyenv-which-ext
RUN curl https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
