# syntax=docker/dockerfile:1
ARG BASE_IMAGE=private-registry.nginx.com/nap/waf-compiler:1.0.0
FROM ${BASE_IMAGE}

# Installing packages as root
USER root

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /compiler

# REST API wrapper
COPY src src/

RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget \
        gnupg2 \
        ubuntu-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | \
    tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null \
    && printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && sed -i 's/pkgs.nginx.com/pkgs.nginx.com/g' /etc/apt/apt.conf.d/90pkgs-nginx \
    && apt-get update \
    && apt-get install -y \
        app-protect-attack-signatures \
        app-protect-bot-signatures \
        app-protect-threat-campaigns && \

	apt-get -y install python3 python3-venv && \
	python3 -m venv /compiler/env/ && \
	. /compiler/env/bin/activate && \
	pip3 install --no-cache --upgrade pip setuptools virtualenv && \
	python3 -m pip install --upgrade pip && \
	pip3 install -r /compiler/src/requirements.txt

# non-root default user
USER nginx

ENTRYPOINT [ "/compiler/src/start.sh" ]
