#!/bin/bash

B64=$(base64 < my-secret)
sed "s/{{SECRET}}/$B64/" < my-secret.yaml | kubectl create -f -
