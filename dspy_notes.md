docker build -t dspy .

time docker build --progress=plain --no-cache -t dspy .

docker run -it --rm dspy

docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy


--------------------------------

apt -y install less


--------------------------------


apt -y install python3.10-full

```text
Configuring tzdata
------------------

Please select the geographic area in which you live. Subsequent configuration questions will narrow this down by presenting a list of
cities, representing the time zones in which they are located.

  1. Africa   3. Antarctica  5. Arctic  7. Atlantic  9. Indian    11. US
  2. America  4. Australia   6. Asia    8. Europe    10. Pacific  12. Etc
Geographic area:


Please select the city or region corresponding to your time zone.

  1. Alaska    3. Arizona  5. Eastern  7. Indiana-Starke  9. Mountain  11. Samoa
  2. Aleutian  4. Central  6. Hawaii   8. Michigan        10. Pacific
Time zone:

Progress: [ 62%] [######################################################################............................................]
```text

[Passing default answers to apt-get package install questions?](https://serverfault.com/a/407358)

apt -y install debconf-utils
debconf-get-selections | less

Argh! Nothing in there for Python


[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
[How to install tzdata on a ubuntu docker image?](https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image)



DEBIAN_FRONTEND=noninteractive TZ=America/Chicago apt -y install python3.10-full

Argh! Didn't work

Output from above python install

```text
Setting up tzdata (2022c-0ubuntu0.22.04.0) ...

Current default time zone: 'Etc/UTC'
Local time is now:      Mon Oct 10 22:06:35 UTC 2022.
Universal Time is now:  Mon Oct 10 22:06:35 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.
```

Output from beginning of install

```text
The following additional packages will be installed:
  blt ca-certificates fontconfig-config fonts-dejavu-core fonts-mathjax idle-python3.10 javascript-common libbrotli1 libbsd0 libexpat1
  libfontconfig1 libfreetype6 libgdbm6 libjs-jquery libjs-mathjax libjs-underscore libmd0 libmpdec3 libpng16-16 libpython3-stdlib
  libpython3.10-minimal libpython3.10-stdlib libpython3.10-testsuite libreadline8 libsqlite3-0 libtcl8.6 libtk8.6 libx11-6 libx11-data
  libxau6 libxcb1 libxdmcp6 libxext6 libxft2 libxrender1 libxss1 media-types net-tools openssl python3 python3-distutils python3-gdbm
  python3-lib2to3 python3-minimal python3-pip-whl python3-setuptools-whl python3-tk python3.10 python3.10-doc python3.10-examples
  python3.10-minimal python3.10-venv readline-common tk8.6-blt2.5 tzdata ucf x11-common
Suggested packages:
  blt-demo apache2 | lighttpd | httpd gdbm-l10n fonts-mathjax-extras fonts-stix libjs-mathjax-doc tcl8.6 tk8.6 python3-doc
  python3-venv python3-gdbm-dbg tix python3-tk-dbg binutils python3.10-dev binfmt-support readline-doc
The following NEW packages will be installed:
  blt ca-certificates fontconfig-config fonts-dejavu-core fonts-mathjax idle-python3.10 javascript-common libbrotli1 libbsd0 libexpat1
  libfontconfig1 libfreetype6 libgdbm6 libjs-jquery libjs-mathjax libjs-underscore libmd0 libmpdec3 libpng16-16 libpython3-stdlib
  libpython3.10-minimal libpython3.10-stdlib libpython3.10-testsuite libreadline8 libsqlite3-0 libtcl8.6 libtk8.6 libx11-6 libx11-data
  libxau6 libxcb1 libxdmcp6 libxext6 libxft2 libxrender1 libxss1 media-types net-tools openssl python3 python3-distutils python3-gdbm
  python3-lib2to3 python3-minimal python3-pip-whl python3-setuptools-whl python3-tk python3.10 python3.10-doc python3.10-examples
  python3.10-full python3.10-minimal python3.10-venv readline-common tk8.6-blt2.5 tzdata ucf x11-common
0 upgraded, 58 newly installed, 0 to remove and 0 not upgraded.
```

Try installin `tzdata` alone and check its output

apt -y install tzdata

```text
 apt -y install tzdata
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  tzdata
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 335 kB of archives.
After this operation, 3877 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 tzdata all 2022c-0ubuntu0.22.04.0 [335 kB]
Fetched 335 kB in 1s (359 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package tzdata.
(Reading database ... 4412 files and directories currently installed.)
Preparing to unpack .../tzdata_2022c-0ubuntu0.22.04.0_all.deb ...
Unpacking tzdata (2022c-0ubuntu0.22.04.0) ...
Setting up tzdata (2022c-0ubuntu0.22.04.0) ...
debconf: unable to initialize frontend: Dialog
debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.34.0 /usr/local/share/perl/5.34.0 /usr/lib/x86_64-linux-gnu/perl5/5.34 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.34 /usr/share/perl/5.34 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
debconf: falling back to frontend: Teletype
Configuring tzdata
------------------

Please select the geographic area in which you live. Subsequent configuration questions will narrow this down by presenting a list of
cities, representing the time zones in which they are located.

  1. Africa   3. Antarctica  5. Arctic  7. Atlantic  9. Indian    11. US
  2. America  4. Australia   6. Asia    8. Europe    10. Pacific  12. Etc
Geographic area: 11

Please select the city or region corresponding to your time zone.

  1. Alaska    3. Arizona  5. Eastern  7. Indiana-Starke  9. Mountain  11. Samoa
  2. Aleutian  4. Central  6. Hawaii   8. Michigan        10. Pacific
Time zone: 4


Current default time zone: 'US/Central'
Local time is now:      Mon Oct 10 17:13:38 CDT 2022.
Universal Time is now:  Mon Oct 10 22:13:38 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.
```

That's the culprit.

DEBIAN_FRONTEND=noninteractive TZ=America/Chicago apt -y install tzdata

echo "America/Chicago" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

Didn't work.


[apt-get install tzdata noninteractive](https://stackoverflow.com/a/44333806)

apt -y install debconf-utils

DEBIAN_FRONTEND=noninteractive apt -y install tzdata
echo "tzdata tzdata/Areas select US" | debconf-set-selections
echo "tzdata tzdata/Zones/US select Central" | debconf-set-selections
rm -f /etc/localtime /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

apt -y install python3.10-full


yay!


--------------------------------


debconf: unable to initialize frontend: Dialog
debconf: unable to initialize frontend: Dialog
debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.34.0 /usr/local/share/perl/5.34.0 /usr/lib/x86_64-linux-gnu/perl5/5.34 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.34 /usr/share/perl/5.34 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
debconf: falling back to frontend: Teletype

Dialog vs Readline vs Teletype

Meh, don't care


--------------------------------


[Install Python 3.9 or 3.8 on Ubuntu 22.04 LTS Jammy JellyFish](https://www.how2shout.com/linux/install-python-3-9-or-3-8-on-ubuntu-22-04-lts-jammy-jellyfish/#6_Set_the_default_Python_version)


# This gets us `python` on the command line instead of `python3`.
update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1


--------------------------------

# python -m ensurepip --upgrade
ensurepip is disabled in Debian/Ubuntu for the system python.

Python modules for the system python are usually handled by dpkg and apt-get.

    apt install python3-<module name>

Install the python3-pip package to use pip itself.  Using pip together
with the system python might have unexpected results for any system installed
module, so use it on your own risk, or make sure to only use it in virtual
environments.


Goddammit.

--------------------------------


root@9dfb669ed7a1:/# apt install python3-pip

root@9dfb669ed7a1:/# pip install -U pip
Requirement already satisfied: pip in /usr/lib/python3/dist-packages (22.0.2)
Collecting pip
  Downloading pip-22.2.2-py3-none-any.whl (2.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.0/2.0 MB 6.0 MB/s eta 0:00:00
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 22.0.2
    Not uninstalling pip at /usr/lib/python3/dist-packages, outside environment /usr
    Can't uninstall 'pip'. No files were found to uninstall.
Successfully installed pip-22.2.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

Double Goddammit.

--------------------------------


update-alternatives --install \
    /usr/bin/python python \
    /opt/python/${PYTHON_VERSION}/bin/python$(echo $PYTHON_VERSION | cut -d'.' -f 1,2) \
    1

/opt/python/${PYTHON_VERSION}/bin/python$(echo $PYTHON_MAJOR | cut -d'.' -f 1,2) --version
--------------------------------




pyenv virtualenv 3.10.7
pyenv activate dspy






export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pyenv bash completion
. ~/.pyenv/completions/pyenv.bash

--------------------------------

bash-5.1# pyenv init -
PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); for i in ${!paths[@]}; do if [[ ${paths[i]} == "'/root/.pyenv/shims'" ]]; then unset '\''paths[i]'\''; fi; done; echo "${paths[*]}"')"
export PATH="/root/.pyenv/shims:${PATH}"
export PYENV_SHELL=ash
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}


bash-5.1# pyenv virtualenv-init -
export PATH="/root/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "$VIRTUAL_ENV" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};




--------------------------------

#14 DONE 134.3s

real	2m31.177s
user	0m0.420s
sys	0m0.475s


-j2
real	3m5.012s
user	0m0.427s
sys	0m0.475s

#14 134.9 PYTHONPATH=/root/.pyenv/versions/3.9.14/lib/python3.9   \
#14 134.9       ./python -E -Wi /root/.pyenv/versions/3.9.14/lib/python3.9/compileall.py \
#14 134.9       -j0 -d /root/.pyenv/versions/3.9.14/lib/python3.9 -f \
#14 134.9       -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' \
#14 134.9       /root/.pyenv/versions/3.9.14/lib/python3.9

Can't customize parallelization with Python 3.9 - 3.11 builds. It's a bug. Fixed in 3.12, no backport.


--------------------------------


cat <<EOF >  test_time.sh
#! /bin/bash
echo "stdout"
echo "stderr" >&2
EOF

# doesn't capture time's output
time ./test_time.sh 2>&1 | tee log.1

# captures time's output
{ time a_command; } 2>&1 | tee a.log


--------------------------------

function tip {
  if [[ $# -eq 0 ]]; then
    echo "No package given"
    return 1
  fi
  
  PACKAGE=$1
  PACKAGE_NAME=$(echo "$PACKAGE" | tr -s '==' '*' | cut -d'*' -f 1)

  { time pip install -Ivvv $PACKAGE; } 2>&1 | tee ${PACKAGE_NAME}-$(date +"%s").log
}

function jip {
  if [[ $# -eq 0 ]]; then
    echo "No package given"
    return 1
  fi
  
  PACKAGE=$1
  PACKAGE_NAME=$(echo "$PACKAGE" | tr -s '==' '*' | cut -d'*' -f 1)

  { MAKEFLAGS="-j2" time pip install -Ivvv $PACKAGE; } 2>&1 | tee ${PACKAGE_NAME}-j2-$(date +"%s").log
}


real	5m22.258s
user	7m37.454s
sys	0m57.182s

Is this the same issue with setup.py as with building Python?


--------------------------------

[Changes/OpenBLAS as default BLAS](https://fedoraproject.org/wiki/Changes/OpenBLAS_as_default_BLAS)
# OpenBLAS may satisfy both Lapack and BLAS dependencies.
#apk add openblas openblas-dev

# lapack will install blas if it's not already. openblas has no effect.
apk add blas blas-dev
apk add lapack lapack-dev


numpy==1.21.2                 2021-08-15
scipy==1.7.0                  2021-06-20
  Cython==0.29.24             2021-07-13
  pythran==0.10.0             2021-09-14
scikit-learn==1.0             2021-09-24
matplotlib==3.4.3             2021-08-12
pandas==1.3.2                 2021-08-15


tip numpy==1.21.2
tip Cython==0.29.24
tip pythran==0.10.0
tip scipy==1.7.0
tip scikit-learn==1.0
tip matplotlib==3.4.3
tip pandas==1.3.2

{ time pip install -Ivvv numpy==1.21.2; } 2>&1 | tee numpy-$(date +"%s").log
{ time pip install -Ivvv scipy==1.7.0; } 2>&1 | tee scipy-$(date +"%s").log
{ time pip install -Ivvv scikit-learn==1.0; } 2>&1 | tee scikit-learn-$(date +"%s").log
{ time pip install -Ivvv matplotlib==3.4.3; } 2>&1 | tee matplotlib-$(date +"%s").log
{ time pip install -Ivvv pandas==1.3.2; } 2>&1 | tee pandas.log

{ MAKEFLAGS="-j2" time pip install -Ivvv numpy==1.21.2; } 2>&1 | tee numpy-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -Ivvv scipy==1.7.0; } 2>&1 | tee scipy-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -Ivvv scikit-learn==1.0; } 2>&1 | tee scikit-learn-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -Ivvv matplotlib==3.4.3; } 2>&1 | tee matplotlib-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -Ivvv pandas==1.3.2 2>&1; } | tee pandas-j2-$(date +"%s").log

MAKEFLAGS="-j2" pip install -Ivvv numpy==1.21.2 2>&1 | tee numpy-j2-$(date +"%s").log


numpy:

`-vvv logging` showed `NOT AVAILABLE` warnings for Lapack, BLAS, OpenBLAS, ATLAS, and MKL_RT.

After `apk add blas blas-dev` and `apk add lapack lapack-dev`, the following is in the build log.

```text
2599   lapack_info:
2600     FOUND:
2601       libraries = ['lapack', 'lapack']
2602       library_dirs = ['/usr/lib']
2603       language = f77
2604
2605     FOUND:
2606       libraries = ['lapack', 'lapack', 'cblas', 'blas', 'blas']
2607       library_dirs = ['/usr/lib']
2608       language = c
2609       define_macros = [('NO_ATLAS_INFO', 1), ('HAVE_CBLAS', None)]
2610       include_dirs = ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/include']
```

scipy:

This required downgrading to Python 3.9.14:

```text
ERROR: Ignored the following versions that require a different python version:
1.6.2 Requires-Python >=3.7,<3.10;
1.6.3 Requires-Python >=3.7,<3.10;
1.7.0 Requires-Python >=3.7,<3.10;
1.7.0rc1 Requires-Python >=3.7,<3.10;
1.7.0rc2 Requires-Python >=3.7,<3.10;
1.7.1 Requires-Python >=3.7,<3.10
```

These required  `apk add gfortran`.

```text
scikit-learn (while trying to compile scipy-1.9.2):
        ../../meson.build:49:0: ERROR: Unknown compiler(s): [['gfortran'], ['flang'], ['nvfortran'], ['pgfortran'], ['ifort'], ['g95']]
        The following exception(s) were encountered:
        Running `gfortran --version` gave "[Errno 2] No such file or directory: 'gfortran'"
        Running `gfortran -V` gave "[Errno 2] No such file or directory: 'gfortran'"
        Running `flang --version` gave "[Errno 2] No such file or directory: 'flang'"
        Running `flang -V` gave "[Errno 2] No such file or directory: 'flang'"
        Running `nvfortran --version` gave "[Errno 2] No such file or directory: 'nvfortran'"
        Running `nvfortran -V` gave "[Errno 2] No such file or directory: 'nvfortran'"
        Running `pgfortran --version` gave "[Errno 2] No such file or directory: 'pgfortran'"
        Running `pgfortran -V` gave "[Errno 2] No such file or directory: 'pgfortran'"
        Running `ifort --version` gave "[Errno 2] No such file or directory: 'ifort'"
        Running `ifort -V` gave "[Errno 2] No such file or directory: 'ifort'"
        Running `g95 --version` gave "[Errno 2] No such file or directory: 'g95'"
        Running `g95 -V` gave "[Errno 2] No such file or directory: 'g95'"
```

```text
  numpy.distutils.system_info.NotFoundError: No BLAS/LAPACK libraries found.
  To build Scipy from sources, BLAS & LAPACK libraries need to be installed.
  See site.cfg.example in the Scipy source directory and
  https://docs.scipy.org/doc/scipy/reference/building/index.html for details.
```

I noticed that despite installing NumPy 1.21.2 first, SciPy




--------------------------------


Resources:

* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* [what does --enable-optimizations do while compiling python?](https://stackoverflow.com/questions/41405728/what-does-enable-optimizations-do-while-compiling-python)
* Parallel builds with make, pyenv, and pip
  * [How many CPUs does a docker container use?](https://stackoverflow.com/questions/37871540/how-many-cpus-does-a-docker-container-use)
  * [GNU make: should the number of jobs equal the number of CPU cores in a system?](https://stackoverflow.com/questions/2499070/gnu-make-should-the-number-of-jobs-equal-the-number-of-cpu-cores-in-a-system)
  * [Pip build option to use multicore](https://stackoverflow.com/a/68888059)
  * [How to install/compile pip requirements in parallel (make -j equivalent)](https://stackoverflow.com/a/57014278)
  * [https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#special-environment-variables](https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#special-environment-variables)
  * Doesn't work in Python 3.9 - 3.11. Would have to patch. Meh.
    * [Override the number of parallel compilation processes](https://giters.com/pyenv/pyenv/issues/1857?amp=1)
    * [Extensions build does not respect --jobs setting](https://github.com/python/cpython/issues/87800)
* Install Python on Ubuntu 22.04
  * [How To Install Python on Ubuntu 22.04 LTS](https://idroot.us/install-python-ubuntu-22-04/)
  * [Install Python 3.9 or 3.8 on Ubuntu 22.04](https://www.how2shout.com/linux/install-python-3-9-or-3-8-on-ubuntu-22-04-lts-jammy-jellyfish/#6_Set_the_default_Python_version)
* Install Python from source
  * [RStudio: Install Python From Source](https://docs.rstudio.com/resources/install-python-source/)
  * [Configure Python](https://docs.python.org/3/using/configure.html)
  * [How to Use update-alternatives Command on Ubuntu](https://linuxhint.com/update_alternatives_ubuntu/)
* pyenv
  * [Managing virtual environments with pyenv](https://towardsdatascience.com/managing-virtual-environment-with-pyenv-ae6f3fb835f8)
  * [pyenv install](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-install)
  * [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
  * [peteyoung / python-dev-env](https://github.com/peteyoung/python-dev-env/blob/master/python-dev-setup.md)
  * [pyenv suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
* pyenv-virtualenv: prompt changing will be removed from future release.
  *[Why is prompt changing being removed? #268](https://github.com/pyenv/pyenv-virtualenv/issues/268)
  *[Question regarding prompt changing #135](https://github.com/pyenv/pyenv-virtualenv/issues/135)
  *[]()
* pip
  * [pip installation](https://pip.pypa.io/en/stable/installation/)
  * [Installing specific package version with pip](https://stackoverflow.com/a/5226504)
* gfortran error
  * ["getting requirement to build wheel error " when trying to install pillow , seaborn](https://stackoverflow.com/questions/73257196/getting-requirement-to-build-wheel-error-when-trying-to-install-pillow-seab)
* Lapack, BLAS, ATLAS, & mkl_rt error (numpy, scipy)
  * [Qiime 1 Forum: Numpy is installed, but can't find lapack/blas](https://groups.google.com/g/qiime-forum/c/bdDT4CF4vtM)
  * [Qiime 1 Forum: Native install on Ubuntu 14.04 LTS](https://groups.google.com/g/qiime-forum/c/8dVlTtlg59M/m/X3aUWH6DOQMJ)
  * [What is the relation between BLAS, LAPACK and ATLAS](https://stackoverflow.com/questions/17858104/what-is-the-relation-between-blas-lapack-and-atlas)
  * [No BLAS/LAPACK libraries found when installing SciPy](https://stackoverflow.com/questions/69954587/no-blas-lapack-libraries-found-when-installing-scipy/70880741#70880741)
  * [SciPy: Building from sources](https://docs.scipy.org/doc/scipy/dev/contributor/building.html)
* Lapack, BLAS, and OpenBLAS
  * [Link against openblas; do I need still Lapack?](https://stackoverflow.com/questions/32925267/link-against-openblas-do-i-need-still-lapack)
  * [combining OpenBLAS with LAPACK #203](https://github.com/xianyi/OpenBLAS/issues/203)
  * []()
* Building packages from source
  * [NumPy](https://numpy.org/doc/1.21/user/building.html)
  * [SciPy](https://docs.scipy.org/doc/scipy/dev/contributor/building.html)
    * [Building from source on Windows](https://docs.scipy.org/doc/scipy-1.7.1/reference/building/windows.html)
    * [Building Against an Older NumPy Version](https://docs.scipy.org/doc/scipy-1.7.1/reference/building/windows.html#building-against-an-older-numpy-version)
  * [Building NumPy & SciPy From Source on Linux](https://scottza.github.io/building/linux.html)
  * []()


Learned and Relearned

* How to `echo` a newline
  * [echo manpage](https://linuxcommand.org/lc3_man_pages/echoh.html)
  
      ```sh
      echo -e "\nfoo\nbar"
      ```
* How to test for arguments in POSIX, Bourne, or Ash shells
  * [dash manpage (search page for "test expression")](https://man7.org/linux/man-pages/man1/dash.1.html)
  
      ```sh
      if [ -z $@ ]; then
        echo No arguments given
        exit 1
      fi
      ```

* Get `docker build` to dump all output to console instead of a small window in terminal
  * [Why is docker build not showing any output from commands?](https://stackoverflow.com/a/64805337)

      ```sh
      docker build --progress=plain --no-cache -t dspy .
      ```

* Blow away all the build caches
  * [docker builder prune](https://docs.docker.com/engine/reference/commandline/builder_prune/)

      Last time I ran this, it cleaned up 22Gb.

      ```sh
      docker builder prune -a
      ```

* Make `pip` compile with two threads
  * [Pip build option to use multicore](https://stackoverflow.com/a/68888059)

      ```sh
      MAKEFLAGS="-j2" pip install numpy
      ```

* Try to make `pyenv` compile Python with two threads
  * [https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#special-environment-variables](https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#special-environment-variables)

      ```sh
      PYTHON_MAKE_OPTS="-j2" pyenv install -v 3.9.14
      ```

* Create a unix timestamp for a filename
  * [How to display Unix time in the timestamp format?](https://superuser.com/a/165682)

      ```sh
      touch important-service-$(date +"%s").log
      ```

* Capture the output of `time` along with the command's output being timed
  * [How to redirect the output of the time command to a file in Linux?](https://stackoverflow.com/a/13356654)
  * [Combine the output of two commands in bash](https://unix.stackexchange.com/questions/64736/combine-the-output-of-two-commands-in-bash)

      ```sh
      { time a_command; } 2>&1 | tee a.log
      ```

*
  * []()

      ```sh
      
      ```



time docker build --progress=plain --no-cache -t dspy . 2>&1 | tee build_logs/docker-build-pyenv-j2-$(date +"%s").log

docker build --progress=plain --no-cache -t dspy .

docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy


docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy_scipy_lapack_blas_01



