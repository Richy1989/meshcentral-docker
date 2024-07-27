#!/bin/bash

docker buildx build --build-arg UID=99 --build-arg GID=100 --build-arg PREINSTALL_LIBS=false --push \
            --tag richy1989/meshcentral:latest \
            --tag richy1989/meshcentral:$(npm show meshcentral version) \
            --platform linux/amd64 .