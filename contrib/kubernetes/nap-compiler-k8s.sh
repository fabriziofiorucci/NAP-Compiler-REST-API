#!/bin/bash

NAMESPACE=nap-compiler

case $1 in
        'start')
                kubectl create namespace $NAMESPACE

                kubectl create configmap global-settings -n $NAMESPACE --from-file=../../etc/global_settings.json
                kubectl create configmap uds -n $NAMESPACE --from-file=../../etc/uds.json
                kubectl apply -n $NAMESPACE -f kubernetes.yaml
        ;;
        'stop')
                kubectl delete namespace $NAMESPACE
        ;;
        *)
                echo "$0 [start|stop]"
        ;;
esac
