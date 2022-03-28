import { NodeSSH } from 'node-ssh';
import { optional } from './arguments';

function createSSH() {
  const ssh = new NodeSSH();
  return ssh.connect({
    host: 'localhost',
    port: parseInt(optional('port'), 10),
    username: optional('username'),
    password: optional('password'),
    privateKey: optional('private-key'),
  });
}

export default createSSH;
