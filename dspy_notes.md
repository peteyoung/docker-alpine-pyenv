## Quick Commands

Ubuntu

```sh
docker run -it --rm -v "$(pwd)/build_logs":/build_logs ubuntu

apt update && apt -y upgrade
```

Alpine

```sh
docker build -t dspy .

time docker build --progress=plain --no-cache -t dspy .

docker run -it --rm dspy

docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy
```

# The Try with Ubuntu 22.04

Start a container. Add a bind mount for saving logs.

```sh
docker run -it --rm -v "$(pwd)/build_logs":/build_logs ubuntu
```

Set up the container

```sh
apt update && apt -y upgrade
apt -y install less
```

Install python 3.10

```sh
apt -y install python3.10-full 2>&1 | tee /root/python3.10-full-$(date +"%s").log
```

It installs ok, but there's a couple of timezone questions it asks that need to be automated. Let's look at that in the log.

```text
Configuring tzdata
------------------

Please select the geographic area in which you live. Subsequent configuration
questions will narrow this down by presenting a list of cities, representing
the time zones in which they are located.

  1. Africa   3. Antarctica  5. Arctic  7. Atlantic  9. Indian    11. US
  2. America  4. Australia   6. Asia    8. Europe    10. Pacific  12. Etc
Geographic area: 11

Please select the city or region corresponding to your time zone.

  1. Alaska    4. Central  7. Indiana-Starke  10. Pacific
  2. Aleutian  5. Eastern  8. Michigan        11. Samoa
  3. Arizona   6. Hawaii   9. Mountain
Time zone: 4


Current default time zone: 'US/Central'
Local time is now:      Sat Oct 15 22:14:28 CDT 2022.
Universal Time is now:  Sun Oct 16 03:14:28 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.
```

## Automate setting the timezone for Python

This StackOverflow answer suggests using `debconf-get-selections` to search for and set debconf's configuration questions.

