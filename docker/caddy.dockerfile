FROM caddy:2.5.1

RUN adduser aliveornot -D -H
USER aliveornot

COPY ./docker/files/Caddyfile /etc/caddy/Caddyfile
