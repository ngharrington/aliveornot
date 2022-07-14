FROM caddy:2.5.1

RUN adduser aliveornot --disabled-login --disabled-password
USER aliveornot

COPY ./docker/files/Caddyfile /etc/caddy/Caddyfile
