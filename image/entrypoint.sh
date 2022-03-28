#!/bin/sh

[ -n "$INPUT_HOSTNAME" ] && echo "$INPUT_HOSTNAME" > /etc/hostname
[ -n "$INPUT_PUBLIC_KEY" ] && echo "$INPUT_PUBLIC_KEY" >> ~/.ssh/authorized_keys
[ -n "$INPUT_PUBLIC_KEY_URL" ] && wget -qO- "$INPUT_PUBLIC_KEY_URL" >> ~/.ssh/authorized_keys
[ "$INPUT_USER_NAME" != "root" ] && addgroup "$INPUT_USER_NAME" && adduser --shell /bin/sh --disabled-password --no-create-home --home "$(pwd)" --ingroup "$INPUT_USER_NAME" "$INPUT_USER_NAME"
[ "$INPUT_USER_NAME" = "root" ] && sed -i -E "s/#?(PermitRootLogin).*/\1 yes/g" /etc/ssh/sshd_config
[ "$INPUT_SUDO_ACCESS" = "true" ] && sed -i -E "s/(%sudo.*?)ALL/\1NOPASSWD:ALL/g" /etc/sudoers && addgroup sudo && addgroup "$INPUT_USER_NAME" sudo
[ -n "$INPUT_USER_PASSWORD" ] && sed -i -E "s/#?(ChallengeResponseAuthentication|PasswordAuthentication).*/\1 yes/g" /etc/ssh/sshd_config
[ -z "$INPUT_USER_PASSWORD" ] && sed -i -E "s/#?(ChallengeResponseAuthentication|PasswordAuthentication).*/\1 no/g" /etc/ssh/sshd_config
[ -n "$INPUT_USER_PASSWORD" ] && (echo "$INPUT_USER_PASSWORD"; echo "$INPUT_USER_PASSWORD") | passwd "$INPUT_USER_NAME"
echo "AllowUsers $INPUT_USER_NAME" >> /etc/ssh/sshd_config

[ -n "$INPUT_USER_PASSWORD" ] && [ -n "$INPUT_PUBLIC_KEY" ] && [ -n "$INPUT_PUBLIC_KEY_URL" ] ssh-keygen  -f /tmp/test_ssh -N "" && cat /tmp/test_ssh.pub >> ~/.ssh/authorized_keys && echo "::set-secret name=ssh_private_key::$(cat /tmp/test_ssh)"

echo "Running ssh server for $INPUT_USER_NAME"
/usr/sbin/sshd -D