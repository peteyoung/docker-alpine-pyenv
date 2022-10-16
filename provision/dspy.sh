#!/bin/bash

# These are requirements of SciPy
# NumPy will use Lapack if it's availble
apk add gfortran
apk add blas blas-dev
apk add lapack lapack-dev

#PYTHON_VIRTUAL_ENV=p${PYTHON_VERSION}

#source $HOME/.init_pyenv

#pyenv activate $PYTHON_VIRTUAL_ENV


