FROM alpine

MAINTAINER Pete Young pete@simpli.fi

ENV HOME /root
ENV PYTHON_VERSION=3.9.14

COPY shell/bash_profile $HOME/.bash_profile
COPY shell/bashrc $HOME/.bashrc
COPY shell/init_pyenv $HOME/.init_pyenv

COPY provision/setup_container.sh $HOME/setup_container.sh
COPY provision/setup_python.sh $HOME/setup_python.sh
COPY provision/setup_dspy.sh $HOME/setup_dspy.sh

RUN  $HOME/setup_container.sh
RUN  $HOME/setup_python.sh
RUN  $HOME/setup_dspy.sh

WORKDIR $HOME

CMD ["/bin/bash"]
