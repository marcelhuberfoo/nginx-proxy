#!/bin/sh

. ./build_params.sh

count=0
while [ true ]; do echo "[${count}min]"; count=$(($count+1)); sleep 60; done&
min_pid=$!

revision=$(git describe --abbrev=0 --tags)-$(git rev-list --count $(git describe --abbrev=0 --tags)..)-g$(git log -1 --format=%h)

docker build \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  --build-arg IMAGE_VERSION=$revision \
  --tag=$docker_image --file=$docker_file $docker_context

ret_code=$?
kill $min_pid
exit $ret_code

