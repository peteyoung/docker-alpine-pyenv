FROM alpine

MAINTAINER Pete Young pete@simpli.fi

RUN apk add man man-pages mdocml-apropos less less-doc \
bash bash-doc bash-completion curl curl-doc git git-doc \
build-base gcc-doc patch zlib-dev libffi-dev linux-headers \
readline-dev openssl openssl-dev sqlite-dev bzip2-dev

RUN curl https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc
