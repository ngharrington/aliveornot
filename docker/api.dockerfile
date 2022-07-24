FROM python:3.9.13-slim

EXPOSE 5000
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip

RUN adduser worker --disabled-login --disabled-password
USER worker

COPY --chown=worker:worker ./docker/files/Caddyfile /etc/caddy/Caddyfile

WORKDIR /code

COPY --chown=worker:worker ./api /code/

RUN ls /code

RUN pip install --no-cache-dir --no-warn-script-location --upgrade -r /code/requirements.txt
