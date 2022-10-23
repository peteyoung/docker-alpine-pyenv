#!/bin/bash

# Required by NumPy
apk add gfortran

# NumPy will use Lapack and BLAS ABIs if availble
#apk add lapack lapack-dev blas blas-dev
apk add openblas openblas-dev

# make sure pyenv is initialized and the
# tip function is defined
source .bashrc

# activate the virtual env
PYTHON_VIRTUAL_ENV=p${PYTHON_VERSION}
pyenv activate $PYTHON_VIRTUAL_ENV

# install the data science packages
tip numpy==1.21.2
tip scipy==1.7.0 --no-binary scipy
tip scikit-learn==1.0
tip matplotlib==3.4.3
tip pandas==1.3.2
