#!/bin/sh

TAG=${GITHUB_SHA:-local}

envsubst < build/setup.tpl.sh | sed -e 's/§/$/g' > build/setup.sh
envsubst < build/entrypoint.tpl.sh | sed -e 's/§/$/g' > build/entrypoint.sh
docker build -t "29a95e:$TAG" build
docker run -d -p "$INPUT_PORT:22" --hostname "$INPUT_HOSTNAME" "29a95e:$TAG"
