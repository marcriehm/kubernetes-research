#!/bin/bash

#
# In practice one would never commit the actual secret (file my-secret) to version
# control. Instead, one would use the shell, something like this script, and then
# clean up afterwards.
#
B64=$(base64 < my-secret)
sed "s/{{SECRET}}/$B64/" < my-secret.yaml | kubectl create -f -
