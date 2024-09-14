sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 7777 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p udp --dport 7777 -j ACCEPT
sudo netfilter-persistent save