apt-get -qq update && apt-get -qq install -yq --no-install-recommends \
                                                  postgresql-9.4 \
                                                  postgresql-client-9.4 \
                                                  postgresql-contrib-9.4 \
                                                  postgis postgresql-9.4-postgis-2.1 \
                                                  postgresql-contrib \
                                                  nano && apt-get clean
