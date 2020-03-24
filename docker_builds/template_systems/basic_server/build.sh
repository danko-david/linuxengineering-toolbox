#!/bin/bash

cd "$(dirname `readlink -f "$0"`)"

#This requires to compile the `basic` image.
cd ../../..

#compile the `lxc_basic` image which is required by this image
./docker_builds/template_systems/basic/build.sh

docker image build -t lxe_basic_server -f ./docker_builds/template_systems/basic_server/Dockerfile .
