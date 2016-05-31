#!/usr/bin/env bash

git clone https://github.com/epifanio/CesiumWidget /tmp/CesiumWidget
cd /tmp/CesiumWidget
/home/main/miniconda3/bin/python setup.py install --user
jupyter nbextension install CesiumWidget/static/CesiumWidget --user --quiet

