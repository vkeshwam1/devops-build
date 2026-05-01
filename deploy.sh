#!/bin/bash
set -e

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUILD_NUM=${BUILD_NUMBER:-local}

if [ "$BRANCH" = "master" ]; then
  IMAGE="vkeshwam1/prod:latest"
else
  IMAGE="vkeshwam1/dev:latest"
fi

echo "Deploying image: $IMAGE"
docker pull $IMAGE
docker stop app 2>/dev/null || true
docker rm app 2>/dev/null || true
docker run -d --name app -p 80:80 --restart always $IMAGE
echo "Deployed successfully: $IMAGE"
