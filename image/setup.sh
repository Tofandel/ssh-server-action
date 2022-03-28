#!/bin/sh

mkdir ~/.ssh/
(umask 066; touch ~/.ssh/authorized_keys)
ssh-keygen -A