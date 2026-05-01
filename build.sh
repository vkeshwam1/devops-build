#!/bin/bash
set -e

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUILD_NUM=${BUILD_NUMBER:-local}

if [ "$BRANCH" = "master" ]; then
  IMAGE="vkeshwam1/prod:$BUILD_NUM"
else
  IMAGE="vkeshwam1/dev:$BUILD_NUM"
fi

echo "Building image: $IMAGE"
docker build -t $IMAGE .
docker tag $IMAGE ${IMAGE%:*}:latest
echo "Build complete: $IMAGE"
