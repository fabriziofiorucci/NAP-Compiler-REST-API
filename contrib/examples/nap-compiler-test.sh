#!/bin/bash

if [ "$2" = "" ]
then
	echo "$0 [docker-compose|kubernetes] [NAP policy file.json]"
	exit
fi

POLICYFILE=$2

case "$1" in
	'docker-compose')
		URL=http://127.0.0.1:6000/v1/compile/policy
	;;
	'kubernetes')
		URL=http://nap-compiler.k8s.f5.ff.lan/v1/compile/policy
	;;
	*)
		echo "Invalid parameter $1 should be either 'docker-compose' or 'kubernetes'"
		exit
	;;
esac


curl -X POST $URL -H "Content-Type: application/json" -d @$POLICYFILE
