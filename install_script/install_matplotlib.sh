#!/bin/bash
git clone https://github.com/matplotlib/matplotlib
cd matplotlib
mv /tmp/setup.cfg .
/home/main/anaconda3/bin/python setup.py install
cd ..
rm -rf matplotlib