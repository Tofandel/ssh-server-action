#!/bin/sh

cp -a image/entrypoint.sh image/entrypoint.tpl
envsubst < image/entrypoint.tpl > image/entrypoint.sh
docker build -t "29a95e:$GITHUB_SHA" -f image/Dockerfile image
docker run -d -p "$INPUT_PORT:22" "29a95e:$GITHUB_SHA"