[Passing default answers to apt-get package install questions?](https://serverfault.com/a/407358)

```sh
apt -y install debconf-utils
debconf-get-selections | less
```

Argh! Nothing in there for Python

Looking back at the log excerpt, it hit me that `tzdata` is a Linux command for setting the locale and timezone.

And here it is towards the end of the list of new packages that will be installed.

```text
The following NEW packages will be installed:
  blt ca-certificates fontconfig-config fonts-dejavu-core fonts-mathjax
  idle-python3.10 javascript-common libbrotli1 libbsd0 libexpat1
  libfontconfig1 libfreetype6 libgdbm6 libjs-jquery libjs-mathjax
  libjs-underscore libmd0 libmpdec3 libpng16-16 libpython3-stdlib
  libpython3.10-minimal libpython3.10-stdlib libpython3.10-testsuite
  libreadline8 libsqlite3-0 libtcl8.6 libtk8.6 libx11-6 libx11-data libxau6
  libxcb1 libxdmcp6 libxext6 libxft2 libxrender1 libxss1 media-types net-tools
  openssl python3 python3-distutils python3-gdbm python3-lib2to3
  python3-minimal python3-pip-whl python3-setuptools-whl python3-tk python3.10
  python3.10-doc python3.10-examples python3.10-full python3.10-minimal
  python3.10-venv readline-common tk8.6-blt2.5 tzdata ucf x11-common
```

This StackExchange answer suggests using optional variable assignments before `apt` to automate setting the timezone.

[How to install tzdata on a ubuntu docker image?](https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image)

First lets look up our timezone in here.

[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Start fresh with a new container and run the following.

```sh
DEBIAN_FRONTEND=noninteractive TZ="America/Chicago" apt -y install python3.10-full | tee /root/python3.10-full-$(date +"%s").log
```

Argh! Didn't work

```text
Setting up tzdata (2022c-0ubuntu0.22.04.0) ...

Current default time zone: 'Etc/UTC'
Local time is now:      Sun Oct 16 03:34:00 UTC 2022.
Universal Time is now:  Sun Oct 16 03:34:00 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.
```

Maybe try installing `tzdata` alone first.

After researching automating a `tzdata` install, instead of "python ubuntu install timezone automate", I found this answer on StackOverflow.

[apt-get install tzdata noninteractive](https://stackoverflow.com/a/67734239)

Start a fresh container.

```sh
apt -y install debconf-utils

echo "tzdata tzdata/Areas select US" | debconf-set-selections
echo "tzdata tzdata/Zones/US select Central" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt -y install tzdata
```

Here's the relevant output

```text
Setting up tzdata (2022c-0ubuntu0.22.04.0) ...

Current default time zone: 'US/Central'
Local time is now:      Sat Oct 15 22:52:51 CDT 2022.
Universal Time is now:  Sun Oct 16 03:52:51 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.
```

Yay!

Now let's see if a Python install requires any interaction

```sh
apt -y install python3.10-full
```

Opened the log file with `less` and search for "tzdata" and got the following result.

```text
Pattern not found  (press RETURN)
```

Double yay!

## Other Errors in build log

Found the following in the build log

```text
debconf: unable to initialize frontend: Dialog
debconf: unable to initialize frontend: Dialog
debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.34.0 /usr/local/share/perl/5.34.0 /usr/lib/x86_64-linux-gnu/perl5/5.34 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.34 /usr/share/perl/5.34 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
debconf: falling back to frontend: Teletype
```

It's related to debconf being able to pop up a dialog to ask the timezone questions.

Meh, don't care


## The name of the Python executable

We're way past needing to type in `python3` to run Python. I found this solution while digging.

[Install Python 3.9 or 3.8 on Ubuntu 22.04 LTS Jammy JellyFish](https://www.how2shout.com/linux/install-python-3-9-or-3-8-on-ubuntu-22-04-lts-jammy-jellyfish/#6_Set_the_default_Python_version)

This lets us type `python` on the command line instead of `python3`.

```sh
update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
```

## Install pip

```sh
python -m ensurepip --upgrade
```

Uh oh.

```text
ensurepip is disabled in Debian/Ubuntu for the system python.

Python modules for the system python are usually handled by dpkg and apt-get.

    apt install python3-<module name>

Install the python3-pip package to use pip itself.  Using pip together
with the system python might have unexpected results for any system installed
module, so use it on your own risk, or make sure to only use it in virtual
environments.
```

That sucks.

Let's try the suggestion of installing the `python3-pip` package.

```sh
apt -y install python3-pip
```

Wow, that installs a full build chain. I guess that makes sense considering some `pip` packages need to build c libraries.

```text
The following additional packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu build-essential bzip2 cpp cpp-11 dirmngr dpkg-dev fakeroot g++ g++-11 gcc gcc-11 gcc-11-base gnupg gnupg-l10n
  gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan6 libassuan0
  libatomic1 libbinutils libc-dev-bin libc-devtools libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdeflate0 libdpkg-perl libexpat1-dev libfakeroot
  libfile-fcntllock-perl libgcc-11-dev libgd3 libgdbm-compat4 libgomp1 libisl23 libitm1 libjbig0 libjpeg-turbo8 libjpeg8 libjs-sphinxdoc libksba8 libldap-2.5-0
  libldap-common liblocale-gettext-perl liblsan0 libmpc3 libmpfr6 libnpth0 libnsl-dev libperl5.34 libpython3-dev libpython3.10 libpython3.10-dev libquadmath0 libsasl2-2
  libsasl2-modules libsasl2-modules-db libstdc++-11-dev libtiff5 libtirpc-dev libtsan0 libubsan1 libwebp7 libxpm4 linux-libc-dev lto-disabled-list make manpages
  manpages-dev netbase patch perl perl-modules-5.34 pinentry-curses python3-dev python3-pkg-resources python3-setuptools python3-wheel python3.10-dev rpcsvc-proto xz-utils
  zlib1g-dev
Suggested packages:
  binutils-doc bzip2-doc cpp-doc gcc-11-locales dbus-user-session libpam-systemd pinentry-gnome3 tor debian-keyring g++-multilib g++-11-multilib gcc-11-doc gcc-multilib
  autoconf automake libtool flex bison gdb gcc-doc gcc-11-multilib parcimonie xloadimage scdaemon glibc-doc git bzr libgd-tools libsasl2-modules-gssapi-mit
  | libsasl2-modules-gssapi-heimdal libsasl2-modules-ldap libsasl2-modules-otp libsasl2-modules-sql libstdc++-11-doc make-doc man-browser ed diffutils-doc perl-doc
  libterm-readline-gnu-perl | libterm-readline-perl-perl libtap-harness-archive-perl pinentry-doc python-setuptools-doc
The following NEW packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu build-essential bzip2 cpp cpp-11 dirmngr dpkg-dev fakeroot g++ g++-11 gcc gcc-11 gcc-11-base gnupg gnupg-l10n
  gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan6 libassuan0
  libatomic1 libbinutils libc-dev-bin libc-devtools libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdeflate0 libdpkg-perl libexpat1-dev libfakeroot
  libfile-fcntllock-perl libgcc-11-dev libgd3 libgdbm-compat4 libgomp1 libisl23 libitm1 libjbig0 libjpeg-turbo8 libjpeg8 libjs-sphinxdoc libksba8 libldap-2.5-0
  libldap-common liblocale-gettext-perl liblsan0 libmpc3 libmpfr6 libnpth0 libnsl-dev libperl5.34 libpython3-dev libpython3.10 libpython3.10-dev libquadmath0 libsasl2-2
  libsasl2-modules libsasl2-modules-db libstdc++-11-dev libtiff5 libtirpc-dev libtsan0 libubsan1 libwebp7 libxpm4 linux-libc-dev lto-disabled-list make manpages
  manpages-dev netbase patch perl perl-modules-5.34 pinentry-curses python3-dev python3-pip python3-pkg-resources python3-setuptools python3-wheel python3.10-dev
  rpcsvc-proto xz-utils zlib1g-dev
```

Now let's upgrade `pip` with `pip`

```sh
pip install -U pip
```

---

```text
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
```

That double sucks.

## So Long, Ubuntu

I really just didn't want to care about the "system python." There isn't one with the stripped down Ubuntu image for Docker. But after giving it more thought, it would be horrible later on to install a dependency in Docker that _did_ install a system Python and a possible conflicting Python library, too.

Obviously, the next step is to use a virtual-env, but I already had something a little better.

I have an image built on Alpine with `pyenv`, `pyenv virtualenv`, and the necessary build chain.

# YOU ARE HERE ###################
# Alpine

```sh
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pyenv bash completion
. ~/.pyenv/completions/pyenv.bash
```

--------------------------------

```sh
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
```

--------------------------------

Parallelizing builds

No `-j`

```text
#14 DONE 134.3s

real	2m31.177s
user	0m0.420s
sys	0m0.475s
```

With `-j`

``` text
real	3m5.012s
user	0m0.427s
sys	0m0.475s
```

Whut?

From the Python build log:

```text
#14 134.9 PYTHONPATH=/root/.pyenv/versions/3.9.14/lib/python3.9   \
#14 134.9       ./python -E -Wi /root/.pyenv/versions/3.9.14/lib/python3.9/compileall.py \
#14 134.9       -j0 -d /root/.pyenv/versions/3.9.14/lib/python3.9 -f \
#14 134.9       -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' \
#14 134.9       /root/.pyenv/versions/3.9.14/lib/python3.9
```

Can't customize parallelization with Python 3.9 - 3.11 builds. It's a bug. Fixed in 3.12, no backport.

Found something interesting in the [SciPy `setup.py`](https://github.com/scipy/scipy/blob/maintenance/1.7.x/setup.py#L259-L267) about parallelizing builds.

> NOTE: -j build option not supported. Set NPY_NUM_BUILD_JOBS=4 for parallel build.


--------------------------------

A quick test to figure out how to capture the output of `time` and the command it wraps into a log file.

```sh
cat <<EOF >  test_time.sh
#! /bin/bash
echo "stdout"
echo "stderr" >&2
EOF

# doesn't capture time's output
time ./test_time.sh 2>&1 | tee log.1

# captures time's output
{ time a_command; } 2>&1 | tee a.log
```

--------------------------------

Some functions to capture `pip` build and install output along with `time` output to a log file.

`tip` runs `pip` as usual.
`jip` runs `pip` with `MAKEFLAGS="-j2"`

```sh
function tip {
  if [[ $# -eq 0 ]]; then
    echo "No package given"
    return 1
  fi
  
  PACKAGE=$1
  PACKAGE_NAME=$(echo "$PACKAGE" | tr -s '==' '*' | cut -d'*' -f 1)

  { time pip install -vvv $PACKAGE; } 2>&1 | tee ${PACKAGE_NAME}-$(date +"%s").log
}

function jip {
  if [[ $# -eq 0 ]]; then
    echo "No package given"
    return 1
  fi
  
  PACKAGE=$1
  PACKAGE_NAME=$(echo "$PACKAGE" | tr -s '==' '*' | cut -d'*' -f 1)

  { MAKEFLAGS="-j2" time pip install -vvv $PACKAGE; } 2>&1 | tee ${PACKAGE_NAME}-j2-$(date +"%s").log
}
```

No benefit was seen when running with `jip`.
Is this the same issue with setup.py or setuptools as with building Python?

--------------------------------

Can  I use OpenBLAS in place of Lapack and BLAS?

[Changes/OpenBLAS as default BLAS](https://fedoraproject.org/wiki/Changes/OpenBLAS_as_default_BLAS)

```sh
# OpenBLAS may satisfy both Lapack and BLAS dependencies.
apk add openblas openblas-dev

# lapack will install blas if it's not already. openblas has no effect.
apk add blas blas-dev
apk add lapack lapack-dev
```

Looked up versions for dependencies of libraries specified in the book that had release dates that were close.

```text
numpy==1.21.2                 2021-08-15
scipy==1.7.0                  2021-06-20
  Cython==0.29.24             2021-07-13
  pythran==0.10.0             2021-09-14
scikit-learn==1.0             2021-09-24
matplotlib==3.4.3             2021-08-12
pandas==1.3.2                 2021-08-15
```

Convenient install commands for experimentation.

```sh
tip numpy==1.21.2
tip Cython==0.29.24
tip pythran==0.10.0
tip scipy==1.7.0
tip scikit-learn==1.0
tip matplotlib==3.4.3
tip pandas==1.3.2
```

Original, non `tip` or `jip` commands that are unreadable.

```sh
{ time pip install -vvv numpy==1.21.2; } 2>&1 | tee numpy-$(date +"%s").log
{ time pip install -vvv scipy==1.7.0; } 2>&1 | tee scipy-$(date +"%s").log
{ time pip install -vvv scikit-learn==1.0; } 2>&1 | tee scikit-learn-$(date +"%s").log
{ time pip install -vvv matplotlib==3.4.3; } 2>&1 | tee matplotlib-$(date +"%s").log
{ time pip install -vvv pandas==1.3.2; } 2>&1 | tee pandas.log

{ MAKEFLAGS="-j2" time pip install -vvv numpy==1.21.2; } 2>&1 | tee numpy-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -vvv scipy==1.7.0; } 2>&1 | tee scipy-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -vvv scikit-learn==1.0; } 2>&1 | tee scikit-learn-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -vvv matplotlib==3.4.3; } 2>&1 | tee matplotlib-j2-$(date +"%s").log
{ MAKEFLAGS="-j2" time pip install -vvv pandas==1.3.2 2>&1; } | tee pandas-j2-$(date +"%s").log

MAKEFLAGS="-j2" pip install -vvv numpy==1.21.2 2>&1 | tee numpy-j2-$(date +"%s").log
```

## Library Installation Issues

### NumPy

```sh
tip numpy==1.21.2
```

`-vvv logging` shows `NOT AVAILABLE` warnings for Lapack, BLAS, OpenBLAS, ATLAS, and MKL\_RT.
NumPy still builds, but it uses the `numpy.linalg.lapack_lite` extension.

```text
2615   numpy_linalg_lapack_lite:
2616     FOUND:
2617       language = c
2618       define_macros = [('HAVE_BLAS_ILP64', None), ('BLAS_SYMBOL_SUFFIX', '64_')]
...
2706   building extension "numpy.linalg.lapack_lite" sources
2707   creating build/src.linux-x86_64-3.9/numpy/linalg
2708   ### Warning:  Using unoptimized lapack ###
2709   building extension "numpy.linalg._umath_linalg" sources
2710   ### Warning:  Using unoptimized lapack ###
...
3870   building 'numpy.linalg.lapack_lite' extension
...
3878   gcc: numpy/linalg/lapack_litemodule.c
3879   gcc: numpy/linalg/lapack_lite/python_xerbla.c
3880   gcc: numpy/linalg/lapack_lite/f2c_z_lapack.c
3881   gcc: numpy/linalg/lapack_lite/f2c_c_lapack.c
3882   gcc: numpy/linalg/lapack_lite/f2c_d_lapack.c
3883   gcc: numpy/linalg/lapack_lite/f2c_s_lapack.c
3884   gcc: numpy/linalg/lapack_lite/f2c_lapack.c
3885   gcc: numpy/linalg/lapack_lite/f2c_blas.c
3886   gcc: numpy/linalg/lapack_lite/f2c_config.c
```

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

Opted instead for OpenBLAS. Looks like Alpine just installs it as `blas`, `cblas`, and `lapack`.

```text
(p3.9.14) bash-5.1# apk list --installed | grep -i blas
openblas-dev-0.3.20-r0 x86_64 {openblas} (BSD-3-Clause) [installed]
openblas-ilp64-0.3.20-r0 x86_64 {openblas} (BSD-3-Clause) [installed]
openblas-0.3.20-r0 x86_64 {openblas} (BSD-3-Clause) [installed]
(p3.9.14) bash-5.1# apk list --installed | grep -i lapack
(p3.9.14) bash-5.1#
```
---
```text
2517     FOUND:
2518       libraries = ['cblas', 'blas', 'blas']
2519       library_dirs = ['/usr/lib']
2520       include_dirs = ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/include']
2521       language = c
2522       define_macros = [('HAVE_CBLAS', None)]
2523
2524     FOUND:
2525       define_macros = [('NO_ATLAS_INFO', 1), ('HAVE_CBLAS', None)]
2526       libraries = ['cblas', 'blas', 'blas']
2527       library_dirs = ['/usr/lib']
2528       include_dirs = ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/include']
2529       language = c
2530
...
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
---
```text
2474   openblas_info:
2475     libraries openblas not found in ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/lib', '/usr/local/lib', '/usr/lib', '/usr/lib/']
2476     NOT AVAILABLE
...
2537   openblas_lapack_info:
2538     libraries openblas not found in ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/lib', '/usr/local/lib', '/usr/lib', '/usr/lib/']
2539     NOT AVAILABLE
2540
2541   openblas_clapack_info:
2542     libraries openblas,lapack not found in ['/root/.pyenv/versions/3.9.14/envs/p3.9.14/lib', '/usr/local/lib', '/usr/lib', '/usr/lib/']
2543     NOT AVAILABLE
```

Looks like build dependencies get installed.

```text
2409   Successfully installed Cython-0.29.32 setuptools-49.1.3 wheel-0.36.2
2410   Installing build dependencies: finished with status 'done'
```

But in the end, it was only this.

```text
(p3.9.14) bash-5.1# pip list
Package    Version
---------- -------
numpy      1.21.2
pip        22.3
setuptools 58.1.0
```

\* Image committed as `dspy_numpy_openblas`.

### SciPy

```
tip scipy==1.7.0
```

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

This error made me go back and add Lapack and BLAS at first, but then I switched to OpenBLAS.
Then I rebuilt NumPy each time.

```text
  numpy.distutils.system_info.NotFoundError: No BLAS/LAPACK libraries found.
  To build Scipy from sources, BLAS & LAPACK libraries need to be installed.
  See site.cfg.example in the Scipy source directory and
  https://docs.scipy.org/doc/scipy/reference/building/index.html for details.
```

I noticed that despite installing NumPy 1.21.2 first, SciPy installs NumPy 1.19.3 and then NumPy 1.22.4. WTF?

```text
   1303   Collecting numpy==1.19.3
   1304     Downloading numpy-1.19.3.zip (7.3 MB)

   7598 Getting page https://pypi.org/simple/numpy/

   9929 Collecting numpy<1.23.0,>=1.16.5

   9933   https://files.pythonhosted.org:443 "GET /packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip HTTP/1.1" 200 11458830
   9934   Downloading numpy-1.22.4.zip (11.5 MB)
   9935   Ignoring unknown cache-control directive: immutable
   9936   Updating cache with response from "https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip   9936 "
   9937   etag object cached for 1209600 seconds
   9938   Caching due to etag
   9939      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 11.5/11.5 MB 16.2 MB/s eta 0:00:00
   9940   Added numpy<1.23.0,>=1.16.5 from https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip (from scipy==1.7.0) to build tracker '/tmp/pip-build-tracker-lwqe1nin'

  30178   Created wheel for numpy: filename=numpy-1.22.4-cp39-cp39-linux_x86_64.whl size=18434874 sha256=c2b27367ab27dca86b151bef939ffb4024e7c45dcc3d64df0fb685c708bd1d84

  30187 Successfully installed numpy-1.23.3 scipy-1.7.0
```
---
```sh
grep -n "1\.19\.3" scipy-1665549480.log | grep -i "numpy" | grep -v "Skipping"
```
---
```text
1303:  Collecting numpy==1.19.3
1304:    Downloading numpy-1.19.3.zip (7.3 MB)
3195:    Copying numpy.egg-info to build/bdist.linux-x86_64/wheel/numpy-1.19.3-py3.9.egg-info
3198:    creating build/bdist.linux-x86_64/wheel/numpy-1.19.3.dist-info/WHEEL
3199:    creating '/tmp/pip-wheel-d_143int/tmpelcfxara/numpy-1.19.3-cp39-cp39-linux_x86_64.whl' and adding 'build/bdist.linux-x86_64/wheel' to it
3677:    adding 'numpy-1.19.3.dist-info/LICENSE.txt'
3678:    adding 'numpy-1.19.3.dist-info/METADATA'
3679:    adding 'numpy-1.19.3.dist-info/WHEEL'
3680:    adding 'numpy-1.19.3.dist-info/entry_points.txt'
3681:    adding 'numpy-1.19.3.dist-info/top_level.txt'
3682:    adding 'numpy-1.19.3.dist-info/RECORD'
3685:    Created wheel for numpy: filename=numpy-1.19.3-cp39-cp39-linux_x86_64.whl size=13960463 sha256=00afca0b256296d7961ac252bc4cd1d1eb2271dce8537c27724ffe8da80127a0
3700:  Successfully installed Cython-0.29.32 beniget-0.3.0 decorator-5.1.1 gast-0.4.0 networkx-2.8.7 numpy-1.19.3 ply-3.11 pybind11-2.6.2 pythran-0.9.11 setuptools-57.5.0 six-1.16.0 wheel-0.36.2
9113:  Found link https://files.pythonhosted.org/packages/cb/c0/7b3d69e6ee68bc54c97ba51f8c3c3e43ff1dbc7bd97347cc19a1f944e60a/numpy-1.19.3.zip (from https://pypi.org/simple/numpy/) (requires-python:>=3.6), version: 1.19.3
```
---
```sh
grep -n "1\.22\.4" scipy-1665549480.log | grep -i "numpy" | grep -v "Skipping"
```
---
```text
9760:  Found link https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip (from https://pypi.org/simple/numpy/) (requires-python:>=3.8), version: 1.22.4
9931:  Looking up "https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip" in the cache
9933:  https://files.pythonhosted.org:443 "GET /packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip HTTP/1.1" 200 11458830
9934:  Downloading numpy-1.22.4.zip (11.5 MB)
9936:  Updating cache with response from "https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip"
9940:  Added numpy<1.23.0,>=1.16.5 from https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip (from scipy==1.7.0) to build tracker '/tmp/pip-build-tracker-lwqe1nin'
10023:  Source in /tmp/pip-install-h15lis92/numpy_73590603a01147148c432cbd338a179e has version 1.22.4, which satisfies requirement numpy<1.23.0,>=1.16.5 from https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip (from scipy==1.7.0)
10024:  Removed numpy<1.23.0,>=1.16.5 from https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip (from scipy==1.7.0) from build tracker '/tmp/pip-build-tracker-lwqe1nin'
27570:  set build/lib.linux-x86_64-3.9/numpy/_version.py to '1.22.4'
29277:  Copying numpy.egg-info to build/bdist.linux-x86_64/wheel/numpy-1.22.4-py3.9.egg-info
29280:  creating build/bdist.linux-x86_64/wheel/numpy-1.22.4.dist-info/WHEEL
29281:  creating '/tmp/pip-wheel-_bqakbnn/tmpkki6r3mb/numpy-1.22.4-cp39-cp39-linux_x86_64.whl' and adding 'build/bdist.linux-x86_64/wheel' to it
30087:  adding 'numpy-1.22.4.dist-info/LICENSE.txt'
30088:  adding 'numpy-1.22.4.dist-info/METADATA'
30089:  adding 'numpy-1.22.4.dist-info/WHEEL'
30090:  adding 'numpy-1.22.4.dist-info/entry_points.txt'
30091:  adding 'numpy-1.22.4.dist-info/top_level.txt'
30092:  adding 'numpy-1.22.4.dist-info/RECORD'
30178:  Created wheel for numpy: filename=numpy-1.22.4-cp39-cp39-linux_x86_64.whl size=18434874 sha256=c2b27367ab27dca86b151bef939ffb4024e7c45dcc3d64df0fb685c708bd1d84
```
---
```sh
grep -n "1\.23\.3" scipy-1665549480.log | grep -i "numpy" | grep -v "Skipping"
```
---
```text
9926:  Found link https://files.pythonhosted.org/packages/0a/88/f4f0c7a982efdf7bf22f283acf6009b29a9cc5835b684a49f8d3a4adb22f/numpy-1.23.3.tar.gz (from https://pypi.org/simple/numpy/) (requires-python:>=3.8), version: 1.23.3
30187:Successfully installed numpy-1.23.3 scipy-1.7.0
```
---
```sh
grep -in "numpy" scipy-1665549480.log | \
grep -v \
     -e Skipping \
     -e "adding 'numpy" \
     -e "copying numpy" \
     -e "copying build" \
     -e "copying build" \
     -e "creating build" \
     -e "Processing numpy" \
     -e "compile options" \
     -e "In file included" \
     -e "#warning" \
     -e "/lib/" \
     -e "/src/" \
     -e "/tmp/" \
     -e "INFO"
```
---
```text
9926:  Found link https://files.pythonhosted.org/packages/0a/88/f4f0c7a982efdf7bf22f283acf6009b29a9cc5835b684a49f8d3a4adb22f/numpy-1.23.3.tar.gz (from https://pypi.org/simple/numpy/) (requires-python:>=3.8), version: 1.23.3
30187:Successfully installed numpy-1.23.3 scipy-1.7.0
```

--------------------------------

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

But I don't remember where I ran into them...

--------------------------------

Decided to try a different way to build based on [Building SciPy from source](https://scipy.github.io/devdocs/dev/contributor/building.html#building-scipy-from-source).

```sh
{ time pip install -vvv scipy==1.7.0 --no-binary scipy; } 2>&1 | tee scipy-$(date +"%s").log
```

This should be fun...


# Resources:
### Ubuntu 22.04

* Install Python on Ubuntu 22.04
  * [How To Install Python on Ubuntu 22.04 LTS](https://idroot.us/install-python-ubuntu-22-04/)
  * [Install Python 3.9 or 3.8 on Ubuntu 22.04](https://www.how2shout.com/linux/install-python-3-9-or-3-8-on-ubuntu-22-04-lts-jammy-jellyfish/#6_Set_the_default_Python_version)
* `tzdata` issue on Ubuntu 22.04
  * [Passing default answers to apt-get package install questions?](https://serverfault.com/a/407358)
  * [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
  * [How to install tzdata on a ubuntu docker image?](https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image)
  * [apt-get install tzdata noninteractive](https://stackoverflow.com/a/67734239)

### Alpine, AKA compile everything from scratch

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

# Learned and Relearned

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

# Convenient Commands Redux

```sh
time docker build --progress=plain --no-cache -t dspy . 2>&1 | tee build_logs/docker-build-pyenv-$(date +"%s").log

docker build --progress=plain -t dspy .

docker build --progress=plain --no-cache -t dspy .

docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy

# committed a container with everything up to scipy installed based on lapack and blas
docker run -it --rm -v "$(pwd)/build_logs":/build_logs dspy_scipy_lapack_blas_01
```


