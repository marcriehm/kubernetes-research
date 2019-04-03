#!/bin/bash

# This script needs to be modified to use a Jonah docker repo

mvn package

docker build -f Dockerfile1 -t mriehm/ip-webapp:v1 .
docker build -f Dockerfile2 -t mriehm/ip-webapp:v2 .
docker push mriehm/ip-webapp:v1
docker push mriehm/ip-webapp:v2
