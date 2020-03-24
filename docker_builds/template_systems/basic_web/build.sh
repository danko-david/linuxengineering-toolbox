#!/bin/bash

cd "$(dirname `readlink -f "$0"`)"

cd ../../..

#compile the `lxe_basic_server` image which is required by this image
if [[ "$(docker images -q lxe_basic_server 2> /dev/null)" == "" ]]; then
	./docker_builds/template_systems/basic_server/build.sh
fi

docker image build -t lxe_basic_web -f ./docker_builds/template_systems/basic_web/Dockerfile .

