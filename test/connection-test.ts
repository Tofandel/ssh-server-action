import { expect } from 'chai';

import { NodeSSH } from 'node-ssh';
import { optional } from './arguments';

const username = optional('username');
const password = optional('password');
const hasSudo = optional('sudo');
const hostname = optional('hostname');

function createSSH() {
  const ssh = new NodeSSH();
  return ssh.connect({
    host: 'localhost',
    port: parseInt(optional('port'), 10),
    username,
    password,
    privateKey: password ? optional('private-key') : undefined,
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
    expect(result.stderr).to.be.empty;
    result = await ssh.execCommand('sudo -u root whoami');
    if (hasSudo || username === 'root') {
      expect(result.stdout).to.be.eq('root');
      expect(result.stderr).to.be.empty;
    } else {
      expect(result.stdout).to.be.empty;
      expect(result.stderr).not.to.be.empty;
    }
    result = await ssh.execCommand('hostname');
    expect(result.stdout).to.be.eq(hostname);
  });
});
