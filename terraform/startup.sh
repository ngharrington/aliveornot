#!/bin/bash
set -e

# Prepare the static files, the docker-compose file, and the caddy env variable file
rm -f /root/assets.tar.gz
rm -rf /home/aliveornot/build
s3cmd get s3://aliveornot/aliveornot/assets.tar.gz /root/assets.tar.gz
mv /root/assets.tar.gz /home/aliveornot/assets.tar.gz
cd /home/aliveornot
tar xzvf /home/aliveornot/assets.tar.gz


# Prepare the sqlite db
rm -f /home/aliveornot/build/db.sqlite
s3cmd get s3://aliveornot/aliveornot/db.sqlite /home/aliveornot/build/db.sqlite

# make aliveornot user the owner
sudo chown -R aliveornot:aliveornot /home/aliveornot/build

