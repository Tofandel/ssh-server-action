import { expect } from 'chai';

import createSSH from './connection';

describe('SSH', () => {
  it('should be online', async () => {
    const connect = createSSH();
    const ssh = await connect;
    expect(ssh.isConnected()).to.be.true;
    const result = await ssh.execCommand('echo "hi from ssh"', {
      onStdout(chunk) {
        // eslint-disable-next-line no-console
        console.log('stdoutChunk', chunk.toString('utf8'));
      },
      onStderr(chunk) {
        // eslint-disable-next-line no-console
        console.log('stderrChunk', chunk.toString('utf8'));
      },
    });
    expect(result.code).to.be.eq(0);
    expect(result.stdout).not.to.be.empty;
    expect(result.stderr).to.be.empty;
  });
});
