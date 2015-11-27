#!/usr/bin/env bash
chown -Rf postgres:postgres /data/postgresql
chmod -R 700 /data/postgresql
sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf