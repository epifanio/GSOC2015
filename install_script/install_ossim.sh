#!/usr/bin/env bash

apt-get -q update

apt-get install --assume-yes libtiff5 libfreetype6 libcurl3 libexpat1 libpng3 libfftw3-3  \
                             libgeotiff2 libqt4-core libqt4-opengl libpodofo0.9.0 libopenscenegraph99 \
							 libopenthreads14 libc6 libgcc1 libstdc++6 libgdal1h libgeos-c1 libgeos-3.4.2

wget -c --progress=dot:mega "http://download.osgeo.org/livedvd/data/ossim/deb/gpstk_2.5_amd64.deb" --output-document="/tmp/gpstk_2.5_amd64.deb"
dpkg -i /tmp/gpstk_2.5_amd64.deb

wget -c --progress=dot:mega "http://download.osgeo.org/livedvd/data/ossim/deb/ossim_1.18.19_amd64.deb" --output-document="/tmp/ossim_1.18.19_amd64.deb"
dpkg -i /tmp/ossim_1.18.19_amd64.deb

wget -c --progress=dot:mega "http://download.osgeo.org/livedvd/data/ossim/deb/ossim-share_1.18.19_all.deb" --output-document="/tmp/ossim-share_1.18.19_all.deb"
dpkg -i /tmp/ossim-share_1.18.19_all.deb

