#!/bin/bash

NAMESPACE=nap-compiler

case $1 in
        'start')
                kubectl create namespace $NAMESPACE
                kubectl apply -n $NAMESPACE -f kubernetes.yaml
        ;;
        'stop')
                kubectl delete namespace $NAMESPACE
        ;;
        *)
                echo "$0 [start|stop]"
        ;;
esac
