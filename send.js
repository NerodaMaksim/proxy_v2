const {spawn} = require('child_process');


let pass = 'cd72B1jdfR';
let scp = spawn(`sshpass`, ['-p', pass, 'scp', '-r', './files', 'root@185.174.102.54:~'])


scp.stdin.end();