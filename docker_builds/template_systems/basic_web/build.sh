#!/bin/bash

cd "$(dirname `readlink -f "$0"`)"

cd ../../..

#compile the `lxe_basic_server` image which is required by this image
./docker_builds/template_systems/basic_server/build.sh

docker image build -t lxe_basic_server -f ./docker_builds/template_systems/basic_web/Dockerfile .

