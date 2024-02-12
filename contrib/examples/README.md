# Testing the REST API

To test the REST API:

```
cd contrib/examples
./nap-compiler-test.sh [docker-compose|kubernetes] <NGINX_APP_PROTECT_POLICY_FILE> | jq
```

## Examples

To test when deployed on docker-compose:

```
cd contrib/examples
./nap-compiler-test.sh docker-compose xss-allowed.json > output.json
```

To test when deployed on Kubernetes:

```
cd contrib/examples
./nap-compiler-test.sh kubernetes xss-allowed.json > output.json
```

Note: when testing on Kubernetes modify the URL FQDN in `nap-compiler-test.sh`
