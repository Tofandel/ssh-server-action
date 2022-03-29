import { expect } from 'chai';

import { NodeSSH } from 'node-ssh';
import { optional } from './arguments';

const username = optional('username') || process.env.INPUT_USER_NAME;
const password = optional('password') || process.env.INPUT_USER_PASSWORD;
const hasSudo = optional('sudo') || process.env.INPUT_SUDO_ACCESS;
const hostname = optional('hostname') || process.env.INPUT_HOSTNAME;
const debug = optional('debug') || process.env.INPUT_DEBUG;

function createSSH() {
  const ssh = new NodeSSH();
  return ssh.connect({
    host: 'localhost',
    port: parseInt(optional('port') || process.env.INPUT_PORT, 10),
    username,
    password: password || undefined,
    privateKey: !password ? optional('private-key') : undefined,
  });
}

describe('SSH', () => {
  let ssh;
  afterEach(() => {
    if (ssh) {
      ssh.dispose();
      ssh = null;
    }
  });
  it('should be online', async () => {
    const connect = createSSH();
    ssh = await connect;
    expect(ssh.isConnected()).to.be.true;
    let result = await ssh.execCommand('whoami');
    expect(result.stdout).to.be.eq(username);
    !debug && expect(result.stderr).to.be.empty;
    result = await ssh.execCommand('sudo -u root whoami');
    if (hasSudo || username === 'root') {
      expect(result.stdout).to.be.eq('root');
      !debug && expect(result.stderr).to.be.empty;
    } else {
      expect(result.stdout).to.be.empty;
      !debug && expect(result.stderr).not.to.be.empty;
    }
    result = await ssh.execCommand('hostname');
    expect(result.stdout).to.be.eq(hostname);
  });
});
