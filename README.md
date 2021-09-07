Config file explanation

At first, connect to your server via ssh, for creating fingerprint and trying password fo correction.

1. For creating proxy over tunnel(For example used tunnelbroker, in your case names could differs from my), then config file shold look like config_tunnel.json. Where

You could get it from tunnelbocker

    - server_ipv6 - Server IPv6 Address with mask.

    - server_ipv4 - Server IPv4 Address without mask.

    - client_ipv6 - Client IPv6 Address with mask.

    - client_ipv4 - Client IPv4 Address without mask(your server ipv4).

    - routed_32_net - Routed /48. Don't look at var name, it's ok(Name depends on vps config example). If absent, click Assign /48.

    - routed_32_subnet - Routed /48. In this config net and subnet are the same.

    - ipv6_nameserver - Anycast IPv6 Caching Nameserver

    - routed_64_subnet - Don't used in config. Leave empty

________
Your server configs

    - client_getaway - Your server getaway in IPv6. Could be on your server page.

    - number_of_connections - Amount of proxies you want to get. Don't set too much. About 1000 on 1GB RAM and 0,5 CPU.

    - offset_of_socks - From with address will starts socks proxies. Http starts from 10000. If offset_of_socks is 10000, then socks will starts from 20000.

    - client_user - Username on your server. By default it is root.

    - client_password - Password of this user, for connection via ssh.
    
    - iface_name - Network interface's name. By default in Ubuntu 20.04 it's eth0. But could be different.


2. For creating proxy directly on vps(I use deltahost) wich has attached ipv6 subnet. Config file shold look like config_vps.json. Where

You could get it from provider page

    - server_ipv6 - Leave empty, in this config.

    - server_ipv4 - Leave empty.

    - client_ipv6 - IPv6 of your server. If you have subnet, then just use first ip of subnet(Example: 2a04:6ac1:2:0::/32 provider gave you, so write 2a04:6ac1:2:0::1/32) with mask.
    
    - client_ipv4 - IPv4 of your server.

    - client_getaway - Servers getaway in IPv6.

    - routed_64_subnet - Leave empty.

    - routed_32_net - If youe provider gave you not just subnet, but first and last IPv6, then it will be first 2a04:6ac1:2:0::/32 with subnet.

    - routed_32_subnet - Your server IPv6 subnet. 2a04:6ac1::/32.

    - ipv6_nameserver -  Leave empty.

    - number_of_connections - Amount of proxies you want to get. Don't set too much. About 1000 on 1GB RAM and 0,5 CPU.

    - offset_of_socks - From with address will starts socks proxies. Http starts from 10000. If offset_of_socks is 10000, then socks will starts from 20000.

    - client_user - Username on your server. By default it is root.

    - client_password - Password of this user, for connection via ssh.

    - iface_name - Network interface's name. By default in Ubuntu 20.04 it's eth0. But could be different. 
    