#!/bin/bash
set -e


# Prepare the static files, the docker-compose file, and the caddy env variable file
rm -f /home/aliveornot/assets.tar.gz
rm -rf /home/aliveornot/build

if [ "$HOME" = "/root" ];
then
    cp ${HOME}/.s3cfg /home/aliveornot/.s3cfg;
    chown aliveornot:aliveornot /home/aliveornot/.s3cfg;
    cp ${HOME}/.s3cfg /home/woodward/.s3cfg;
    chown aliveornot:aliveornot /home/woodward/.s3cfg;
fi

# Prepare the sqlite db
rm -f /home/aliveornot/build/db.sqlite
s3cmd get s3://aliveornot/aliveornot/db.sqlite /home/aliveornot/build/db.sqlite

# get static assets and docker-compose files.
s3cmd get s3://aliveornot/aliveornot/assets.tar.gz /home/aliveornot/assets.tar.gz
cd /home/aliveornot
tar xzvf /home/aliveornot/assets.tar.gz


# make aliveornot user the owner
chown -R aliveornot:aliveornot /home/aliveornot/assets.tar.gz
chown -R aliveornot:aliveornot /home/aliveornot/build

# set up the systemd unit for the compose service
cat >/etc/systemd/system/docker-compose@aliveornot.service <<EOL
[Unit]
Description=%i service with docker compose
PartOf=docker.service
After=docker.service

[Service]
Type=oneshot
User=aliveornot
Group=aliveornot
RemainAfterExit=true
WorkingDirectory=/home/aliveornot/build
ExecStart=/usr/bin/docker compose up -d --remove-orphans
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOL




# Prepare the sqlite db
rm -f /home/woodward/db.sqlite
s3cmd get s3://aliveornot/woodward/db.sqlite /home/woodward/db.sqlite


# Prepare the sqlite db
rm -rf /home/woodward/build /home/woodward/docker-compose.yml
s3cmd get s3://aliveornot/woodward/assets.tar.gz /home/woodward/assets.tar.gz
cd /home/woodward
tar xzvf /home/woodward/assets.tar.gz
mv build/* .
rm -rf assets.tar.gz build


rm -f /root/pw.txt
s3cmd get s3://aliveornot/woodward/pw.txt /root/pw.txt
export PW="$(cat /root/pw.txt)"


# make aliveornot user the owner
chown -R woodward:woodward /home/woodward/docker-compose.yml
# set up the systemd unit for the compose service
cat >/etc/systemd/system/docker-compose@woodward.service <<EOL
[Unit]
Description=%i service with docker compose
PartOf=docker.service
After=docker.service

[Service]
Type=oneshot
User=woodward
Group=woodward
Environment=WOODWARD_ADMIN_CREDENTIAL=${PW}
RemainAfterExit=true
WorkingDirectory=/home/woodward
ExecStart=/usr/bin/docker compose up -d --remove-orphans
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOL




echo "stopping service and reloading daemons"
systemctl daemon-reload
systemctl stop docker-compose@aliveornot
systemctl stop docker-compose@woodward

echo "pruning docker objects"
docker system prune -a -f

echo "starting service"
systemctl start docker-compose@aliveornot
systemctl start docker-compose@woodward



# Journal isn't working until a restart
# Thinking I"m running into some of these problems
# https://www.digitalocean.com/community/questions/journalctl-command-shows-no-logs
# https://www.digitalocean.com/community/questions/ubuntu-journal-is-broken-on-boot
# TODO: Dig deeper on this but this is fine for now.
systemctl restart systemd-journald