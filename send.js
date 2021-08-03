const {spawn} = require('child_process');


let pass = 'RkaGsDF9Aj';
let scp = spawn(`sshpass`, ['-p', pass, 'scp', '-r', './yarn.lock', 'root@185.174.102.47:~'])


scp.stdin.end();