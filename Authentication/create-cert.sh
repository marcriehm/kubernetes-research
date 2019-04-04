#!/bin/bash

#
# Convenience script to generate a key and a certificate signing request. Process the CSR (approving it).
# Generate a (signed) certificate file. 
# Notes:
#	This is a convenience script and, because it signs the CSR automatically, should not be used in production;
#	This script relies on a valid, admin context (kubectl config use-context) being available for kubectl.
#	This script relies on openssl.
#	This script relies on the 'base64' utility, and it may require modification to work with your version of base64.
#

if [[ $# -ne 2 ]]
then
	echo "Usage: $0 EMAIL GROUP" 1>&2
	exit 1
fi

EMAIL="$1"
GROUP="$2"

BASE="$(echo ${EMAIL} | sed 's/@[a-zA-Z0-9_\-]*\.[a-zA-Z0-9_\-]*//')"
KEY="${BASE}.key"
CSR="${BASE}.csr"
CRT="${BASE}.crt"

rm -f "${KEY}" "${CSR}" "${CRT}"

openssl genrsa -out "${KEY}" 2048
chmod u-w,g-w,g-r,o-w,o-r "${KEY}"
openssl req -new -key "${KEY}" -out "${CSR}" -subj "/CN=${EMAIL}/O=${GROUP}"

cat <<EOF >"${CSR}"
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${CSR}
spec:
  groups:
  - system:authenticated
  request: $(cat ${CSR} | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

kubectl apply -f "${CSR}"
kubectl get csr
kubectl certificate approve "${CSR}"
kubectl get csr
kubectl get csr "${CSR}" -o jsonpath='{.status.certificate}' | base64 -d > "${CRT}"
kubectl delete csr "${CSR}"
rm -f "${CSR}"
