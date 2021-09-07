const fs = require('fs');
const config = require('./config.json');
const {spawn} = require('child_process');

const header = "stacksize 6553699\n\
daemon\n\
maxconn 100000\n\
nserver 8.8.8.8\n\
nserver 8.8.4.4\n\
nscache 65536\n\
timeouts 1 5 30 60 180 1800 15 60\n\
log /var/log/3proxy\n\
auth strong";



function generateRandomQuartet(){
	return Math.floor(Math.random() * 16777215).toString(16).slice(4, 5) + Math.floor(Math.random() * 16777215).toString(16).slice(3, 4) + Math.floor(Math.random() * 16777215).toString(16).slice(2, 3) + Math.floor(Math.random() * 16777215).toString(16).slice(1, 2)
}

function generateRandomAddressArray(subnet, numOfAddresses){
	let numOfQuartetsToGenerate = 8 - subnet.split(':').filter(e => parseInt(e, 16).toString(16) === e).length;
	let array = [];
	while(array.length < numOfAddresses){
		let address = subnet.split(':').filter(e => parseInt(e, 16).toString(16) === e)
		for(let i = 0; i < numOfQuartetsToGenerate; i++){
			address.push(generateRandomQuartet())
		}
		if(!array.includes(address.join(':'))){
			array.push(address.join(':'));
		}
	}
	return array;
}


function generatePassword(){
	return Array(8).fill("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890abcdefghijklmnopqrstuvwxyz").map(function(x) { return x[Math.floor(Math.random() * x.length)] }).join('');
}

function generateUsersArray(numOfUsers){
	let users = [];
	for(let i = 1; i <= numOfUsers; i++){
		users.push(`user${i}:${generatePassword()}`);
	}
	return users;
}

function proxyList(address, users){
	let proxy = [];
	for(let i = 0; i < addresses.length; i++){
		proxy.push(`${address}:${10000 + i}:${users[i]}`);
	}
	return proxy;
}




function createConfigFile(users, adresses, proxys){
	let configFile = header;
	for(let user of users){
		configFile += `\nusers ${user.split(':')[0]}:CL:${user.split(':')[1]}`;
	}
	for(let proxy of proxys){
		configFile += `\nallow ${proxy.split(':')[2]}`;
		configFile += `\nproxy -n -a -6 -p${proxy.split(':')[1]} -i${proxy.split(':')[0]} -e${adresses[proxys.indexOf(proxy)]}`;
		configFile += `\nsocks -n -a -6 -p${Number(proxy.split(':')[1]) + Number(config.offset_of_socks)} -i${proxy.split(':')[0]} -e${adresses[proxys.indexOf(proxy)]}`;
		configFile += '\nflush';
	}
	return configFile;
}

function generateStartproxySh(){
	return `#!/bin/bash\npkill -9 3proxy > /dev/null 2>&1\necho "wait 3 second before starting proxy...."\nsleep 3s\niptables -F\nulimit -n 999999\necho "999999" > /proc/sys/fs/file-max\n/etc/3proxy/3proxy /etc/3proxy/3proxy.cfg\nif [ 0 -eq 0 ]; then\necho "Proxy started OK"\nfi`
}

