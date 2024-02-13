#!/bin/bash

if [ "$3" = "" ]
then
	echo "$0 [docker-compose|kubernetes] [policy|log|info] [inputfile] [user-signatures]"
	exit
fi

DEPLOYMENT_TYPE=$1
REQUEST_TYPE=$2
INPUTFILE=`cat $3 | base64 -w0`

if [ ! "$4" == "" ]
then
	USERSIGS=`cat $4 | base64 -w0`
else
	USERSIGS=""
fi

case "$DEPLOYMENT_TYPE" in
	'docker-compose')
		FQDN=127.0.0.1:6000
	;;
	'kubernetes')
		FQDN=nap-compiler.k8s.f5.ff.lan
	;;
	*)
		echo "Invalid parameter '$DEPLOYMENT_TYPE' should be one of 'docker-compose', 'kubernetes'"
		exit
	;;
esac

case "$REQUEST_TYPE" in
	'policy')
		# Payload format: {"user-signatures": "<BASE64_ENCODED_USER_SIGNATURE_JSON>", "policy": "<BASE64_ENCODED_POLICY_JSON>"}
		URI=/v1/compile/policy
		PAYLOAD={\"user-signatures\":\"$USERSIGS\",\"policy\":\"$INPUTFILE\"}
	;;
	'log')
		# Payload format: {"logprofile": "<BASE64_ENCODED_LOG_PROFILE_JSON>"}
		URI=/v1/compile/logprofile
		PAYLOAD={\"logprofile\":\"$INPUTFILE\"}
	;;
	'info')
		# Payload format: {"bundle": "<BASE64_ENCODED_TGZ_BUNDLE>"}
		URI=/v1/bundle/info
		PAYLOAD={\"bundle\":\"$INPUTFILE\"}
	;;
	*)
		echo "Invalid parameter '$REQUEST_TYPE' should be one of 'policy', 'log', 'info'"
		exit
	;;
esac

TMPFILE=`tempfile`
echo $PAYLOAD > $TMPFILE

URL=http://$FQDN$URI

curl -sX POST $URL -H "Content-Type: application/json" -d @$TMPFILE
rm $TMPFILE
