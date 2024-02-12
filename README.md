# REST API for NGINX App Protect WAF Compiler

This repository provides a set of REST API to use the NGINX App Protect policy compiler within an automation pipeline.
The service can be run either on `docker-compose` or on `Kubernetes`.

## Requirements

- NGINX App Protect WAF Compiler
- docker version v24+ to build the image
- One of:
  - docker-compose v2.20+
  - kuberetes cluster

## Building the Docker image

The docker image can be built using:

```
docker build --no-cache -f Dockerfile \
  --secret id=nginx-key,src=<NGINX_KEY_FILE> --secret id=nginx-crt,src=<NGINX_CERTIFICATE_FILE> \
  -t <DESTINATION_DOCKER_IMAGE_NAME:TAG> .
```

Example:

```
docker build --no-cache -f Dockerfile \
  --secret id=nginx-key,src=/etc/ssl/nginx/nginx-repo.key --secret id=nginx-crt,src=/etc/ssl/nginx/nginx-repo.crt \
  -t nap-compiler:latest .
```

Note: the docker image is automatically built by the `docker-compose.yaml` in the example

## How to run

This repository can be run on:

- [Docker compose](contrib/docker-compose)
- [Kubernetes](contrib/kubernetes)

and tested through the [examples](contrib/examples) provided
