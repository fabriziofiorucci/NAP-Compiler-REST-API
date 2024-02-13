# Testing the REST API

To test the REST API:

```
./nap-compiler-test.sh <docker-compose|kubernetes> <policy|log|info> <INPUT_FILE> [<OPTIONAL_CUSTOM_SIGNATURES_FILE>] | jq
```

## Examples - docker-compose deployment

Policy compilation:

```
./nap-compiler-test.sh docker-compose policy policies/xss-allowed.json signatures/uds.conf > output.json
```

Log profile compilation:

```
./nap-compiler-test.sh docker-compose log logprofiles/customlog.json > output.json
```

Bundle information retrieval:

```
./nap-compiler-test.sh docker-compose info bundles/test-bundle.tgz > output.json
```

## Examples - docker-compose deployment

Policy compilation:

```
./nap-compiler-test.sh kubernetes policy policies/xss-allowed.json signatures/uds.conf > output.json
```

Log profile compilation:

```
./nap-compiler-test.sh kubernetes log logformat.custom.json > output.json
```

Bundle information retrieval:

```
./nap-compiler-test.sh kubernetes info bundles/test-bundle.tgz > output.json
```
