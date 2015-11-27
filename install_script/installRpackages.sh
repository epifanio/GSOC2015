#!/usr/bin/env bash
wget --progress=dot:mega http://epinux.com/rspatial_1.0_amd64.deb --output-document="/tmp/rspatial_1.0_amd64.deb"
dpkg -i /tmp/rspatial_1.0_amd64.deb