#!/bin/bash

docker image build -t alizkan/l4t-aio-distro-builder:latest "$(dirname "$(dirname "$(readlink -f "$0")")")"
