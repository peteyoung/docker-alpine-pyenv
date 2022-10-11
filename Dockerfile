FROM alpine

MAINTAINER Pete Young pete@simpli.fi

ENV HOME /root
ENV PYTHON_VERSION=3.9.14

COPY shell/bash_profile $HOME/.bash_profile
COPY shell/bashrc $HOME/.bashrc
COPY shell/init_pyenv $HOME/.init_pyenv

COPY provision/container.sh $HOME/.provision/container.sh
COPY provision/python.sh $HOME/.provision/python.sh
COPY provision/dspy.sh $HOME/.provision/dspy.sh

RUN  $HOME/.provision/container.sh
RUN  $HOME/.provision/python.sh
RUN  $HOME/.provision/dspy.sh

WORKDIR $HOME

CMD ["/bin/bash"]
