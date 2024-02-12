#!/bin/bash

#
# Usage
#
usage() {
BANNER="NGINX App Protect WAF Compiler\n\n
This script is used to deploy/undeploy NGINX App Protect WAF Compiler using docker-compose\n\n
=== Usage:\n\n
$0 [options]\n\n
=== Options:\n\n
-h\t\t\t\t- This help\n
-C [file.crt]\t\t\t- Certificate file to pull packages from the NGINX repository\n
-K [file.key]\t\t\t- Key file to pull packages from the NGINX repository\n
-c [start|stop|restart]\t- Deployment command\n\n
=== Examples:\n\n
Deploy NAP Compiler :\t$0 -c start -C <NGINX_CERTIFICATE> -K <NGINX_KEY>\n
Remove NAP Compiler :\t$0 -c stop -C <NGINX_CERTIFICATE> -K <NGINX_KEY>\n
Restart NAP Compiler:\t$0 -c restart\n
"

echo -e $BANNER 2>&1
exit 1
}

#
# NGINX App Protect WAF Compiler
#
nap_compiler_start() {

# Docker compose variables
USERNAME=`whoami`
export USERID=`id -u $USERNAME`
export USERGROUP=`id -g $USERNAME`

echo "-> Updating docker images"
docker-compose -f $DOCKER_COMPOSE_YAML pull

echo "-> Deploying NGINX App Protect WAF Compiler"
COMPOSE_HTTP_TIMEOUT=240 docker-compose -p $PROJECT_NAME -f $DOCKER_COMPOSE_YAML up -d --remove-orphans
}

#
# NGINX App Protect WAF compiler removal
#
nap_compiler_stop() {

# Docker compose variables
USERNAME=`whoami`
export USERID=`id -u $USERNAME`
export USERGROUP=`id -g $USERNAME`

echo "-> Undeploying NGINX App Protect WAF Compiler"
COMPOSE_HTTP_TIMEOUT=240 docker-compose -p $PROJECT_NAME -f $DOCKER_COMPOSE_YAML down
}

#
# NGINX Declarative API restart
#
nap_compiler_restart() {
nap_compiler_stop
nap_compiler_start
}

#
# Main
#

DOCKER_COMPOSE_YAML="docker-compose.yaml"
PROJECT_NAME="nap-compiler"
export NGINX_CERT="unused"
export NGINX_KEY="unused"

while getopts 'hc:C:K:' OPTION
do
        case "$OPTION" in
                h)
			usage
                ;;
                c)
                        ACTION=$OPTARG
                ;;
                C)
                        export NGINX_CERT=$OPTARG
                ;;
                K)
                        export NGINX_KEY=$OPTARG
                ;;
        esac
done

if [ -z "${ACTION}" ] || [[ ! "${ACTION}" == +(start|stop|restart) ]] 
then
	usage
fi

if [ "${ACTION}" == "start" ] && ([ "${NGINX_CERT}" == "unused" ] || [ "${NGINX_KEY}" == "unused" ])
then
	usage
fi

case "$ACTION" in
    start)
        nap_compiler_start
        ;;
    stop)
        nap_compiler_stop
        ;;
    restart)
        nap_compiler_restart
        ;;
esac
