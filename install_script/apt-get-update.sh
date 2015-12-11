#!/usr/bin/env bash

apt-get update && apt-get upgrade -yq
apt-get install software-properties-common -yq
add-apt-repository ppa:osgeolive/release-9.0 -y
apt-get update && apt-get upgrade -yq

apt-get install -y locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
      && locale-gen en_US.utf8 \
      && /usr/sbin/update-locale LANG=en_US.UTF-8

# After this operation, 726 MB of additional disk space will be used.
apt-get install -y ruby ruby-dev julia octave postgresql-9.3-postgis-2.1 rubygems-integration \
	postgresql-server-dev-9.3 libreadline6-dev mlocate pkg-config \
		libfreetype6-dev tk8.4-dev tcl8.4-dev unzip cmake-curses-gui mapserver-bin wget gcc make python-dev python-pip

# python modules to run system python 2 kernel (needed for grass)
#/usr/bin/pip install ipykernel
#/usr/bin/pip install decorator
#/usr/bin/pip install ipython_genutils
#/usr/bin/pip install pexpect
#/usr/bin/pip install pickleshare
#/usr/bin/pip install simplegeneric
#/usr/bin/pip install pyzmq

# apt-add-repository --yes ppa:grass/grass-stable
apt-get --quiet update
apt-get --yes install grass-core