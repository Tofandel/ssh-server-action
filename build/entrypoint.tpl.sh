#!/bin/sh

echo "Running ssh server for $INPUT_USER_NAME"
[ -n "$INPUT_DEBUG" ] && /usr/sbin/sshd -D -d -d -d
[ -z "$INPUT_DEBUG" ] && /usr/sbin/sshd -D