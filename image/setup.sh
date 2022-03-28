#!/bin/sh

mkdir -p ~/.ssh/
(umask 066; touch ~/.ssh/authorized_keys)
ssh-keygen -A