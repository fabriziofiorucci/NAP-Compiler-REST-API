#!/bin/bash

if [ "$1" = "" ]
then
	echo "$0 [NAP policy file.json]"
	exit
fi

curl -X POST http://127.0.0.1:6000/v1/compile/policy -H "Content-Type: application/json" -d @$1
