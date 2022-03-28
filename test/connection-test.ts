import { expect } from 'chai';

import createSSH from './connection';
import { optional } from './arguments';

const username = optional('username');
const hasSudo = optional('sudo');

describe('SSH', () => {
  it('should be online', async () => {
    const connect = createSSH();
    const ssh = await connect;
    expect(ssh.isConnected()).to.be.true;
    let result = await ssh.execCommand('echo "hi from ssh"');
    expect(result.stdout).to.be.eq('hi from ssh');
    expect(result.stderr).to.be.empty;
    if (username !== 'root') {
      result = await ssh.execCommand('sudo -u root whoami');
      if (hasSudo) {
        expect(result.stdout).to.be.eq('root');
        expect(result.stderr).to.be.empty;
      } else {
        expect(result.stdout).to.be.empty;
        expect(result.stderr).not.to.be.empty;
      }
    }
  });
});
