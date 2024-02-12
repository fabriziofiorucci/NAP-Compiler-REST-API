# Running on docker-compose

The `docker-compose.yaml` file builds the docker image and runs the container

```
cd contrib/docker-compose
./nap-compiler.sh -c start -C <NGINX_CERTIFICATE_FILE> -K <NGINX_KEY_FILE>
```

Example:

```
cd contrib/docker-compose
./nap-compiler.sh -c start -C /etc/ssl/nginx/nginx-repo.crt -K /etc/ssl/nginx/nginx-repo.key
```

## How to stop

```
cd contrib/docker-compose
./nap-compiler.sh -c stop
```
