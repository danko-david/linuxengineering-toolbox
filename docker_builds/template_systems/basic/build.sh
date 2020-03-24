#!/bin/bash

cd "$(dirname `readlink -f "$0"`)"

cd ../../..

docker image build -t lxe_basic -f ./docker_builds/template_systems/basic/Dockerfile .

#docker run -it lxe_basic
