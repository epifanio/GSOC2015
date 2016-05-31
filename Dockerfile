FROM andrewosh/binder-base

MAINTAINER Massimo Di Stefano <epiesasha@me.com>

USER root

ADD install_script/apt-get-update.sh /tmp/apt-get-update.sh
RUN /tmp/apt-get-update.sh

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

#RUN /usr/bin/gem install gist
#RUN /usr/bin/gem install fpm


#RUN useradd -m -s /bin/bash main
RUN echo "root:root" | chpasswd
RUN echo "main:main" | chpasswd

#RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.6.0/tini && \
#    echo "d5ed732199c36a1189320e6c4859f0169e950692f451c03e7854243b95f4234b *tini" | sha256sum -c - && \
#    mv tini /usr/local/bin/tini && \
#    chmod +x /usr/local/bin/tini
	

USER main

ENV HOME /home/main
ENV SHELL /bin/bash

ENV USER main
WORKDIR $HOME

# add osgeolive data
ADD install_script/getdata.sh /tmp/getdata.sh
RUN bash /tmp/getdata.sh

# add GSOC notebooks
RUN mkdir -p /home/main/notebooks/GSOC/docs
COPY GSOC /home/main/notebooks/GSOC
COPY docs/images /home/main/notebooks/GSOC/docs/images

# setup postgresql
USER root

RUN useradd -m -s /bin/bash postgres
RUN echo "postgres:postgres" | chpasswd



RUN apt-get -qq update && apt-get -qq install -yq --no-install-recommends postgresql-9.4 \
                                                  postgresql-client-9.4 \
                                                  postgresql-contrib-9.4 \
                                                  postgis postgresql-9.4-postgis-2.1 \
                                                  postgresql-contrib \
                                                  nano && apt-get clean
                                                  
#ADD install_script/install_db.sh /tmp/install_db.sh
#RUN /tmp/install_db.sh

USER postgres

# start db and make new user and db (osgeo) listening from all host
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER main WITH SUPERUSER PASSWORD 'main';" &&\
    createdb -O main main

# add naturalhear data into postgis
ADD install_script/natualearth.sh /tmp/natualearth.sh
RUN /tmp/natualearth.sh

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

USER main

RUN wget --progress=dot:mega https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh --output-document=/home/main/Miniconda3-latest-Linux-x86_64.sh
RUN bash /home/main/Miniconda3-latest-Linux-x86_64.sh -b && rm -rf /home/main/Miniconda3-latest-Linux-x86_64.sh

ENV PATH $HOME/miniconda3/bin:$PATH

# [geos gdal proj4 readline sphinx freetype] Total:        175.0 MB
RUN conda install -y gcc geos gdal proj4 readline sphinx freetype

# add some DOCS from osgeolive
COPY docs /tmp/docs
ADD install_script/build_docs.sh /tmp/build_docs.sh
RUN /tmp/build_docs.sh

ADD install_script/start-notebook.sh /home/main/start-notebook.sh

## Install Julia kernel

#RUN julia -e 'Pkg.add("IJulia")' && julia -e 'Pkg.add("Gadfly")' && julia -e 'Pkg.add("RDatasets")'

## Install R kernel (and r-essential packages ~ 110mb) Total:       174.5 MB
RUN conda install -y -c r r-essentials

#ADD script/installRpackages.sh /tmp/installRpackages.sh
#RUN bash /tmp/installRpackages.sh

ADD install_script/condalist.txt /tmp/condalist.txt
RUN conda install -y --file /tmp/condalist.txt

ADD install_script/condalist-IOOS.txt /tmp/condalist-IOOS.txt
RUN conda install -y -c IOOS --file /tmp/condalist-IOOS.txt

USER root
RUN apt-get -y install libreadline6-dev

USER main
ADD install_script/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

#
# RUN pip install git+https://github.com/calysto/octave_kernel --user

COPY install_script/pygrass /home/main/.local/share/jupyter/kernels/pygrass


RUN pip install -U ipywidgets --user
#

RUN python -m bash_kernel.install

ADD install_script/cesiumwidget.sh /tmp/cesiumwidget.sh
RUN /tmp/cesiumwidget.sh

#ADD install_script/install_nbextension.sh /tmp/install_nbextension.sh
#RUN /tmp/install_nbextension.sh


USER root

#ADD install_script/install_ossim.sh /tmp/install_ossim.sh
#RUN /tmp/install_ossim.sh

RUN apt-get install -y ossim-core

RUN chmod a+x /home/main/start-notebook.sh
ADD install_script/pgstart.sh /usr/local/bin/pgstart.sh
COPY GSOC /home/main/notebooks/GSOC
COPY docs/images /home/main/notebooks/GSOC/docs/images
RUN chmod -R 777 /home/main/notebooks
RUN chown -R main:main /home/main/notebooks

#RUN /usr/bin/pip install ipykernel
RUN /home/main/miniconda3/bin/conda clean -pt -y
RUN rm -rf /tmp/*
RUN apt-get clean

RUN apt-get install -y mlocate
RUN updatedb

USER main

#EXPOSE 8888

ENV LD_LIBRARY_PATH /usr/lib/grass70/lib:/usr/local/lib:/usr/lib/:$LD_LIBRARY_PATH
ENV PYTHONPATH /usr/lib/grass70/etc/python:$PYTHONPATH
ENV GISBASE /usr/lib/grass70/
ENV PATH /usr/local/bin:/usr/lib/grass70/bin:/usr/lib/grass70/scripts:$PATH
ENV GIS_LOCK 77
ENV GISRC /home/main/.grass7/rc
ENV GISDBASE /home/main/notebooks/data/grass7data/
ENV OSSIM_PREFS_FILE /usr/local/share/ossim/ossim_preference

#WORKDIR /home/main/notebooks
#ENTRYPOINT ["tini", "--"]
#CMD ["/home/main/start-notebook.sh"]
