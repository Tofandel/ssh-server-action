#!/bin/sh

docker build -t "29a95e:$GITHUB_SHA" -f image/Dockerfile image

docker_run="docker run -d -p 22:$INPUT_PORT 29a95e:$GITHUB_SHA"

docker_run="$docker_run -e INPUT_USER_NAME -e INPUT_USER_PASSWORD -e INPUT_PASSWORD_ACCESS -e INPUT_SUDO_ACCESS -e INPUT_PUBLIC_KEY -e INPUT_PUBLIC_KEY_URL"

sh -c "$docker_run"