function generateScriptForNetworkConfig(addresses){
	let etcNetworkInterfaces = ''
	if(config.server_ipv4 && config.server_ipv6){
		etcNetworkInterfaces = `interf=$(</etc/network/interfaces)\necho "$interf\n\nauto he-ipv6\niface he-ipv6 inet6 v4tunnel\n\taddress ${config.client_ipv6.split('/')[0]}\n\tnetmask ${config.client_ipv6.split('/')[1]}\n\tendpoint ${config.server_ipv4}\n\tlocal ${config.client_ipv4}\n\tttl 255\n\tgateway ${config.server_ipv6.split('/')[0]}" > /etc/network/interfaces`;
	}
	let addIp = '';
	for(let ip of addresses){
		addIp += `ip -6 addr add ${ip} dev ${config.iface_name}\n`;
	}
	let addIpE = `ip -6 addr add ${config.routed_32_net} dev ${config.iface_name}`
	let addR = `ip -6 route add default via ${config.server_ipv4 && config.server_ipv6 ? `${config.server_ipv6.split('/')[0]} dev he-ipv6` : config.client_gateway}`;
	let addLoR = `ip -6 route add local ${config.routed_32_subnet} dev lo`;
	let installation3proxy = `apt -y update && apt -y upgrade\napt-get -y install  build-essential git ifupdown\ncd ~\ngit clone https://github.com/z3APA3A/3proxy.git\ncd 3proxy/\nmake -f Makefile.Linux\nmkdir /etc/3proxy\nmv bin/3proxy /etc/3proxy/\ncd ~/files`
	let mv3proxyCfg = `mv ./3proxy.cfg /etc/3proxy/`;
	let addCrontabJob = '/etc/startproxy.sh'//`CRON_FILE='/var/spool/cron/root'\nif [ ! -f $CRON_FILE ]; then\n\techo "cron file for root doesnot exist, creating.."\n\ttouch $CRON_FILE\nfi\necho "32 */1 * * * /etc/startproxy.sh" > $CRON_FILE\nmv ./startproxy.sh /etc\n/usr/bin/crontab $CRON_FILE`;
	// let bashScript = `#!/bin/bash\n${etcNetworkInterfaces}\n/etc/init.d/networking restart\n${addIp}\n${addIpE}\n${addR}\n${addLoR}\n${installation3proxy}\n${mv3proxyCfg}\n${addCrontabJob}`;
	let bashScript = `#!/bin/bash\n${installation3proxy}\${etcNetworkInterfaces}\nsystemctl restart networking\n${addIp}\n${addIpE}\n${addR}\n${addLoR}\nif [ -e /etc/3proxy/3proxy ]; then\necho "3proxy installed"\nelse\nmv ~/3proxy/bin/3proxy /etc/3proxy\nfi\nif [ -e ~/files/3proxy.cfg ]; then\n${mv3proxyCfg}\nfi\nif [ -e /etc/startproxy.sh ]; then\n${addCrontabJob}\nelse\nmv ~/files/startproxy.sh /etc/startproxy.sh\n${addCrontabJob}\nfi`;

	return(bashScript);

}
	

function writeToFiles(){
	fs.writeFileSync('./files/ip.list', addresses.join('\n'), {encoding: 'utf8', flag: 'w'});
	fs.writeFileSync('./files/proxy.txt', proxys.join('\n'), {encoding: 'utf8', flag: 'w'});
	fs.writeFileSync('./files/3proxy.cfg', configFile, {encoding: 'utf8', flag: 'w'});
	fs.writeFileSync('./files/startproxy.sh', startproxy, {encoding: 'utf8', flag: 'w'});
	fs.writeFileSync('./files/script.sh', script, {encoding: 'utf8', flag: 'w'});
	fs.chmodSync('./files/startproxy.sh', '777');
	fs.chmodSync('./files/script.sh', '777');
	console.log('1');
	spawn(`sshpass`, ['-p', config.client_password, 'scp', '-r', './files', `${config.client_user}@${config.client_ipv4}:~`])
	let start = spawn(`sshpass`, ['-p', config.client_password, `ssh`, `${config.client_user}@${config.client_ipv4}`, `${config.client_user === 'root' ? `/root` : `/home/${config.client_user}`}/files/script.sh`]);
	// start.stdout.pipe(process.stdout)
	start.stdout.setEncoding('utf-8');
	start.stderr.setEncoding('utf-8');
	start.stdout.on('data', data => {
		console.log(data)
	})
	start.stderr.on('data', data => {
		console.log(data);
		if(data === 'Proxy started OK'){
			// start.disconnect();
		}
	})
	console.log(2);
}

let addresses = generateRandomAddressArray(config.routed_32_net, config.number_of_connections);
// let addresses = [...fs.readFileSync('./files2/ip.list', {encoding: 'utf8'}).split('\n'), ...generateRandomAddressArray(config.routed_48_subnet, 500)];
let users = generateUsersArray(config.number_of_connections);
let proxys = proxyList(config.client_ipv4, users);
let configFile = createConfigFile(users, addresses, proxys);
let startproxy = generateStartproxySh();
let script = generateScriptForNetworkConfig(addresses);


fs.access('./files', (error) => {
	if(!error){
		writeToFiles();
	}else{
		fs.mkdirSync('./files');
		writeToFiles()
	}
})



