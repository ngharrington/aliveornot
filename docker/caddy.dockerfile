FROM caddy:2.5.1

RUN adduser aliveornot -D -H
RUN chown -R aliveornot:aliveornot /data
USER aliveornot

COPY ./docker/files/Caddyfile /etc/caddy/Caddyfile
