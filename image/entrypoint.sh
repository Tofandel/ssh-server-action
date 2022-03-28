#!/bin/sh

[ -n "$INPUT_PUBLIC_KEY" ] && echo "$INPUT_PUBLIC_KEY" >> ~/.ssh/authorized_keys
[ -n "$INPUT_PUBLIC_KEY_URL" ] && wget -qO- "$INPUT_PUBLIC_KEY_URL" >> ~/.ssh/authorized_keys
[ -n "$INPUT_USER_NAME" ] && addgroup "$INPUT_USER_NAME" && adduser --shell /bin/sh --disabled-password --no-create-home --home "$(pwd)" --ingroup "$INPUT_USER_NAME" "$INPUT_USER_NAME"
[ "$INPUT_SUDO_ACCESS" = "true" ] && sed -Ei "s/(%sudo.*?)ALL/\1NOPASSWD:ALL/g" /etc/sudoers && addgroup sudo && addgroup "$INPUT_USER_NAME" sudo
[ "$INPUT_PASSWORD_ACCESS" != "true" ] && sed -iE "s/(ChallengeResponseAuthentication|PasswordAuthentication|UsePAM).*/\1 no/g" /etc/ssh/sshd_config
[ "$INPUT_PASSWORD_ACCESS" != "true" ] && [ -n "$INPUT_USER_PASSWORD" ] && (echo "$INPUT_USER_PASSWORD"; echo "$INPUT_USER_PASSWORD") | passwd "$INPUT_USER_NAME"

[ "$INPUT_PASSWORD_ACCESS" != "true" ] && [ -n "$INPUT_USER_PASSWORD" ] && [ -n "$INPUT_PUBLIC_KEY" ] && [ -n "$INPUT_PUBLIC_KEY_URL" ] ssh-keygen  -f /tmp/test_ssh -N "" && cat /tmp/test_ssh.pub >> ~/.ssh/authorized_keys && echo "::set-secret name=ssh_private_key::$(cat /tmp/test_ssh)"