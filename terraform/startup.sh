#!/bin/bash
set -e

rm -f /root/assets.tar.gz
rm -rf /home/aliveornot/build
s3cmd get s3://aliveornot/aliveornot/assets.tar.gz /root/assets.tar.gz
mv /root/assets.tar.gz /home/aliveornot/assets.tar.gz
cd /home/aliveornot
tar xzvf /home/aliveornot/assets.tar.gz
docker compose up -d