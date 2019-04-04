#!/bin/bash

#
# Modify the kubectl 'config' file to add the given user (as an e-mail address) and add a context.
#

if [[ $# -ne 2 ]]
then
	echo "Usage: $0 EMAIL CLUSTER" 1>&2
	exit 1
fi

EMAIL="$1"
CLUSTER="$2"

BASE="$(echo ${EMAIL} | sed 's/@[a-zA-Z0-9_\-]*\.[a-zA-Z0-9_\-]*//')"
KEY="${BASE}.key"
CRT="${BASE}.crt"
CONTEXT="${BASE}.context"

kubectl config set-credentials "${EMAIL}" --client-certificate="${CRT}" --client-key="${KEY}" --embed-certs=true
kubectl config set-context "${CONTEXT}" --cluster="${CLUSTER}" --user="${EMAIL}"
