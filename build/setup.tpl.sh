#!/bin/sh

ssh-keygen -A
sed -i -E "s|(AuthorizedKeysFile).*|\1 %h/.ssh/authorized_keys|g" /etc/ssh/sshd_config
echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config

HOME='/root'

mkdir -p "$HOME/.ssh/"
(umask 066; touch "$HOME/.ssh/authorized_keys")

[ "$INPUT_USER_NAME" != "root" ] && HOME="/home/$INPUT_USER_NAME"
[ -n "$INPUT_PUBLIC_KEY" ] && echo "$INPUT_PUBLIC_KEY" >> "$HOME/.ssh/authorized_keys"
[ -n "$INPUT_PUBLIC_KEY_URL" ] && wget -qO- "$INPUT_PUBLIC_KEY_URL" >> "$HOME/.ssh/authorized_keys"
[ "$INPUT_USER_NAME" != "root" ] && addgroup "$INPUT_USER_NAME" && adduser --shell /bin/ash --disabled-password --home "$HOME" --ingroup "$INPUT_USER_NAME" "$INPUT_USER_NAME"
[ "$INPUT_USER_NAME" = "root" ] && sed -i -E "s/#?(PermitRootLogin).*/\1 yes/g" /etc/ssh/sshd_config
[ "$INPUT_SUDO_ACCESS" = "true" ] && sed -i -E "s/#? ?(%sudo.*?)ALL/\1NOPASSWD:ALL/g" /etc/sudoers && addgroup sudo && addgroup "$INPUT_USER_NAME" sudo
[ -n "$INPUT_USER_PASSWORD" ] && sed -i -E "s/#?(ChallengeResponseAuthentication|PasswordAuthentication).*/\1 yes/g" /etc/ssh/sshd_config
[ -z "$INPUT_USER_PASSWORD" ] && sed -i -E "s/#?(ChallengeResponseAuthentication|PasswordAuthentication).*/\1 no/g" /etc/ssh/sshd_config
[ -n "$INPUT_USER_PASSWORD" ] && (echo "$INPUT_USER_PASSWORD"; echo "$INPUT_USER_PASSWORD") | passwd "$INPUT_USER_NAME"
[ -z "$INPUT_USER_PASSWORD" ] && [ "$INPUT_USER_NAME" != "root" ] && (echo ""; echo "") | passwd "$INPUT_USER_NAME"
echo "AllowUsers $INPUT_USER_NAME" >> /etc/ssh/sshd_config

[ -z "$INPUT_USER_PASSWORD" ] && [ -z "$INPUT_PUBLIC_KEY" ] && [ -z "$INPUT_PUBLIC_KEY_URL" ] && ssh-keygen -f /tmp/test_ssh -N "" && cat /tmp/test_ssh.pub >> "$HOME/.ssh/authorized_keys" && echo "::set-secret name=ssh_private_key::$(cat /tmp/test_ssh | tr '\n' '')" && rm /tmp/test_ssh

chown -R "$INPUT_USER_NAME" "$HOME/.ssh/"