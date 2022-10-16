#!/bin/bash

# Required by NumPy
apk add gfortran

# NumPy will use Lapack and BLAS ABIs if availble
#apk add lapack lapack-dev blas blas-dev
apk add openblas openblas-dev

#PYTHON_VIRTUAL_ENV=p${PYTHON_VERSION}

#source $HOME/.init_pyenv

#pyenv activate $PYTHON_VIRTUAL_ENV


