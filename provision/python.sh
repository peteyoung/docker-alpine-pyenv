#!/bin/bash

PYTHON_VIRTUAL_ENV=p${PYTHON_VERSION}

# install pyenv pyenv-doctor pyenv-installer pyenv-update pyenv-virtualenv pyenv-which-ext
curl https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# initialize pyenv and virtual-env
source .bashrc

# install a python
pyenv install -v $PYTHON_VERSION

# create a virtual-env
pyenv virtualenv $PYTHON_VERSION $PYTHON_VIRTUAL_ENV

# setup pyenv in .bashrc
echo -e "\npyenv activate $PYTHON_VIRTUAL_ENV" >> $HOME/.bashrc

# upgrade pip in the virtual-env
pyenv activate $PYTHON_VIRTUAL_ENV
pip install -U pip
