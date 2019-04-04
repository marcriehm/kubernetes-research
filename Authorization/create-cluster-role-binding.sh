#!/bin/bash

#
# Create a ClusterRoleBinding between the given subject (user or group - usually an e-mail address)
# and an existing ClusterRole.
# The CRB is named and tagged appropriately.
#

if [[ $# -ne 3 || ( "$1" != "User" && "$1" != "Group" ) ]]
then
	echo "Usage: $0 \"User\"|\"Group\" SUBJECT ROLE" 1>&2
	exit 1
fi

USER_GROUP="$1"
SUBJECT="$2"
ROLE="$3"

SUBJECT_BASE="$(echo ${SUBJECT} | sed 's/@[a-zA-Z0-9_\-]*\.[a-zA-Z0-9_\-]*//')"

cat <<EOF | kubectl apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: crb_${USER_GROUP}_${SUBJECT_BASE}_${ROLE}
  labels:
    subject: ${SUBJECT_BASE}
    role: ${ROLE}
subjects:
- kind: ${USER_GROUP}
  name: ${SUBJECT}
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: ${ROLE}
  apiGroup: rbac.authorization.k8s.io
EOF

