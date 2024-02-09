# REST API for NGINX App Protect WAF Compiler

## Requirements

- NGINX App Protect WAF Compiler
- docker version v24+
- docker-compose v2.20+

## How to run

```
./nap-compiler.sh -c start -C <NGINX_CERTIFICATE_FILE> -K <NGINX_KEY_FILE>
```

Example:

```
./nap-compiler.sh -c start -C /etc/ssl/nginx/nginx-repo.crt -K /etc/ssl/nginx/nginx-repo.key
```

## How to stop

```
./nap-compiler.sh -c stop
```

## How to test

```
cd examples
./compileTest.sh xss-allowed.json > output.json
```
